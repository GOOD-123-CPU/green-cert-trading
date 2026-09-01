package org.example.springboot.controller;

import jakarta.annotation.Resource;
import org.example.springboot.common.Result;
import org.example.springboot.entity.GroupBuyingMember;
import org.example.springboot.service.GroupBuyingService;
import org.example.springboot.util.JwtTokenUtils;
import org.springframework.web.bind.annotation.*;

/**
 * 绿证拼团接口
 */
@RestController
@RequestMapping("/group-buying")
public class GroupBuyingController {
    @Resource
    private GroupBuyingService groupBuyingService;

    @GetMapping("/page")
    public Result<?> page(@RequestParam(defaultValue = "1") Integer currentPage,
                          @RequestParam(defaultValue = "10") Integer size,
                          @RequestParam(required = false) Integer status) {
        return groupBuyingService.page(currentPage, size, status);
    }

    @GetMapping("/{id}")
    public Result<?> getById(@PathVariable Long id) {
        return groupBuyingService.getById(id);
    }

    /**
     * 参团（需登录，用户ID从 token 中解析，防止伪造）
     */
    @PostMapping("/{id}/join")
    public Result<?> join(@PathVariable Long id, @RequestBody GroupBuyingMember member) {
        var user = JwtTokenUtils.getCurrentUser();
        if (user == null) {
            return Result.error("401", "请先登录");
        }
        return groupBuyingService.join(id, user.getId(), member);
    }

    @GetMapping("/{id}/members")
    public Result<?> members(@PathVariable Long id) {
        return groupBuyingService.members(id);
    }
}
