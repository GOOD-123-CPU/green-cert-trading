# API 接口文档

> 交互式文档：启动后端后访问 <http://localhost:1234/swagger-ui.html>（SpringDoc OpenAPI 自动生成，生产环境可通过环境变量关闭）。

## 通用约定

### Base URL

```
http://localhost:1234/api
```

### 统一响应格式

```json
{
  "code": "0",       // "0" 成功；"-1" 业务失败
  "msg": "成功",
  "data": {}         // 业务数据，失败时可为 null
}
```

### 认证

除白名单接口外，所有请求需携带请求头：

```
token: <JWT令牌>
```

JWT 由登录接口颁发，有效期 2 小时。

### 白名单（无需认证）

`/user/login`、`/user/register`、`/user/forget`、`/user/public-key` 等（完整清单见 `WebConfig.java`）。

## 登录与认证

### 获取 RSA 公钥

```http
GET /api/user/public-key
```

```json
{ "code": "0", "msg": "成功", "data": { "publicKey": "-----BEGIN PUBLIC KEY-----..." } }
```

### 登录

```http
POST /api/user/login
Content-Type: application/json

{
  "username": "Sadmin",
  "password": "RSA:Base64密文"
}
```

- `password` 需先用公钥 RSA 加密（`RSA/ECB/PKCS1Padding`），再 Base64 编码，前缀 `RSA:`
- 也接受明文（仅限开发调试，生产务必走 RSA）

**成功响应**：`data` 含 `token`、`userMenuList`（后台菜单）、用户信息。
**错误响应**：

| 场景 | msg |
|---|---|
| 用户名或密码错误 | 用户名或密码错误 |
| 连续失败 5 次（15 分钟内） | 登录失败次数过多，账号已锁定，请 X 分钟后重试 |

### 修改密码

```http
PUT /api/user/password/{id}
```

## 业务模块一览

| 模块 | 前缀 | 主要端点（节选） |
|---|---|---|
| 商品 | `/product` | 分页查询、详情、新增/编辑/上下架、折扣设置 |
| 分类 | `/category` | 树形分类 CRUD |
| 购物车 | `/cart` | 增删改查、按用户清空 |
| 订单 | `/order` | 下单、支付、发货、确认收货、退款申请/审核 |
| 收藏 | `/favorite` | 收藏/取消、按用户查询 |
| 评价 | `/review` | 发表评价（1-5 星）、审核、按商品查询 |
| 拼团 | `/group-buying` | 活动分页/详情、**参团**（自动成团）、参团成员 |
| 长期协议 | `/long-term-agreement` | 月/季/年协议签约申请、审核 |
| 推荐 | `/recommend` | 个性化推荐（协同过滤，每日预计算） |
| 文章 | `/article` | 资讯分页、详情、浏览量 |
| 轮播图 | `/carousel-item` | 首页轮播 CRUD |
| 公告 | `/notice` | 公告 CRUD |
| 物流 | `/logistics` | 发货登记、轨迹查询 |
| 出入库 | `/stock` | 入库/出库流水 |
| 用户 | `/user` | CRUD、按角色查询、批量删除 |
| 菜单 | `/menu` | 菜单树、角色授权 |
| 统计 | `/statistics` | 后台数据概览（销售额、订单量趋势） |
| 文件 | `/file` | 图片上传（返回可访问 URL） |
| 地址 | `/address` | 收货地址 CRUD |

> 完整参数与响应结构请以 Swagger UI 为准，本文档仅作导航。

## 错误码与 HTTP 状态

| HTTP | 场景 | 前端行为 |
|---|---|---|
| 200 | 正常（业务成败看 `code`） | 按 `code` 分支处理 |
| 401 | token 缺失/过期 | 清理会话，跳转登录页 |
| 403 | 无权限访问 | 提示无权限 |
| 500 | 服务端异常 | 统一提示（detail 不外泄） |

## 调试建议

1. 本地启动后端与前端（前端 devServer 已代理 `/api`）
2. 打开 Swagger UI 直接调试，或在前端登录后从 localStorage 复制 token 到 Swagger 的 Authorize
