<template>
  <div class="front-header">
    <div class="header-container">
      <div class="logo-area" @click="$router.push('/')">
        <i class="el-icon-document-checked"></i>
        <span>绿证交易系统</span>
      </div>

      <el-menu mode="horizontal" :router="true" :default-active="activePath" class="nav-menu">
        <el-menu-item index="/">首页</el-menu-item>
        <el-sub-menu index="green-certificate-market">
          <template #title>绿证市场</template>
          <el-menu-item index="/products">绿证市场</el-menu-item>
          <el-menu-item index="/group-buying">参与拼团</el-menu-item>
          <el-menu-item index="/promotion">临期促销</el-menu-item>
          <el-menu-item index="/long-term-agreement">签订长期购买协议</el-menu-item>
        </el-sub-menu>
        <el-menu-item index="/cart">待购清单</el-menu-item>
        <el-menu-item index="/order">我的订单</el-menu-item>
        <el-menu-item index="/articles" class="nav-item">
            绿证资讯
          </el-menu-item>
        <el-sub-menu index="power-tracking">
          <template #title>电力属性跟踪系统</template>
          <el-menu-item @click="goToPowerTracking('https://www.greenenergy.org.cn/')">中国绿色电力消费网</el-menu-item>
          <el-menu-item @click="goToPowerTracking('http://pmos.sgcc.com.cn/')">国家电网交易平台</el-menu-item>
          <el-menu-item @click="goToPowerTracking('https://www.powerearket.com/')">电力市场交易平台</el-menu-item>
          <el-menu-item @click="goToPowerTracking('https://www.imptc.com/')">国际电力交易中心</el-menu-item>
          <el-menu-item @click="goToPowerTracking('https://gec.renewable.org.cn')">绿色电力证书交易平台</el-menu-item>
          <el-menu-item @click="goToPowerTracking('https://djfj.renewable.org.cn')">电力交易服务平台</el-menu-item>
          <el-menu-item @click="goToPowerTracking('https://www.irecstandard.org/')">国际可再生能源证书标准</el-menu-item>
          <el-menu-item @click="goToPowerTracking('https://apx.com/about-tigr/')">APX TIGR系统</el-menu-item>
        </el-sub-menu>
      </el-menu>

      <div class="right-section">
        <div class="search-box">
          <el-input 
            v-model="searchKey" 
            placeholder="搜索绿证..." 
            @keyup.enter="handleSearch"
            class="search-input">
            <template #prefix>
              <i class="el-icon-search"></i>
            </template>
          </el-input>
        </div>

        <div class="user-actions">
          <template v-if="!isLoggedIn">
            <el-button type="primary" class="login-btn" @click="goToLogin">
              <i class="el-icon-user"></i>
              <span>登录</span>
            </el-button>
          </template>
          <template v-else>
            <el-dropdown trigger="click">
              <div class="user-info">
                <span class="username">{{ userInfo.username }}</span>
                <i class="el-icon-arrow-down el-icon--right"></i>
              </div>
              <template #dropdown>
                <el-dropdown-menu>
                <el-dropdown-item @click="goToUserCenter">
                  <i class="el-icon-user"></i> 个人中心
                </el-dropdown-item>
                <el-dropdown-item @click="goToFavorite">
                  <i class="el-icon-star-off"></i> 我的收藏
                </el-dropdown-item>
                <el-dropdown-item  @click="logout">
                  <i class="el-icon-switch-button"></i> 退出登录
                </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>

          <!-- <el-button link type="primary" class="action-btn admin-btn" @click="goToAdmin">
            <i class="el-icon-s-tools"></i>
            <span>后台</span>
          </el-button> -->
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import router from '@/router';

export default {
  name: 'FrontHeader',
  data() {
    return {
      searchKey: '',
      isLoggedIn: false,
      userInfo: {},
    
    }
  },
  created() {
    this.checkLoginStatus();

  },
  mounted() {

  },
  methods: {
    checkLoginStatus() {
      const userInfo = localStorage.getItem('frontUser');
      if (userInfo) {
        this.isLoggedIn = true;
        this.userInfo = JSON.parse(userInfo);
      }
    },
    goToLogin() {
      this.$router.push('/login')
    },
    goToUserCenter() {
      this.$router.push('/user-center')
    },
    goToFavorite() {
      if (!this.isLoggedIn) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      this.$router.push('/favorite')
    },
    logout() {
      localStorage.removeItem('token');
      localStorage.removeItem('frontUser');
      this.isLoggedIn = false;
      this.userInfo = {};
      this.$message.success('已退出登录');
      this.$router.push('/');
      window.location.reload()
    },
    handleSearch() {
      if (!this.searchKey.trim()) {
        this.$message({
          type: 'warning',
          message: '请输入搜索关键词'
        })
        return
      }

      this.$router.push({
        path: '/search',
        query: {
          keyword: this.searchKey.trim()
        }
      })

      this.searchKey = ''
    },
    goToAdmin() {
      // 检查是否已登录
      const userMenuList = localStorage.getItem('userMenuList');
      const backUser = localStorage.getItem('backUser');
      if (!userMenuList || !backUser) {
        this.$message.warning('请先登录');
        this.$router.push('/login');
        return;
      }
      
      this.$router.push('/showView');
    },
    goToPowerTracking(url) {
      // 跳转到指定的电力属性跟踪系统
      window.open(url, '_blank');
    }
  },
  computed: {
    activePath() {
      return this.$router.currentRoute.fullPath;
    }
  }
}
</script>

<style scoped>
.front-header {
  position: sticky;
  top: 0;
  z-index: 1000;
  background: #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
  height: 70px;
  position: relative;
  overflow: hidden;
}

.front-header::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, 
    rgba(255, 255, 255, 0.98),
    #fff
  );
  backdrop-filter: blur(10px);
  z-index: -1;
}

/* 添加背景装饰 */
.front-header::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: 
    radial-gradient(circle at 0% 0%, rgba(103, 194, 58, 0.05) 0%, transparent 50%),
    radial-gradient(circle at 100% 0%, rgba(103, 194, 58, 0.05) 0%, transparent 50%),
    radial-gradient(circle at 50% 50%, rgba(103, 194, 58, 0.02) 0%, transparent 50%),
    linear-gradient(90deg, rgba(103, 194, 58, 0.01) 0%, rgba(103, 194, 58, 0.03) 50%, rgba(103, 194, 58, 0.01) 100%);
  opacity: 0.9;
  z-index: -1;
}

.header-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 24px;
  height: 100%;
  display: flex;
  align-items: center;
  gap: 32px;
  position: relative;
}

.logo-area {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  color: #67C23A;
  font-size: 20px;
  font-weight: 600;
  padding: 6px 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
  background: linear-gradient(120deg, 
    rgba(103, 194, 58, 0.06) 0%, 
    rgba(103, 194, 58, 0.12) 50%, 
    rgba(103, 194, 58, 0.06) 100%
  );
  position: relative;
  overflow: hidden;
  height: 44px;
}

.logo-area::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.3) 0%, transparent 60%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.logo-area:hover {
  background: linear-gradient(120deg, 
    rgba(103, 194, 58, 0.12) 0%, 
    rgba(103, 194, 58, 0.18) 50%, 
    rgba(103, 194, 58, 0.12) 100%
  );
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(103, 194, 58, 0.15);
}

.logo-area:hover::before {
  opacity: 1;
}

.logo-area i {
  font-size: 24px;
  background: linear-gradient(45deg, #67C23A, #85ce61);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  filter: drop-shadow(0 2px 3px rgba(103, 194, 58, 0.3));
}

.nav-menu {
  border: none;
  background: transparent;
  height: 70px;
  line-height: 70px;
  flex: 1;
  position: relative;
  z-index: 1;
  backdrop-filter: blur(4px);
}

:deep(.el-menu--horizontal > .el-menu-item) {
  height: 70px;
  line-height: 70px;
  padding: 0 20px;
  font-size: 16px;
  font-weight: 500;
  border: none !important;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

:deep(.el-menu--horizontal > .el-menu-item:hover) {
  background: linear-gradient(to right, transparent, rgba(103, 194, 58, 0.08), transparent);
  color: #67C23A;
}

:deep(.el-menu--horizontal > .el-menu-item.is-active) {
  color: #67C23A;
  font-weight: 600;
  background: linear-gradient(to right, transparent, rgba(103, 194, 58, 0.12), transparent);
}

:deep(.el-menu--horizontal > .el-menu-item.is-active::after) {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  right: 20%;
  height: 3px;
  background: linear-gradient(to right, #67C23A, #85ce61);
  border-radius: 3px 3px 0 0;
}

:deep(.el-menu--horizontal > .el-sub-menu) {
  height: 70px;
  line-height: 70px;
}

:deep(.el-menu--horizontal > .el-sub-menu > .el-sub-menu__title) {
  height: 70px;
  line-height: 70px;
  padding: 0 20px;
  font-size: 16px;
  font-weight: 500;
  border: none !important;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

:deep(.el-menu--horizontal > .el-sub-menu > .el-sub-menu__title:hover) {
  background: linear-gradient(to right, transparent, rgba(103, 194, 58, 0.08), transparent);
  color: #67C23A;
}

/* 绿证市场下拉菜单样式 */
:deep(.el-menu--horizontal > .el-sub-menu.is-active > .el-sub-menu__title) {
  color: #67C23A;
  font-weight: 600;
  background: linear-gradient(to right, transparent, rgba(103, 194, 58, 0.12), transparent);
}

:deep(.el-menu--horizontal > .el-sub-menu.is-active > .el-sub-menu__title::after) {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  right: 20%;
  height: 3px;
  background: linear-gradient(to right, #67C23A, #85ce61);
  border-radius: 3px 3px 0 0;
}

/* 下拉菜单内容样式 */
:deep(.el-menu--popup) {
  padding: 8px;
  border-radius: 12px;
  border: none;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
  min-width: 140px;
}

:deep(.el-menu--popup .el-menu-item) {
  height: 44px;
  line-height: 44px;
  padding: 0 20px;
  font-size: 14px;
  border-radius: 8px;
  margin: 4px 0;
  color: #606266;
  transition: all 0.3s ease;
}

:deep(.el-menu--popup .el-menu-item:hover) {
  background: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

:deep(.el-menu--popup .el-menu-item.is-active) {
  background: rgba(103, 194, 58, 0.15);
  color: #67C23A;
  font-weight: 500;
}

.right-section {
  display: flex;
  align-items: center;
  gap: 20px;
  height: 100%;
}

.search-box {
  width: 240px;
}

.search-input :deep(.el-input__inner) {
  height: 38px;
  line-height: 38px;
  border-radius: 19px;
  background: #f5f7fa;
  border: 1px solid transparent;
  padding-left: 40px;
  font-size: 14px;
  transition: all 0.3s ease;
}

.search-input :deep(.el-input__inner:focus) {
  background: #fff;
  border-color: #67C23A;
  box-shadow: 0 0 0 3px rgba(103, 194, 58, 0.15);
}

.search-input :deep(.el-input__prefix) {
  left: 14px;
  display: flex;
  align-items: center;
  height: 100%;
}

.search-input :deep(.el-input__prefix i) {
  font-size: 16px;
  color: #909399;
}

.search-input :deep(.el-input__inner:focus + .el-input__prefix i) {
  color: #67C23A;
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  height: 100%;
}

.login-btn {
  height: 38px;
  display: flex;
  align-items: center;
  padding: 0 16px;
  border-radius: 19px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  border: none;
  box-shadow: 0 4px 10px rgba(103, 194, 58, 0.2);
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(103, 194, 58, 0.3);
  background: linear-gradient(135deg, #5ab82f, #79c152);
}

.login-btn:focus, .login-btn:active {
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  border: none;
}

.login-btn i {
  margin-right: 6px;
  font-size: 16px;
}

/* 下拉菜单样式优化 */
:deep(.el-dropdown-menu) {
  padding: 8px;
  border-radius: 10px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
}

:deep(.el-dropdown-menu__item) {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  padding: 12px 18px;
  border-radius: 8px;
  margin: 3px 0;
  line-height: 1;
}

:deep(.el-dropdown-menu__item i) {
  font-size: 16px;
  color: #606266;
}

:deep(.el-dropdown-menu__item:hover) {
  background-color: rgba(103, 194, 58, 0.12);
  color: #67C23A;
}

:deep(.el-dropdown-menu__item:hover i) {
  color: #67C23A;
}

:deep(.el-dropdown-menu__item.is-disabled) {
  color: #C0C4CC;
  cursor: not-allowed;
  background-color: transparent;
}

:deep(.el-dropdown-menu__item.el-dropdown-menu__item--divided) {
  border-top: 1px solid #EBEEF5;
  margin: 8px 0;
  padding-top: 14px;
}

:deep(.el-dropdown-menu__item--divided:before) {
  height: 0;
  margin: 0;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 19px;
  cursor: pointer;
  transition: all 0.3s ease;
  background: rgba(103, 194, 58, 0.08);
  height: 38px;
}

.user-info:hover {
  background: rgba(103, 194, 58, 0.15);
  transform: translateY(-2px);
}

.user-info .el-icon-arrow-down {
  font-size: 12px;
  margin-left: 6px;
  transition: transform 0.3s ease;
}

.user-info:hover .el-icon-arrow-down {
  transform: rotate(180deg);
}

.username {
  font-size: 14px;
  color: #67C23A;
  font-weight: 500;
}

.admin-btn {
  color: #409EFF;
  background: rgba(64, 158, 255, 0.08);
}

.admin-btn:hover {
  color: #409EFF;
  background: rgba(64, 158, 255, 0.15);
}

/* 响应式布局 */
@media (max-width: 1200px) {
  .header-container {
    padding: 0 20px;
    gap: 20px;
  }

  .search-box {
    width: 200px;
  }

  :deep(.el-menu--horizontal > .el-menu-item) {
    padding: 0 16px;
  }
}

@media (max-width: 992px) {
  .search-box {
    width: 180px;
  }

  .login-btn span {
    display: none;
  }

  .login-btn {
    padding: 0 12px;
    width: 38px;
    height: 38px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .login-btn i {
    margin: 0;
  }
  
  .user-info {
    padding: 0 12px;
  }
  
  .username {
    max-width: 80px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}
</style> 