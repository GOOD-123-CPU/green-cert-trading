package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.springboot.common.Result;
import org.example.springboot.entity.GroupBuying;
import org.example.springboot.entity.GroupBuyingMember;
import org.example.springboot.entity.Product;
import org.example.springboot.mapper.GroupBuyingMapper;
import org.example.springboot.mapper.GroupBuyingMemberMapper;
import org.example.springboot.mapper.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 绿证拼团服务
 */
@Service
public class GroupBuyingService {
    private final GroupBuyingMapper groupBuyingMapper;
    private final GroupBuyingMemberMapper memberMapper;
    private final ProductMapper productMapper;

    /** 构造器注入（便于单元测试）；Spring 4.3+ 单构造器自动注入 */
    public GroupBuyingService(GroupBuyingMapper groupBuyingMapper,
                              GroupBuyingMemberMapper memberMapper,
                              ProductMapper productMapper) {
        this.groupBuyingMapper = groupBuyingMapper;
        this.memberMapper = memberMapper;
        this.productMapper = productMapper;
    }

    public Result<?> page(int currentPage, int size, Integer status) {
        Page<GroupBuying> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<GroupBuying> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(GroupBuying::getStatus, status);
        }
        wrapper.orderByAsc(GroupBuying::getStatus).orderByAsc(GroupBuying::getEndTime);
        Page<GroupBuying> result = groupBuyingMapper.selectPage(page, wrapper);
        // 填充商品信息
        result.getRecords().forEach(this::fillProduct);
        return Result.success(result);
    }

    public Result<?> getById(Long id) {
        GroupBuying group = groupBuyingMapper.selectById(id);
        if (group == null) {
            return Result.error("-1", "拼团活动不存在");
        }
        fillProduct(group);
        return Result.success(group);
    }

    /**
     * 参团：校验活动有效性与重复参团，写入参与记录并累加人数
     */
    @Transactional
    public Result<?> join(Long groupId, Long userId, GroupBuyingMember member) {
        GroupBuying group = groupBuyingMapper.selectById(groupId);
        if (group == null) {
            return Result.error("-1", "拼团活动不存在");
        }
        if (group.getStatus() != 0) {
            return Result.error("-1", "该拼团已结束");
        }
        if (group.getEndTime() != null && group.getEndTime().before(new java.util.Date())) {
            return Result.error("-1", "该拼团已过期");
        }
        // 防止重复参团
        Long joined = memberMapper.selectCount(new LambdaQueryWrapper<GroupBuyingMember>()
                .eq(GroupBuyingMember::getGroupId, groupId)
                .eq(GroupBuyingMember::getUserId, userId));
        if (joined > 0) {
            return Result.error("-1", "您已参与过该拼团");
        }
        member.setGroupId(groupId);
        member.setUserId(userId);
        memberMapper.insert(member);
        group.setCurrentCount(group.getCurrentCount() + member.getQuantity());
        if (group.getCurrentCount() >= group.getTargetCount()) {
            group.setStatus(1); // 已成团
        }
        groupBuyingMapper.updateById(group);
        return Result.success("参团成功");
    }

    public Result<?> members(Long groupId) {
        List<GroupBuyingMember> list = memberMapper.selectList(
                new LambdaQueryWrapper<GroupBuyingMember>().eq(GroupBuyingMember::getGroupId, groupId));
        return Result.success(list);
    }

    private void fillProduct(GroupBuying group) {
        if (group.getProductId() != null) {
            Product product = productMapper.selectById(group.getProductId());
            group.setProduct(product);
        }
    }
}
