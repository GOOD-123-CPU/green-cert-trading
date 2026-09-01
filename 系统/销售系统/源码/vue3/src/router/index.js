import { createRouter, createWebHistory } from 'vue-router'
import { ElMessage } from 'element-plus'
import Home from '@/views/front/Home.vue'
import ShowView from '@/views/showView.vue'
import Login from '@/views/Login.vue'
import RegisterVue from '@/views/RegisterVue.vue'
import Forget from '@/views/Forget.vue'
import Menu from '@/views/Menu.vue'
import LRLayout from '@/layout/LRLayout.vue'
import AdminLayout from '@/layout/index.vue'

const routes = [
  {
    path: '/login',
    name: 'LRLayout',
    component: LRLayout,
    redirect: '/login',
    children: [
      { path: '/login', name: 'Login', component: Login },
      { path: '/register', name: 'Register', component: RegisterVue },
      { path: '/forget', name: 'Forget', component: Forget },
    ],
  },
  { path: '/', name: 'Home', component: Home },
  { path: '/404', name: '404', component: () => import('@/views/404.vue') },
  { path: '/products', name: 'Products', component: () => import('@/views/front/Products.vue') },
  { path: '/cart', name: 'Cart', component: () => import('@/views/front/Cart.vue') },
  {
    path: '/favorite',
    name: 'Favorite',
    component: () => import('@/views/front/Favorite.vue'),
    meta: { requiresAuth: true },
  },
  { path: '/category/:id', name: 'category', component: () => import('@/views/front/Category.vue') },
  { path: '/order', name: 'Order', component: () => import('@/views/front/Order.vue') },
  {
    path: '/user-center',
    name: 'UserCenter',
    component: () => import('@/views/front/UserCenter.vue'),
    meta: { requiresAuth: true },
  },
  { path: '/product/:id', name: 'ProductDetail', component: () => import('@/views/front/ProductDetail.vue') },
  { path: '/articles', name: 'Articles', component: () => import('@/views/front/Article.vue') },
  { path: '/article/:id', name: 'ArticleDetail', component: () => import('@/views/front/ArticleDetail.vue') },
  {
    path: '/search',
    name: 'Search',
    component: () => import('@/views/front/Search.vue'),
    meta: { title: '搜索结果' },
  },
  {
    path: '/group-buying',
    name: 'GroupBuying',
    component: () => import('@/views/front/GroupBuying.vue'),
    meta: { title: '绿证拼团活动' },
  },
  {
    path: '/promotion',
    name: 'Promotion',
    component: () => import('@/views/front/Promotion.vue'),
    meta: { title: '绿证临期促销' },
  },
  {
    path: '/long-term-agreement',
    name: 'LongTermAgreement',
    component: () => import('@/views/front/LongTermAgreement.vue'),
    meta: { title: '签订长期购买协议' },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

/**
 * 动态注册后台管理路由（登录成功后根据菜单权限调用）
 * vue-router 4：addRoute 支持重复添加时自动覆盖同名路由，无需手动 remove
 */
export const setRoutes = () => {
  const userMenuListStr = localStorage.getItem('userMenuList')
  if (userMenuListStr && userMenuListStr !== 'undefined') {
    if (router.hasRoute('Layout')) return // 已注册，避免重复添加

    const currRouter = {
      path: '/',
      name: 'Layout',
      component: AdminLayout,
      redirect: '/showView',
      children: [
        {
          path: '/showView',
          name: 'homeView',
          component: ShowView,
          meta: { title: '首页' },
        },
        {
          path: '/menu',
          name: 'Menu',
          component: Menu,
          meta: { title: '菜单管理' },
        },
      ],
    }

    try {
      const menus = JSON.parse(userMenuListStr)
      menus.forEach((item) => {
        if (item.path) {
          currRouter.children.push({
            path: item.path.replace('/', ''),
            name: item.name,
            component: () => import(`../views/${item.pagePath}.vue`),
            meta: { title: item.name },
          })
        } else if (item.children?.length) {
          item.children.forEach((child) => {
            if (child.path) {
              currRouter.children.push({
                path: child.path.replace('/', ''),
                name: child.name,
                component: () => import(`../views/${child.pagePath}.vue`),
                meta: { title: child.name },
              })
            }
          })
        }
      })
      router.addRoute(currRouter)
    } catch (err) {
      console.error('Failed to parse userMenuList:', err)
    }
  }
}

// vue-router 4：动态导入失败抛出的是带 type 属性的错误对象
router.onError((error) => {
  const msg = error?.message || ''
  if (msg.includes('Failed to fetch dynamically imported module') || msg.includes('Cannot find module')) {
    router.replace('/404')
  }
})

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requiresAuth)) {
    const userInfo = localStorage.getItem('frontUser')
    if (!userInfo) {
      ElMessage({ message: '请先登录', type: 'warning' })
      next('/login')
      return
    }
  }

  // 后台管理路由守卫：动态注册的 Layout 子路由要求 backUser 会话与菜单数据同时存在
  const isAdminRoute = to.matched.some((record) => record.name === 'Layout')
  if (isAdminRoute) {
    const backUser = localStorage.getItem('backUser')
    const localMenus = localStorage.getItem('userMenuList')
    if (!backUser || !localMenus || localMenus === 'undefined') {
      // 会话残缺：清理所有登录痕迹，避免半登录状态
      localStorage.removeItem('backUser')
      localStorage.removeItem('userMenuList')
      ElMessage({ message: '后台会话已失效，请重新登录', type: 'warning' })
      next('/login')
      return
    }
  }

  if (to.name) {
    localStorage.setItem('currentPathName', to.name)
  }

  const localMenus = localStorage.getItem('userMenuList')
  if (!to.matched.length) {
    if (to.path !== '/404') {
      if (localMenus && localMenus !== 'undefined' && localStorage.getItem('backUser')) {
        // 已登录后台但路由不存在：真 404
        next({ path: '/404', replace: true, query: { redirect: from.fullPath } })
      } else {
        ElMessage({ message: '请先登录', type: 'warning' })
        next('/login')
      }
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
