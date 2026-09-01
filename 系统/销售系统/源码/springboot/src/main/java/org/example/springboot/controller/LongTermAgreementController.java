package org.example.springboot.controller;

import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.entity.LongTermAgreement;
import org.example.springboot.service.LongTermAgreementService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

/**
 * 长期购买协议接口
 */
@RestController
@RequestMapping("/agreement")
public class LongTermAgreementController {
    @Resource
    private LongTermAgreementService agreementService;

    @GetMapping("/page")
    public Result<?> page(@RequestParam(defaultValue = "1") Integer currentPage,
                          @RequestParam(defaultValue = "10") Integer size,
                          @RequestParam(required = false) String type,
                          @RequestParam(required = false) Integer status,
                          @RequestParam(required = false) Long userId) {
        return agreementService.page(currentPage, size, type, status, userId);
    }

    /**
     * 提交签约申请（需登录）
     */
    @PostMapping("/apply")
    public Result<?> apply(@RequestBody LongTermAgreement agreement) {
        var user = JwtTokenUtils.getCurrentUser();
        if (user == null) {
            return Result.error("401", "请先登录");
        }
        return agreementService.apply(agreement, user.getId());
    }

    /**
     * 审核（管理员）
     */
    @PutMapping("/{id}/review")
    public Result<?> review(@PathVariable Long id,
                            @RequestParam Integer status,
                            @RequestParam(required = false) String remark) {
        return agreementService.review(id, status, remark);
    }
}
