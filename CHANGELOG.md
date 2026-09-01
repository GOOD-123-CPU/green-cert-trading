# 更新日志（Changelog）

本项目的所有显著变更都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

## [1.0.0] - 2026-09-01

首个开源版本。

### Added 新增

- 前台商城：商品浏览/搜索/详情、购物车、下单、支付状态流转、退款、收藏、评价
- 绿证拼团：多人拼团、达标自动成团、防重复参团
- 临期促销：折扣专区、按折扣力度排序
- 长期购买协议：月度/季度/年度在线签约申请
- 智能推荐：基于订单+收藏行为的协同过滤推荐，每日定时更新
- 后台管理：数据概览（ECharts）、商品/分类/订单/物流/出入库/用户/菜单权限/轮播图/公告管理
- 多角色动态菜单：`SUPER_ADMIN` / `ADMIN` / `SELLER` / `BUYER`
- 安全：BCrypt 密码散列、RSA 2048 登录传输加密、JWT 认证、登录防爆破锁定
- 可观测性：AOP 全链路请求日志（traceId）、慢请求告警（>2s）
- API 文档：SpringDoc OpenAPI（/swagger-ui.html）
- 单元测试：JUnit 5 + Mockito（验证码流程、登录锁定、RSA 加解密、拼团业务闭环）
- CI：GitHub Actions（后端 Maven 构建+测试、前端 Lint+构建）
- 部署：Docker / Docker Compose 一键编排（MySQL + 后端 + Nginx 前端）

### Changed 变更

- 前端整体从 Vue 2 + vue-cli 迁移至 **Vue 3.4 + Vite 5 + Element Plus 2.9**
- 提供 `el-icon-*` 字体图标兼容层（280 个码点），存量模板零成本迁移
- 所有敏感配置外部化为环境变量（数据库、JWT、SMTP、RSA 密钥）

### Removed 移除

- 移除 Vue 2 旧版前端工程（由 `源码/vue3/` 完全替代）
- 移除仓库内一切硬编码密钥与真实个人信息

### Security 安全

- 登录接口默认启用 RSA 加密传输（前端经 `/api/user/public-key` 获取公钥）
- 登录失败防爆破：同一用户名 15 分钟内失败 5 次 → 锁定 15 分钟
- 全局异常处理统一响应格式，避免内部堆栈泄露
