package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.entity.LongTermAgreement;
import org.example.springboot.mapper.LongTermAgreementMapper;
import org.springframework.stereotype.Service;

/**
 * 长期购买协议服务
 */
@Service
public class LongTermAgreementService {
    @Resource
    private LongTermAgreementMapper agreementMapper;

    public Result<?> page(int currentPage, int size, String type, Integer status, Long userId) {
        Page<LongTermAgreement> page = new Page<>(currentPage, size);
        LambdaQueryWrapper<LongTermAgreement> wrapper = new LambdaQueryWrapper<>();
        if (type != null && !type.isBlank()) {
            wrapper.eq(LongTermAgreement::getType, type);
        }
        if (status != null) {
            wrapper.eq(LongTermAgreement::getStatus, status);
        }
        if (userId != null) {
            wrapper.eq(LongTermAgreement::getUserId, userId);
        }
        wrapper.orderByDesc(LongTermAgreement::getCreatedAt);
        return Result.success(agreementMapper.selectPage(page, wrapper));
    }

    /**
     * 提交签约申请（需登录）
     */
    public Result<?> apply(LongTermAgreement agreement, Long userId) {
        if (agreement.getCompanyName() == null || agreement.getCompanyName().isBlank()) {
            return Result.error("-1", "企业名称不能为空");
        }
        if (agreement.getQuantity() == null || agreement.getQuantity() <= 0) {
            return Result.error("-1", "采购数量必须大于0");
        }
        agreement.setId(null);
        agreement.setUserId(userId);
        agreement.setStatus(0); // 待审核
        agreementMapper.insert(agreement);
        return Result.success("签约申请已提交，请等待审核");
    }

    /**
     * 审核签约申请（管理员）
     */
    public Result<?> review(Long id, Integer status, String remark) {
        LongTermAgreement agreement = agreementMapper.selectById(id);
        if (agreement == null) {
            return Result.error("-1", "协议申请不存在");
        }
        agreement.setStatus(status);
        if (remark != null) {
            agreement.setRemark(remark);
        }
        agreementMapper.updateById(agreement);
        return Result.success();
    }
}
