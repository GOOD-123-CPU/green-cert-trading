# 绿证交易平台前端（Vue 3 + Vite + Element Plus）

基于 Vue 3.4 / Vite 5 / Element Plus 2.x 的绿证（可再生能源绿色电力证书）在线交易平台前端。

## 技术栈

| 依赖 | 版本 | 说明 |
| --- | --- | --- |
| Vue | ^3.4 | 组合式 API 兼容 Options API 写法 |
| Vite | ^5.4 | 开发服务器与构建工具 |
| Element Plus | ^2.9 | UI 组件库（中文语言包） |
| Vue Router | ^4.4 | 路由（history 模式 + 动态路由） |
| Vuex | ^4.1 | 状态管理 |
| ECharts | ^5.6 | 数据统计图表 |
| wangEditor | ^5.1 | 富文本编辑器（Vue3 版） |
| DOMPurify | ^3.2 | 富文本 XSS 消毒 |
| ESLint + Prettier | 9 / 3 | 代码规范（flat config） |

## 快速开始

```bash
# 安装依赖（推荐 Node.js 18+）
npm install

# 启动开发服务器（默认 http://localhost:8081，API 代理到 http://localhost:1234）
npm run dev

# 生产构建（产物在 dist/）
npm run build

# 代码检查 / 自动修复 / 格式化
npm run lint
npm run lint:fix
npm run format
```

> 后端启动方式见仓库根目录 README。前端开发服务器已配置 `/api` 代理，无需处理跨域。

## 工程化说明

- **多环境**：`.env.development` / `.env.production` 注入 `VITE_API_BASE_URL`（默认 `/api`），
  axios baseURL 与全局 `HOST` 均从环境变量读取；本地调试可建 `.env.local` 覆盖
- **代理目标可配**：`vite.config.js` 读取 `VITE_PROXY_TARGET`（默认 `http://localhost:1234`）
- **ESLint 9 flat config**（`eslint.config.js`）：`vue/essential` + 推荐规则集，
  已开启 `vue/no-mutating-props` 等防护；CI 中 `npm run lint` 与构建同跑
- **路由守卫**：
  - 前台页面：`meta.requiresAuth` 检查 `frontUser`
  - 后台页面：动态注册的 Layout 子路由要求 `backUser` 与 `userMenuList` 同时存在，残缺会话自动清理并回到登录页
- **Node 版本约束**：`package.json` 中 `engines.node >= 18`

## 目录结构

```
vue3/
├── index.html                  # 入口 HTML（zh-CN）
├── vite.config.js              # Vite 配置（@ 别名 + /api 代理 + 分包）
├── eslint.config.js            # ESLint 9 flat config
├── .prettierrc.json            # Prettier 规则（与 ESLint 无冲突）
├── .editorconfig               # 跨编辑器统一缩进/换行
└── src/
    ├── main.js                 # 应用入口（绿色主题 + 中文 locale + 图标注册）
    ├── App.vue
    ├── router/                 # 路由（静态前台 + 登录后动态注册后台 + 双守卫）
    ├── store/                  # Vuex 4
    ├── utils/request.js        # axios 封装（token 注入 / 错误去重 / 401 自动登出）
    ├── styles/
    │   ├── index.css           # Element Plus 绿色主题定制（CSS 变量覆盖）
    │   └── element-ui-icon-compat.css  # el-icon-* 字体图标兼容层
    ├── layout/                 # 后台布局 / 登录注册布局
    ├── components/             # 通用组件（分页/上传/验证码/数字滚动等）
    └── views/
        ├── front/              # 前台商城页面（首页/商品/拼团/促销/长期协议…）
        └── *.vue               # 后台管理页面
```

## 迁移说明（Vue 2 → Vue 3）

本项目由 Vue 2.6 + Element UI 2.15 迁移而来，关键适配点：

- **构建系统**：vue-cli 5 (Webpack) → Vite 5，`process.env.BASE_URL` 等用法已移除
- **图标兼容**：Element Plus 移除了 `el-icon-*` 字体图标，本项目通过
  `styles/element-ui-icon-compat.css` 保留字体图标类名（码点取自 element-ui 2.15.14），
  存量模板零改动可用；新代码建议使用 `@element-plus/icons-vue`
- **插槽语法**：`slot="footer"` → `#footer`、`slot-scope="x"` → `#default="x"`
- **弹窗**：`:visible.sync` → `v-model`
- **菜单**：`el-submenu` → `el-sub-menu`
- **按钮**：`type="text"` → `link type="primary"`、`size="mini"` → `size="small"`
- **过滤器**：Vue3 移除管道过滤器，改为方法调用
- **动态路由**：vue-router 4 的 `addRoute` 幂等注册（`hasRoute` 判断）

## 环境变量

| 变量 | 默认 | 说明 |
|---|---|---|
| `VITE_API_BASE_URL` | `/api` | axios baseURL 与全局 HOST |
| `VITE_PROXY_TARGET` | `http://localhost:1234` | devServer 代理目标 |
| `VITE_APP_TITLE` | 绿证交易平台 | 页面标题 |
