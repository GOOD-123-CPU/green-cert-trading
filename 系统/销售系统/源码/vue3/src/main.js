import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import './styles/index.css'
import './styles/element-ui-icon-compat.css'
import './assets/init.css'
import './assets/fonts/fonts.css'
import './assets/iconfont.css'

const app = createApp(App)

// 注册全部 Element Plus 图标为全局组件，模板中可直接使用 <el-icon><User /></el-icon>
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(router)
app.use(store)
app.use(ElementPlus, { locale: zhCn })

app.config.globalProperties.HOST = import.meta.env.VITE_API_BASE_URL || '/api'

app.mount('#app')
