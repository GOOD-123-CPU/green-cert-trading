package org.example.springboot;

import org.example.springboot.entity.GroupBuying;
import org.example.springboot.entity.GroupBuyingMember;
import org.example.springboot.mapper.GroupBuyingMapper;
import org.example.springboot.mapper.GroupBuyingMemberMapper;
import org.example.springboot.mapper.ProductMapper;
import org.example.springboot.service.GroupBuyingService;
import org.example.springboot.common.Result;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Timestamp;
import java.util.Calendar;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * 拼团服务单元测试（Mock 数据层，验证核心业务闭环）
 * <p>
 * 覆盖：参团成功并自动成团、重复参团拦截、已结束拦截、已过期拦截。
 * 纯 Mockito 测试，不依赖 Spring 容器与数据库，可在 CI 中稳定运行。
 */
class GroupBuyingServiceTests {

    private GroupBuyingMapper groupMapper = mock(GroupBuyingMapper.class);
    private GroupBuyingMemberMapper memberMapper = mock(GroupBuyingMemberMapper.class);
    private ProductMapper productMapper = mock(ProductMapper.class);
    private GroupBuyingService service = new GroupBuyingService(groupMapper, memberMapper, productMapper);

    /** 构造一个进行中（status=0）且未过期的拼团活动 */
    private GroupBuying activeGroup(int current, int target) {
        GroupBuying g = new GroupBuying();
        g.setId(1L);
        g.setStatus(0);
        g.setCurrentCount(current);
        g.setTargetCount(target);
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 7);
        g.setEndTime(new Timestamp(cal.getTimeInMillis()));
        return g;
    }

    @Test
    @DisplayName("参团成功：人数累加并在达标后自动成团")
    void join_successAndAutoComplete() {
        GroupBuying group = activeGroup(4, 5);
        when(groupMapper.selectById(1L)).thenReturn(group);
        when(memberMapper.selectCount(any())).thenReturn(0L);
        when(memberMapper.insert(any(GroupBuyingMember.class))).thenReturn(1);
        when(groupMapper.updateById(any(GroupBuying.class))).thenReturn(1);

        GroupBuyingMember member = new GroupBuyingMember();
        member.setQuantity(1);
        Result<?> result = service.join(1L, 99L, member);

        assertEquals("0", result.getCode());
        assertEquals(5, group.getCurrentCount());
        assertEquals(1, group.getStatus(), "达标后应自动置为已成团");
        verify(memberMapper).insert(any(GroupBuyingMember.class));
        verify(groupMapper).updateById(group);
    }

    @Test
    @DisplayName("重复参团被拒绝")
    void join_rejectsDuplicate() {
        when(groupMapper.selectById(1L)).thenReturn(activeGroup(1, 5));
        when(memberMapper.selectCount(any())).thenReturn(1L);

        Result<?> result = service.join(1L, 99L, new GroupBuyingMember());
        assertEquals("-1", result.getCode());
        verify(memberMapper, never()).insert(any(GroupBuyingMember.class));
    }

    @Test
    @DisplayName("已结束的拼团不可参团")
    void join_rejectsFinishedGroup() {
        GroupBuying finished = activeGroup(0, 5);
        finished.setStatus(1); // 已成团
        when(groupMapper.selectById(1L)).thenReturn(finished);

        Result<?> result = service.join(1L, 99L, new GroupBuyingMember());
        assertEquals("-1", result.getCode());
    }

    @Test
    @DisplayName("已过期拼团不可参团")
    void join_rejectsExpiredGroup() {
        GroupBuying expired = activeGroup(0, 5);
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -1);
        expired.setEndTime(new Timestamp(cal.getTimeInMillis()));
        when(groupMapper.selectById(1L)).thenReturn(expired);

        Result<?> result = service.join(1L, 99L, new GroupBuyingMember());
        assertEquals("-1", result.getCode());
    }
}
