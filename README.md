# 绿证交易平台（Green Certificate Trading Platform）

> 基于 Spring Boot 3、Vue 3、Element Plus 和 Vite 的绿色电力证书（绿证）交易系统。
> 项目包含前台商城、后台管理、拼团、临期促销、长期协议和协同过滤推荐等功能，可用于学习、课程设计与二次开发。

[![CI](https://github.com/GOOD-123-CPU/green-cert-trading/actions/workflows/ci.yml/badge.svg)](./.github/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-17%2B-orange.svg)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.x-6DB33F.svg)](https://spring.io/projects/spring-boot)
[![Vue](https://img.shields.io/badge/Vue-3.4.x-4FC08D.svg)](https://vuejs.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**English** | A full-stack green electricity certificate (GEC) trading system built with Spring Boot 3 and Vue 3. It includes a customer-facing marketplace, an admin console, role-based menus, group buying, promotions and recommendation features.

---

## ✨ 功能特性

### 前台商城

| 模块 | 说明 |
|---|---|
| 🏠 首页 | 轮播图、公告、分类导航、热门/新品推荐 |
| 📋 商品 | 绿证列表（多条件筛选/排序/分页）、商品详情、搜索 |
| 🛒 交易 | 购物车、下单、支付状态流转、退款申请 |
| ❤️ 收藏与评价 | 评分 1-5 星，评价审核机制 |
| 🤝 绿证拼团 | 多人拼团成团享优惠，达标自动成团（前后端完整闭环） |
| ⏰ 临期促销 | 折扣绿证专区，按折扣力度排序 |
| 📜 长期购买协议 | 月度/季度/年度协议在线签约申请 |
| 📰 资讯文章 | 绿证知识、政策解读 |
| 🧠 智能推荐 | 基于订单+收藏行为的协同过滤推荐（每日定时更新） |

### 后台管理（按角色动态菜单）

- 数据概览（ECharts 可视化）、商品管理（含折扣/上下架/库存）、分类管理
- 订单管理、物流管理、出入库管理
- 用户管理（多角色）、菜单权限管理、轮播图与公告管理
- 角色体系：`SUPER_ADMIN` / `ADMIN` / `SELLER`（卖方）/ `BUYER`（买方）

### 🔐 安全特性

- **BCrypt 密码散列**（强度 10），数据库不存明文
- **RSA 2048 登录字段加密**：前端经 `GET /api/user/public-key` 获取公钥，密码以 `RSA:` + Base64 密文上送。该机制不能替代 HTTPS；未认证的公钥传输无法防止中间人替换公钥。
- **JWT 无状态认证**（HMAC256，2 小时过期），服务端统一密钥经环境变量注入
- **登录防爆破锁定**：同一用户名 15 分钟内失败 5 次 → 锁定 15 分钟
- **AOP 请求日志 + traceId**：全链路日志关联，慢请求（>2s）自动 WARN
- **全局异常处理**：参数校验（`@Validated`）、格式错误统一响应格式

## 🏗️ 系统架构

> 为保证 GitHub、Gitee 及各种 Markdown 阅读器都能正常显示，此处使用纯文本架构图，不依赖 Mermaid 插件。

```text
Browser
  |
  | HTTP :8080
  v
Nginx
  |-- serves Vue 3 static files
  |
  | /api reverse proxy
  v
Spring Boot 3 :1234
  |-- Controller -> Service -> Mapper
  |-- JWT authentication / RSA login decrypt
  |-- AOP request logging with traceId
  |-- Caffeine cache (captcha and login lock)
  |
  v
MySQL 8.4 (utf8mb4)
```

| 组件 | 主要职责 |
|---|---|
| Vue 3 + Element Plus | 前台商城和后台管理界面 |
| Nginx | 托管前端静态资源，并将 `/api` 请求转发到后端 |
| Spring Boot 3 | 业务接口、认证鉴权、参数校验和日志记录 |
| MyBatis-Plus | 数据访问与对象映射 |
| MySQL 8.4 | 业务数据和演示数据持久化 |
| Caffeine | 验证码、登录失败次数和登录锁定等本地缓存 |

## 🛠️ 技术栈

| 层级 | 技术 | 选型理由 |
|---|---|---|
| 后端 | Spring Boot 3.4.1（Java 17+） | 成熟的 Web 生态，便于构建和测试 |
| ORM | MyBatis-Plus 3.5 | CRUD 零样板代码，Lambda 条件构造器类型安全 |
| 认证 | java-jwt（HMAC256）+ 拦截器 | 无状态水平扩展；密钥环境变量注入 |
| 缓存 | Caffeine | 进程内高性能缓存，零部署成本，适合单实例起步 |
| 文档 | SpringDoc OpenAPI 2.7 | 自动生成 Swagger UI，前后端并行开发 |
| 前端 | Vue 3.4 + Vite 5 + Element Plus 2.9 | Composition API 生态、秒级冷启动 |
| 状态 | Vue Router 4 + Vuex 4 | 官方推荐组合 |
| 数据库 | MySQL 8.4（utf8mb4） | 完整 Unicode 支持 |
| 部署 | Docker Compose + GitHub Actions CI | 本地容器编排，提交后自动检查构建 |

## 🚀 快速开始

### 方式一：Docker Compose（推荐）

当前 Compose 会把本地生成的 `vue3/dist` 挂载到 Nginx，因此第一次启动前需要先构建前端。

**Windows PowerShell（在仓库根目录执行）**

```powershell
# 1. 创建本地环境配置；.env 已被 Git 忽略
Copy-Item .env.example 系统/销售系统/.env

# 2. 安装依赖并构建前端
Set-Location 系统/销售系统/源码/vue3
npm.cmd ci
npm.cmd run build

# 3. 返回 Compose 所在目录并启动三个容器
Set-Location ../..
docker compose up -d --build
```

**macOS / Linux（在仓库根目录执行）**

```bash
# 1. 创建本地环境配置；.env 已被 Git 忽略
cp .env.example 系统/销售系统/.env

# 2. 安装依赖并构建前端
(cd 系统/销售系统/源码/vue3 && npm ci && npm run build)

# 3. 启动 MySQL、后端和 Nginx
cd 系统/销售系统
docker compose up -d --build
```

启动完成后访问：

| 服务 | 地址 |
|---|---|
| 前台商城 / 后台管理 | <http://localhost:8080> |
| 后端 API | <http://localhost:1234/api> |
| Swagger UI | <http://localhost:1234/swagger-ui.html> |

查看容器状态或停止服务：

```bash
docker compose ps
docker compose down
```

### 方式二：本地开发

**1. 数据库**

```sql
CREATE DATABASE db_aps DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- 然后导入 系统/销售系统/数据库/db_aps_绿证版.sql
```

**2. 后端（JDK 17+，端口 1234）**

```bash
cd 系统/销售系统/源码/springboot
# 通过环境变量注入配置（不要把真实密码写进配置文件）
export DB_PASSWORD=你的数据库密码
export APP_JWT_SECRET=$(openssl rand -hex 32)
mvn spring-boot:run
```

Windows PowerShell 请使用下面的环境变量写法：

```powershell
Set-Location 系统/销售系统/源码/springboot
$env:DB_PASSWORD = "你的数据库密码"
$env:APP_JWT_SECRET = "请替换为至少 32 字节的随机字符串"
mvn spring-boot:run
```

**3. 前端（Node 18+，Vite 开发端口 8081）**

```bash
cd 系统/销售系统/源码/vue3
npm ci
npm run dev
# vite devServer 已配置 /api 代理到 http://localhost:1234
```

Windows PowerShell 中如遇脚本执行策略限制，请将 `npm` 改为 `npm.cmd`。

### 演示账号

| 角色 | 用户名 | 密码 |
|---|---|---|
| 超级管理员 | `Sadmin` | `123456` |
| 卖方（商户） | `seller` | `123456` |
| 买方 | `user` | `123456` |

> ⚠️ 演示密码仅用于本地体验，生产环境请务必修改并启用强密码策略。

## ⚙️ 配置说明（环境变量）

所有敏感配置均已外部化，通过环境变量注入，**仓库内不含任何真实密钥**：

| 环境变量 | 说明 | 示例 |
|---|---|---|
| `DB_HOST` / `DB_PORT` / `DB_NAME` | 数据库地址/端口/库名 | `localhost` / `3306` / `db_aps` |
| `DB_USER` / `DB_PASSWORD` | 数据库账号/密码 | `root` / `******` |
| `APP_JWT_SECRET` | JWT 签名密钥（必改） | `openssl rand -hex 32` 生成 |
| `APP_RSA_PRIVATE_KEY` / `APP_RSA_PUBLIC_KEY` | RSA 登录加密密钥对（多实例必配） | Base64(PKCS#8) |
| `APP_DEFAULT_PASSWORD` | 新用户默认密码 | 强密码 |
| `MAIL_HOST` / `MAIL_USERNAME` / `MAIL_PASSWORD` | SMTP 邮件服务 | SMTP 授权码 |
| `APP_FROM_EMAIL` | 发件邮箱 | `noreply@example.com` |
| `SPRINGDOC_API_DOCS_ENABLED` / `SPRINGDOC_SWAGGER_UI_ENABLED` | 生产环境关闭 API 文档 | `false` |

> 💡 RSA 密钥未配置时，单实例开发模式会启动自动生成（每次重启失效）；生产多实例请固定注入同一对密钥。

## 📁 项目结构

```
├── 系统/销售系统/
│   ├── 数据库/
│   │   └── db_aps_绿证版.sql       # 建表和演示数据
│   ├── 源码/
│   │   ├── springboot/             # Spring Boot 后端工程
│   │   │   ├── src/main/java/      # 业务代码
│   │   │   └── src/test/java/      # JUnit 5 + Mockito 测试
│   │   ├── vue3/                   # Vue 3 前端工程
│   │   │   ├── src/views/front/    # 前台商城页面
│   │   │   └── eslint.config.js    # ESLint 9 配置
│   │   └── Dockerfile              # 后端和前端多阶段构建
│   ├── docker-compose.yml           # MySQL、后端和 Nginx 编排
│   └── nginx.conf                   # 静态资源和 API 反向代理
├── docs/                        # 架构 / API / 部署文档
├── .github/workflows/ci.yml     # Maven 测试、前端检查与构建
├── .env.example                 # 本地环境变量示例
└── SECURITY.md / CHANGELOG.md / CONTRIBUTING.md / LICENSE
```

## 🧪 测试

```bash
# 后端单元测试（JUnit 5 + Mockito，无需数据库）
(cd 系统/销售系统/源码/springboot && mvn test)

# 前端代码检查与构建
(cd 系统/销售系统/源码/vue3 && npm run lint && npm run build)
```

在 Windows PowerShell 中可分别进入对应目录，使用 `mvn test`、`npm.cmd run lint` 和 `npm.cmd run build`。

## 🌐 关于 GitHub 在线预览

GitHub 仓库页面用于查看源码、README 和 CI 结果，本身不会运行 Java 后端、MySQL 或完整业务系统。GitHub Pages 只能托管静态前端，不能单独承载本项目的 Spring Boot 和 MySQL 服务。

需要在线体验完整系统时，请将前端、后端和数据库部署到服务器或支持容器的云平台，再把公开访问地址填写到仓库右侧的 **About → Website**。在部署完成前，README 中不应填写不存在的演示地址。

## ❓ FAQ

<details>
<summary><b>登录接口返回 500 / RSA 解密失败？</b></summary>

多实例部署未统一 RSA 密钥。请为每个实例注入相同的 `APP_RSA_PRIVATE_KEY` / `APP_RSA_PUBLIC_KEY`，或单实例开发时直接不配置（自动生成）。
</details>

<details>
<summary><b>前端页面刷新后 404？</b></summary>

Nginx 已配置 SPA `try_files` 回退；本地开发请确认使用 `npm run dev`（Vite history 回退内置）。
</details>

<details>
<summary><b>如何新增一个后台菜单？</b></summary>

菜单由数据库驱动：在 `menu` 表插入记录（含 `path`/`pagePath`），并给角色授权即可，前端动态注册路由，无需改代码。
</details>

<details>
<summary><b>邮件验证码发不出去？</b></summary>

检查 `MAIL_HOST/MAIL_USERNAME/MAIL_PASSWORD` 环境变量；QQ 邮箱需在设置中开启 SMTP 并使用「授权码」而非登录密码。
</details>

## 🗺️ 路线图

- [x] 前端升级 Vue 3 + Vite + Element Plus（含 el-icon-* 字体图标兼容层，存量模板零成本迁移）
- [x] SpringDoc OpenAPI 接口文档（/swagger-ui.html）
- [x] RSA 加密登录 + 登录防爆破锁定
- [x] AOP 全链路请求日志（traceId）
- [x] 后端单元测试（JUnit 5 + Mockito）与 CI 集成
- [x] ESLint 9 + Prettier 前端工程化
- [ ] 接入真实绿证核销/溯源接口
- [ ] 支付宝/微信支付沙箱对接
- [ ] Redis 分布式缓存与验证码存储
- [ ] i18n 多语言支持

## 🤝 贡献

欢迎 Issue 与 PR！提交前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)，并确保：

1. 不引入任何真实密钥/个人数据
2. 遵循现有代码风格（后端 UTF-8，前端 ESLint 通过）
3. `mvn test` 与 `npm run build` 通过

## 📄 许可证

[MIT](LICENSE)

## ⚠️ 免责声明

本项目为开源学习/二次开发模板。绿色电力证书的实际交易、核销须遵守国家能源局及国家可再生能源信息管理中心的官方规则，请勿直接用于真实交易场景。

---

⭐ 如果这个项目对你有帮助，欢迎点个 Star 支持一下！
