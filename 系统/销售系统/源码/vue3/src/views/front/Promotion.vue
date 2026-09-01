<template>
  <div class="promotion-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <div class="title-container">
          <h2 class="page-title">
            <i class="el-icon-time"></i>
            <span>临期促销</span>
          </h2>
          <div class="page-subtitle">限时特惠，即将到期的绿证超值抢购</div>
        </div>
        <div class="countdown-box">
          <div class="countdown-label">距离本轮结束</div>
          <div class="countdown-timer">
            <span class="time-unit">{{ countdown.hours }}</span>
            <span class="time-separator">:</span>
            <span class="time-unit">{{ countdown.minutes }}</span>
            <span class="time-separator">:</span>
            <span class="time-unit">{{ countdown.seconds }}</span>
          </div>
        </div>
      </div>

      <!-- 促销标签筛选 -->
      <div class="promotion-tags">
        <div 
          v-for="tag in promotionTags" 
          :key="tag.value"
          class="tag-item"
          :class="{ active: selectedTag === tag.value }"
          @click="handleTagChange(tag.value)"
        >
          <i :class="tag.icon"></i>
          <span>{{ tag.label }}</span>
        </div>
      </div>

      <!-- 促销统计信息 -->
      <div class="promotion-stats">
        <div class="stat-item">
          <div class="stat-value">{{ promotionProducts.length }}</div>
          <div class="stat-label">促销绿证</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">最高{{ maxDiscount }}折</div>
          <div class="stat-label">限时折扣</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ expiringCount }}</div>
          <div class="stat-label">即将过期</div>
        </div>
      </div>

      <!-- 促销商品列表 -->
      <div class="products-section" v-loading="loading">
        <transition-group name="fade-list" tag="div" class="grid-container">
          <div 
            v-for="product in filteredProducts" 
            :key="product.id"
            class="product-item"
          >
            <div class="promotion-card">
              <!-- 折扣标签 -->
              <div class="discount-badge">
                <span class="discount-value">{{ product.discount }}折</span>
              </div>
              
              <!-- 临期标签 -->
              <div class="expiry-badge" :class="getExpiryClass(product.expiryDays)">
                <i class="el-icon-time"></i>
                <span>剩{{ product.expiryDays }}天</span>
              </div>

              <!-- 商品图片 -->
              <div class="product-image" @click="handleViewDetail(product)">
                <img :src="product.imageUrl" :alt="product.name" />
                <div class="image-overlay">
                  <span class="view-detail">查看详情</span>
                </div>
              </div>

              <!-- 商品信息 -->
              <div class="product-info">
                <h3 class="product-name">{{ product.name }}</h3>
                <p class="product-desc">{{ product.description }}</p>
                
                <!-- 价格信息 -->
                <div class="price-section">
                  <div class="current-price">
                    <span class="price-symbol">¥</span>
                    <span class="price-value">{{ product.promotionPrice }}</span>
                  </div>
                  <div class="original-price">
                    <span class="price-symbol">¥</span>
                    <span class="price-value">{{ product.originalPrice }}</span>
                  </div>
                  <div class="save-amount">
                    省¥{{ product.originalPrice - product.promotionPrice }}
                  </div>
                </div>

                <!-- 进度条 -->
                <div class="progress-section">
                  <div class="progress-info">
                    <span>已抢{{ product.soldPercent }}%</span>
                    <span>剩余{{ product.stock }}件</span>
                  </div>
                  <div class="progress-bar">
                    <div 
                      class="progress-fill" 
                      :style="{ width: product.soldPercent + '%' }"
                      :class="{ 'urgent': product.soldPercent > 80 }"
                    ></div>
                  </div>
                </div>

                <!-- 操作按钮 -->
                <div class="action-section">
                  <el-button 
                    type="primary" 
                    class="buy-btn"
                    :disabled="product.stock === 0"
                    @click.stop="addToCart(product)"
                  >
                    <i class="el-icon-shopping-cart-2"></i>
                    {{ product.stock === 0 ? '已售罄' : '立即抢购' }}
                  </el-button>
                  <el-button 
                    link type="primary" 
                    class="favorite-btn"
                    @click.stop="toggleFavorite(product)"
                  >
                    <i :class="product.isFavorite ? 'el-icon-star-on' : 'el-icon-star-off'"></i>
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </transition-group>
        
        <div v-if="!loading && filteredProducts.length === 0" class="empty-state">
          <i class="el-icon-time"></i>
          <p>暂无临期促销绿证</p>
          <el-button type="primary" plain round @click="$router.push('/products')">去绿证市场看看</el-button>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper" v-if="total > 0">
        <el-pagination
          background
          :current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          :page-sizes="[12, 24, 36, 48]"
          layout="sizes, prev, pager, next, jumper, total"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        >
        </el-pagination>
      </div>
    </div>
    <front-footer></front-footer>

    <!-- 绿证详情对话框 -->
    <el-dialog
      :title="selectedProduct ? selectedProduct.name + ' - 详情' : '绿证详情'"
      v-model="detailDialogVisible"
      width="900px"
      custom-class="detail-dialog"
      :close-on-click-modal="false"
      top="5vh"
    >
      <div v-if="selectedProduct" class="detail-dialog-content">
        <!-- 顶部信息区 -->
        <div class="detail-header">
          <div class="detail-image-section">
            <img :src="selectedProduct.imageUrl" :alt="selectedProduct.name">
            <div class="image-tags">
              <span class="detail-tag discount">{{ selectedProduct.discount }}折</span>
              <span class="detail-tag ending">剩{{ selectedProduct.expiryDays }}天</span>
            </div>
          </div>
          <div class="detail-basic-info">
            <h3 class="detail-title">{{ selectedProduct.name }}</h3>
            <p class="detail-desc">{{ selectedProduct.description }}</p>
            
            <!-- 价格信息 -->
            <div class="detail-price-section">
              <div class="detail-current-price">
                <span class="price-symbol">¥</span>
                <span class="price-value">{{ selectedProduct.promotionPrice }}</span>
                <span class="price-unit">/张</span>
              </div>
              <div class="detail-original-price">
                原价 <span class="original-value">¥{{ selectedProduct.originalPrice }}/张</span>
                <span class="save-amount">省 ¥{{ (selectedProduct.originalPrice - selectedProduct.promotionPrice).toFixed(2) }}</span>
              </div>
            </div>

            <!-- 统计信息 -->
            <div class="detail-stats">
              <div class="stat-item">
                <i class="el-icon-box"></i>
                <span class="stat-label">剩余库存</span>
                <span class="stat-value">{{ selectedProduct.stock }}张</span>
              </div>
              <div class="stat-item">
                <i class="el-icon-sold-out"></i>
                <span class="stat-label">已售</span>
                <span class="stat-value">{{ selectedProduct.sold }}张</span>
              </div>
              <div class="stat-item">
                <i class="el-icon-time"></i>
                <span class="stat-label">剩余时间</span>
                <span class="stat-value ending-soon">剩{{ selectedProduct.expiryDays }}天</span>
              </div>
            </div>

            <!-- 进度信息 -->
            <div class="detail-progress-info">
              <div class="progress-text">
                <span>已抢 {{ selectedProduct.soldPercent }}%</span>
                <el-progress 
                  :percentage="selectedProduct.soldPercent" 
                  :color="progressColors"
                  :stroke-width="10"
                  :show-text="false"
                ></el-progress>
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="detail-actions">
              <el-button 
                type="primary" 
                size="large"
                class="detail-buy-btn"
                :disabled="selectedProduct.stock === 0"
                @click="handleBuyFromDetail"
              >
                <i class="el-icon-shopping-cart-2"></i>
                {{ selectedProduct.stock === 0 ? '已售罄' : '立即抢购' }}
              </el-button>
              <el-button 
                type="default" 
                size="large"
                class="detail-favorite-btn"
                @click="toggleFavorite(selectedProduct)"
              >
                <i :class="selectedProduct.isFavorite ? 'el-icon-star-on' : 'el-icon-star-off'"></i>
                {{ selectedProduct.isFavorite ? '已收藏' : '收藏' }}
              </el-button>
            </div>
          </div>
        </div>

        <!-- 项目信息 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-office-building"></i> 项目信息</h4>
          <div class="info-grid">
            <div class="info-item">
              <span class="info-label">项目编号</span>
              <span class="info-value">{{ selectedProduct.projectCode || 'GEC-' + String(selectedProduct.id).padStart(8, '0') }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">发电类型</span>
              <span class="info-value">
                <el-tag size="small" type="success">{{ selectedProduct.categoryName || '风力发电' }}</el-tag>
              </span>
            </div>
            <div class="info-item">
              <span class="info-label">项目地点</span>
              <span class="info-value">{{ selectedProduct.placeOfOrigin || getLocationFromName(selectedProduct.name) }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">发电企业</span>
              <span class="info-value">{{ selectedProduct.company || getCompanyFromName(selectedProduct.name) }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">装机容量</span>
              <span class="info-value">{{ selectedProduct.capacity || '200MW' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">年发电量</span>
              <span class="info-value">{{ selectedProduct.generation || '45,600' }} MWh</span>
            </div>
          </div>
        </div>

        <!-- 环境效益 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-sunny"></i> 环境效益</h4>
          <div class="benefit-cards">
            <div class="benefit-card">
              <div class="benefit-icon co2">
                <i class="el-icon-cloudy"></i>
              </div>
              <div class="benefit-info">
                <span class="benefit-value">{{ selectedProduct.co2Reduction || '12,580' }} 吨</span>
                <span class="benefit-label">减少CO₂排放</span>
              </div>
            </div>
            <div class="benefit-card">
              <div class="benefit-icon tree">
                <i class="el-icon-s-custom"></i>
              </div>
              <div class="benefit-info">
                <span class="benefit-value">{{ selectedProduct.treeEquivalent || '68.5' }} 万棵</span>
                <span class="benefit-label">相当于植树</span>
              </div>
            </div>
            <div class="benefit-card">
              <div class="benefit-icon coal">
                <i class="el-icon-box"></i>
              </div>
              <div class="benefit-info">
                <span class="benefit-value">{{ selectedProduct.coalSaving || '5,120' }} 吨</span>
                <span class="benefit-label">节约标准煤</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 绿证信息 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-document-checked"></i> 绿证信息</h4>
          <div class="certificate-info">
            <div class="cert-item">
              <span class="cert-label">绿证编号</span>
              <span class="cert-value">{{ selectedProduct.certificateCode || 'GEC-' + String(selectedProduct.id).padStart(8, '0') }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">绿证类型</span>
              <span class="cert-value">{{ selectedProduct.certificateType || '绿色电力证书' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">有效期至</span>
              <span class="cert-value">{{ selectedProduct.validDate || '长期有效' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">认证机构</span>
              <span class="cert-value">{{ selectedProduct.issuer || '国家可再生能源信息管理中心' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">使用范围</span>
              <span class="cert-value">全国通用</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">交付方式</span>
              <span class="cert-value">电子凭证</span>
            </div>
          </div>
        </div>

        <!-- 购买须知 -->
        <div class="detail-rules-section">
          <h4><i class="el-icon-warning"></i> 购买须知</h4>
          <ul class="rules-list">
            <li><i class="el-icon-check"></i> 临期促销绿证有效期即将到期，请确认后再购买</li>
            <li><i class="el-icon-check"></i> 绿证购买后可随时查看、下载电子证书</li>
            <li><i class="el-icon-check"></i> 每张绿证对应1000千瓦时可再生能源电量</li>
            <li><i class="el-icon-check"></i> 绿证可用于企业碳中和核算、绿色电力消费证明</li>
            <li><i class="el-icon-check"></i> 购买后不支持退款，请确认后购买</li>
            <li><i class="el-icon-check"></i> 如有疑问，请联系客服：400-888-8888</li>
          </ul>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import Request from '@/utils/request'

export default {
  name: 'Promotion',
  components: {
    FrontHeader,
    FrontFooter
  },
  data() {
    return {
      loading: false,
      promotionProducts: [],
      selectedTag: 'all',
      currentPage: 1,
      pageSize: 12,
      total: 0,
      countdown: {
        hours: '00',
        minutes: '00',
        seconds: '00'
      },
      countdownTimer: null,
      promotionTags: [
        { label: '全部', value: 'all', icon: 'el-icon-menu' },
        { label: '即将过期', value: 'expiring', icon: 'el-icon-warning' },
        { label: '超低折扣', value: 'discount', icon: 'el-icon-price-tag' },
        { label: '库存紧张', value: 'urgent', icon: 'el-icon-bell' }
      ],
      detailDialogVisible: false,
      selectedProduct: null,
      progressColors: [
        { color: '#67C23A', percentage: 20 },
        { color: '#85ce61', percentage: 40 },
        { color: '#e6a23c', percentage: 60 },
        { color: '#f56c6c', percentage: 80 },
        { color: '#ff4757', percentage: 100 }
      ]
    }
  },
  computed: {
    filteredProducts() {
      let products = this.promotionProducts
      
      switch (this.selectedTag) {
        case 'expiring':
          products = products.filter(p => p.expiryDays <= 7)
          break
        case 'discount':
          products = products.filter(p => p.discount <= 5)
          break
        case 'urgent':
          products = products.filter(p => p.soldPercent >= 80)
          break
        default:
          break
      }
      
      return products
    },
    maxDiscount() {
      if (this.promotionProducts.length === 0) return 0
      const minDiscount = Math.min(...this.promotionProducts.map(p => p.discount))
      return minDiscount
    },
    expiringCount() {
      return this.promotionProducts.filter(p => p.expiryDays <= 7).length
    }
  },
  methods: {
    // 获取临期促销商品
    async getPromotionProducts() {
      this.loading = true
      try {
        const params = {
          currentPage: this.currentPage,
          size: this.pageSize
        }
        
        const res = await Request.get('/product/promotion', { params })
        if (res.code === '0') {
          if (res.data && res.data.records) {
            this.promotionProducts = res.data.records.map(product => ({
              ...product,
              isFavorite: false,
              imageUrl: product.imageUrl?.startsWith('http') ? product.imageUrl : `${product.imageUrl}`,
              discount: this.calculateDiscount(product.promotionPrice, product.originalPrice),
              soldPercent: this.calculateSoldPercent(product.sold, product.totalStock)
            }))
            this.total = res.data.total
          } else {
            // 接口无数据时使用演示兜底数据
            this.loadMockData()
          }
        } else {
          this.loadMockData()
        }
      } catch (error) {
        console.error('获取促销商品失败:', error)
        this.loadMockData()
      } finally {
        this.loading = false
      }
    },
    
    // 接口无数据时的演示兜底数据（正式部署建议删除）
    loadMockData() {
      const mockProducts = [
        {
          id: 1,
          name: '甘肃风电场绿证',
          description: '优质绿色电力证书，助力企业碳中和',
          originalPrice: 35.8,
          promotionPrice: 15.6,
          imageUrl: 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=400',
          expiryDays: 3,
          stock: 15,
          totalStock: 100,
          sold: 85,
          isFavorite: false
        },
        {
          id: 2,
          name: '新疆风电场绿证',
          description: '来自新疆优质风电项目',
          originalPrice: 68.0,
          promotionPrice: 32.9,
          imageUrl: 'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=400',
          expiryDays: 5,
          stock: 28,
          totalStock: 150,
          sold: 122,
          isFavorite: false
        },
        {
          id: 3,
          name: '江苏海上风电绿证',
          description: '海上风电项目绿证',
          originalPrice: 45.0,
          promotionPrice: 23.5,
          imageUrl: 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400',
          expiryDays: 7,
          stock: 42,
          totalStock: 200,
          sold: 158,
          isFavorite: false
        },
        {
          id: 4,
          name: '山东海上风电绿证',
          description: '山东沿海风电项目',
          originalPrice: 88.0,
          promotionPrice: 55.0,
          imageUrl: 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400',
          expiryDays: 2,
          stock: 8,
          totalStock: 80,
          sold: 72,
          isFavorite: false
        },
        {
          id: 5,
          name: '内蒙古光伏绿证',
          description: '内蒙古大型光伏电站',
          originalPrice: 42.0,
          promotionPrice: 19.9,
          imageUrl: 'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=400',
          expiryDays: 4,
          stock: 56,
          totalStock: 120,
          sold: 64,
          isFavorite: false
        },
        {
          id: 6,
          name: '云南水电绿证',
          description: '云南清洁能源水电项目',
          originalPrice: 38.0,
          promotionPrice: 22.0,
          imageUrl: 'https://images.unsplash.com/photo-1548337138-e87d889cc369?w=400',
          expiryDays: 6,
          stock: 33,
          totalStock: 100,
          sold: 67,
          isFavorite: false
        }
      ]
      
      this.promotionProducts = mockProducts.map(product => ({
        ...product,
        discount: this.calculateDiscount(product.promotionPrice, product.originalPrice),
        soldPercent: this.calculateSoldPercent(product.sold, product.totalStock)
      }))
      this.total = mockProducts.length
    },
    
    calculateDiscount(promotionPrice, originalPrice) {
      return Math.round((promotionPrice / originalPrice) * 10)
    },
    
    calculateSoldPercent(sold, total) {
      return Math.round((sold / total) * 100)
    },
    
    getExpiryClass(days) {
      if (days <= 3) return 'critical'
      if (days <= 7) return 'warning'
      return 'normal'
    },
    
    handleTagChange(tag) {
      this.selectedTag = tag
      this.currentPage = 1
    },
    
    handlePageChange(page) {
      this.currentPage = page
      this.getPromotionProducts()
    },
    
    handleSizeChange(size) {
      this.pageSize = size
      this.currentPage = 1
      this.getPromotionProducts()
    },
    
    // 查看详情
    handleViewDetail(product) {
      this.selectedProduct = product
      this.detailDialogVisible = true
    },

    // 从详情页购买
    handleBuyFromDetail() {
      this.detailDialogVisible = false
      this.addToCart(this.selectedProduct)
    },

    // 根据名称获取地点
    getLocationFromName(name) {
      const locationMap = {
        '甘肃风电场绿证': '甘肃省酒泉市',
        '新疆风电场绿证': '新疆维吾尔自治区哈密市',
        '江苏海上风电绿证': '江苏省南通市',
        '山东海上风电绿证': '山东省烟台市',
        '内蒙古光伏绿证': '内蒙古自治区锡林郭勒盟',
        '云南水电绿证': '云南省昆明市'
      }
      return locationMap[name] || '中国'
    },

    // 根据名称获取企业
    getCompanyFromName(name) {
      const companyMap = {
        '甘肃风电场绿证': '甘肃酒泉风电有限公司',
        '新疆风电场绿证': '新疆哈密新能源有限公司',
        '江苏海上风电绿证': '江苏海上风电有限公司',
        '山东海上风电绿证': '山东海上风电有限公司',
        '内蒙古光伏绿证': '内蒙古草原新能源有限公司',
        '云南水电绿证': '云南清洁能源有限公司'
      }
      return companyMap[name] || '国家能源集团'
    },
    
    addToCart(product) {
      if (!this.isLoggedIn()) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      
      // 添加到购物车逻辑
      this.$message.success(`已将 ${product.name} 加入购物车`)
    },
    
    toggleFavorite(product) {
      if (!this.isLoggedIn()) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      
      product.isFavorite = !product.isFavorite
      this.$message.success(product.isFavorite ? '已收藏' : '已取消收藏')
    },
    
    isLoggedIn() {
      return !!localStorage.getItem('frontUser')
    },
    
    // 倒计时
    startCountdown() {
      const endTime = new Date()
      endTime.setHours(23, 59, 59, 999)
      
      this.updateCountdown(endTime)
      
      this.countdownTimer = setInterval(() => {
        this.updateCountdown(endTime)
      }, 1000)
    },
    
    updateCountdown(endTime) {
      const now = new Date()
      const diff = endTime - now
      
      if (diff <= 0) {
        this.countdown = { hours: '00', minutes: '00', seconds: '00' }
        return
      }
      
      const hours = Math.floor(diff / (1000 * 60 * 60))
      const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
      const seconds = Math.floor((diff % (1000 * 60)) / 1000)
      
      this.countdown = {
        hours: hours.toString().padStart(2, '0'),
        minutes: minutes.toString().padStart(2, '0'),
        seconds: seconds.toString().padStart(2, '0')
      }
    }
  },
  created() {
    this.getPromotionProducts()
    this.startCountdown()
  },
  beforeUnmount() {
    if (this.countdownTimer) {
      clearInterval(this.countdownTimer)
    }
  }
}
</script>

<style scoped>
.promotion-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, #fff5f5 0%, #fff 50%, #f5fff5 100%);
}

.main-content {
  flex: 1;
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px;
  width: 100%;
  box-sizing: border-box;
}

/* 页面标题样式 */
.page-header {
  margin-bottom: 24px;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
  padding: 30px;
  border-radius: 16px;
  box-shadow: 0 8px 24px rgba(238, 90, 36, 0.2);
  position: relative;
  overflow: hidden;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header::before {
  content: '';
  position: absolute;
  left: -50%;
  top: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%);
  animation: pulse 3s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 0.5; }
  50% { transform: scale(1.1); opacity: 0.8; }
}

.title-container {
  display: flex;
  flex-direction: column;
  position: relative;
  z-index: 1;
}

.page-title {
  display: flex;
  align-items: center;
  gap: 14px;
  margin: 0;
  font-size: 28px;
  font-weight: 600;
  color: #fff;
}

.page-title i {
  font-size: 32px;
  background: rgba(255,255,255,0.2);
  width: 56px;
  height: 56px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.page-subtitle {
  margin-top: 10px;
  font-size: 16px;
  color: rgba(255,255,255,0.9);
  padding-left: 70px;
}

/* 倒计时 */
.countdown-box {
  text-align: center;
  position: relative;
  z-index: 1;
  background: rgba(255,255,255,0.15);
  padding: 16px 24px;
  border-radius: 12px;
  backdrop-filter: blur(10px);
}

.countdown-label {
  font-size: 14px;
  color: rgba(255,255,255,0.9);
  margin-bottom: 8px;
}

.countdown-timer {
  display: flex;
  align-items: center;
  gap: 8px;
}

.time-unit {
  background: rgba(255,255,255,0.95);
  color: #ee5a24;
  font-size: 24px;
  font-weight: 700;
  padding: 8px 12px;
  border-radius: 8px;
  min-width: 44px;
  text-align: center;
}

.time-separator {
  color: #fff;
  font-size: 20px;
  font-weight: 700;
}

/* 促销标签筛选 */
.promotion-tags {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.tag-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: white;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  border: 2px solid transparent;
}

.tag-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.tag-item.active {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
  border-color: #ee5a24;
}

.tag-item i {
  font-size: 16px;
}

.tag-item span {
  font-size: 14px;
  font-weight: 500;
}

/* 统计信息 */
.promotion-stats {
  display: flex;
  gap: 24px;
  margin-bottom: 24px;
  padding: 20px 24px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.stat-item {
  flex: 1;
  text-align: center;
  padding: 0 16px;
  border-right: 1px solid #f0f0f0;
}

.stat-item:last-child {
  border-right: none;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #ee5a24;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

/* 商品网格 */
.products-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.04);
  min-height: 500px;
  position: relative;
}

.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
}

.product-item {
  transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
  animation: fadeIn 0.6s ease forwards;
  opacity: 0;
}

.product-item:nth-child(1) { animation-delay: 0.05s; }
.product-item:nth-child(2) { animation-delay: 0.1s; }
.product-item:nth-child(3) { animation-delay: 0.15s; }
.product-item:nth-child(4) { animation-delay: 0.2s; }
.product-item:nth-child(5) { animation-delay: 0.25s; }
.product-item:nth-child(6) { animation-delay: 0.3s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 促销卡片 */
.promotion-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
  position: relative;
  cursor: pointer;
  border: 1px solid #f0f0f0;
}

.promotion-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 32px rgba(0,0,0,0.12);
}

/* 折扣标签 */
.discount-badge {
  position: absolute;
  top: 12px;
  left: 12px;
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-weight: 700;
  font-size: 14px;
  z-index: 2;
  box-shadow: 0 2px 8px rgba(238, 90, 36, 0.3);
}

.discount-value {
  font-size: 16px;
}

/* 临期标签 */
.expiry-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
  z-index: 2;
  display: flex;
  align-items: center;
  gap: 4px;
}

.expiry-badge.critical {
  background: #fef0f0;
  color: #f56c6c;
}

.expiry-badge.warning {
  background: #fdf6ec;
  color: #e6a23c;
}

.expiry-badge.normal {
  background: #f0f9ff;
  color: #409eff;
}

/* 商品图片 */
.product-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.promotion-card:hover .product-image img {
  transform: scale(1.08);
}

.image-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.promotion-card:hover .image-overlay {
  opacity: 1;
}

.view-detail {
  color: white;
  font-size: 14px;
  padding: 10px 20px;
  border: 2px solid white;
  border-radius: 25px;
  font-weight: 500;
}

/* 商品信息 */
.product-info {
  padding: 20px;
}

.product-name {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 8px;
  line-height: 1.4;
}

.product-desc {
  font-size: 13px;
  color: #909399;
  margin: 0 0 16px;
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

/* 价格区域 */
.price-section {
  display: flex;
  align-items: baseline;
  gap: 12px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.current-price {
  color: #ee5a24;
  font-weight: 700;
}

.current-price .price-symbol {
  font-size: 16px;
}

.current-price .price-value {
  font-size: 28px;
}

.original-price {
  color: #c0c4cc;
  text-decoration: line-through;
  font-size: 14px;
}

.save-amount {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

/* 进度条 */
.progress-section {
  margin-bottom: 16px;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #909399;
  margin-bottom: 8px;
}

.progress-bar {
  height: 8px;
  background: #f0f0f0;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #67c23a, #85ce61);
  border-radius: 4px;
  transition: width 0.5s ease;
}

.progress-fill.urgent {
  background: linear-gradient(90deg, #ff6b6b, #ee5a24);
}

/* 操作按钮 */
.action-section {
  display: flex;
  gap: 12px;
}

.buy-btn {
  flex: 1;
  height: 44px;
  border-radius: 22px;
  font-size: 15px;
  font-weight: 500;
  background: linear-gradient(135deg, #ee5a24, #ff6b6b);
  border: none;
  transition: all 0.3s ease;
}

.buy-btn:hover {
  transform: scale(1.02);
  box-shadow: 0 4px 12px rgba(238, 90, 36, 0.3);
}

.buy-btn:disabled {
  background: #c0c4cc;
  transform: none;
  box-shadow: none;
}

.favorite-btn {
  width: 44px;
  height: 44px;
  padding: 0;
  border-radius: 50%;
  border: 1px solid #e0e0e0;
}

.favorite-btn i {
  font-size: 18px;
  color: #e6a23c;
}

/* 动画效果 */
.fade-list-enter-active, .fade-list-leave-active {
  transition: all 0.3s ease;
}

.fade-list-enter, .fade-list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 0;
  color: #909399;
}

.empty-state i {
  font-size: 64px;
  margin-bottom: 20px;
  color: #dcdfe6;
}

.empty-state p {
  font-size: 16px;
  margin: 0 0 24px;
  color: #606266;
}

/* 分页 */
.pagination-wrapper {
  margin-top: 40px;
  display: flex;
  justify-content: center;
  padding: 20px 0;
}

:deep(.el-pagination) {
  padding: 16px 24px;
  background: white;
  border-radius: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
}

:deep(.el-pagination.is-background .el-pager li) {
  margin: 0 4px;
  border-radius: 50%;
  min-width: 32px;
  transition: all 0.3s ease;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #ee5a24;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #ee5a24;
}

:deep(.el-pagination .btn-prev),
:deep(.el-pagination .btn-next) {
  border-radius: 50%;
  margin: 0 4px;
}

/* 详情对话框样式 */
.detail-dialog-content {
  max-height: 70vh;
  overflow-y: auto;
}

.detail-header {
  display: flex;
  gap: 30px;
  margin-bottom: 30px;
}

.detail-image-section {
  flex: 0 0 320px;
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.detail-image-section img {
  width: 100%;
  height: 240px;
  object-fit: cover;
}

.image-tags {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  gap: 8px;
}

.detail-tag {
  padding: 6px 14px;
  border-radius: 16px;
  font-size: 13px;
  font-weight: 500;
}

.detail-tag.discount {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
}

.detail-tag.ending {
  background: #fdf6ec;
  color: #e6a23c;
}

.detail-basic-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.detail-title {
  font-size: 22px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 10px;
  line-height: 1.4;
}

.detail-desc {
  font-size: 14px;
  color: #909399;
  margin: 0 0 20px;
  line-height: 1.6;
}

/* 价格区域 */
.detail-price-section {
  background: linear-gradient(135deg, #fff5f5, #fff);
  border: 1px solid #ffe4e4;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
}

.detail-current-price {
  display: flex;
  align-items: baseline;
  gap: 4px;
  margin-bottom: 8px;
}

.detail-current-price .price-symbol {
  font-size: 20px;
  color: #ff4757;
  font-weight: 600;
}

.detail-current-price .price-value {
  font-size: 36px;
  color: #ff4757;
  font-weight: 700;
  line-height: 1;
}

.detail-current-price .price-unit {
  font-size: 14px;
  color: #909399;
}

.detail-original-price {
  font-size: 14px;
  color: #909399;
}

.detail-original-price .original-value {
  text-decoration: line-through;
  margin-right: 12px;
}

.detail-original-price .save-amount {
  color: #67C23A;
  font-weight: 500;
  background: rgba(103, 194, 58, 0.1);
  padding: 2px 10px;
  border-radius: 10px;
  font-size: 13px;
}

/* 统计信息 */
.detail-stats {
  display: flex;
  gap: 24px;
  margin-bottom: 20px;
}

.detail-stats .stat-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.detail-stats .stat-item i {
  font-size: 20px;
  color: #67C23A;
  margin-bottom: 4px;
}

.detail-stats .stat-label {
  font-size: 13px;
  color: #909399;
}

.detail-stats .stat-value {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
}

.detail-stats .stat-value.ending-soon {
  color: #e6a23c;
}

/* 进度信息 */
.detail-progress-info {
  margin-bottom: 20px;
}

.progress-text {
  font-size: 14px;
  color: #606266;
}

.progress-text span {
  display: block;
  margin-bottom: 8px;
}

/* 操作按钮 */
.detail-actions {
  display: flex;
  gap: 16px;
  margin-top: auto;
}

.detail-buy-btn {
  flex: 1;
  height: 48px;
  border-radius: 24px;
  font-size: 16px;
  font-weight: 500;
  background: linear-gradient(135deg, #ee5a24, #ff6b6b);
  border: none;
}

.detail-buy-btn:hover {
  background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
}

.detail-buy-btn:disabled {
  background: #c0c4cc;
}

.detail-favorite-btn {
  height: 48px;
  border-radius: 24px;
  font-size: 16px;
  padding: 0 30px;
}

/* 详情区块 */
.detail-section {
  margin-bottom: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #ebeef5;
}

.detail-section:last-of-type {
  border-bottom: none;
}

.section-title {
  font-size: 16px;
  color: #2c3e50;
  margin: 0 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
}

.section-title i {
  color: #67C23A;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.info-label {
  font-size: 13px;
  color: #909399;
}

.info-value {
  font-size: 14px;
  color: #2c3e50;
  font-weight: 500;
}

/* 环境效益卡片 */
.benefit-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.benefit-card {
  background: #f8faf5;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
  transition: all 0.3s ease;
}

.benefit-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(103, 194, 58, 0.15);
}

.benefit-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  flex-shrink: 0;
}

.benefit-icon.co2 {
  background: linear-gradient(135deg, #67C23A, #85ce61);
}

.benefit-icon.tree {
  background: linear-gradient(135deg, #409EFF, #66b1ff);
}

.benefit-icon.coal {
  background: linear-gradient(135deg, #e6a23c, #ebb563);
}

.benefit-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.benefit-value {
  font-size: 16px;
  font-weight: 700;
  color: #2c3e50;
}

.benefit-label {
  font-size: 12px;
  color: #909399;
}

/* 绿证信息 */
.certificate-info {
  background: #f8faf5;
  border-radius: 12px;
  padding: 20px;
}

.cert-item {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px dashed #e4e7ed;
}

.cert-item:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.cert-item:first-child {
  padding-top: 0;
}

.cert-label {
  font-size: 13px;
  color: #909399;
}

.cert-value {
  font-size: 14px;
  color: #2c3e50;
  font-weight: 500;
}

/* 购买须知 */
.detail-rules-section {
  background: #fdf6ec;
  border-radius: 12px;
  padding: 20px;
}

.detail-rules-section h4 {
  font-size: 16px;
  color: #2c3e50;
  margin: 0 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.detail-rules-section h4 i {
  color: #e6a23c;
}

.rules-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.rules-list li {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 0;
  font-size: 14px;
  color: #606266;
  border-bottom: 1px dashed #e4e7ed;
}

.rules-list li:last-child {
  border-bottom: none;
}

.rules-list li i {
  color: #67C23A;
  font-size: 14px;
}

/* 响应式布局优化 */
@media (max-width: 1200px) {
  .grid-container {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
  }
  
  .products-section {
    padding: 24px;
  }
}

@media (max-width: 992px) {
  .page-header {
    flex-direction: column;
    gap: 20px;
    text-align: center;
  }
  
  .page-subtitle {
    padding-left: 0;
  }
  
  .promotion-stats {
    flex-wrap: wrap;
  }
  
  .stat-item {
    flex: 1 1 calc(50% - 12px);
    border-right: none;
    border-bottom: 1px solid #f0f0f0;
    padding-bottom: 16px;
  }
  
  .stat-item:nth-last-child(-n+2) {
    border-bottom: none;
    padding-bottom: 0;
    padding-top: 16px;
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 16px;
  }
  
  .page-header {
    padding: 20px;
  }
  
  .page-title {
    font-size: 22px;
  }
  
  .page-title i {
    font-size: 24px;
    width: 48px;
    height: 48px;
  }
  
  .promotion-tags {
    gap: 8px;
  }
  
  .tag-item {
    padding: 10px 16px;
    font-size: 13px;
  }
  
  .grid-container {
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 16px;
  }
  
  .products-section {
    padding: 16px;
    border-radius: 12px;
  }
  
  .time-unit {
    font-size: 18px;
    padding: 6px 10px;
    min-width: 36px;
  }
}

@media (max-width: 480px) {
  .grid-container {
    grid-template-columns: 1fr;
  }
  
  .promotion-stats {
    flex-direction: column;
    gap: 16px;
  }
  
  .stat-item {
    border-bottom: 1px solid #f0f0f0;
    border-right: none;
    padding-bottom: 16px;
  }
  
  .stat-item:last-child {
    border-bottom: none;
    padding-bottom: 0;
  }
}

/* 详情对话框响应式 */
@media (max-width: 768px) {
  .detail-header {
    flex-direction: column;
    gap: 20px;
  }
  
  .detail-image-section {
    flex: 1;
    width: 100%;
  }
  
  .detail-image-section img {
    height: 200px;
  }
  
  .detail-title {
    font-size: 18px;
  }
  
  .detail-current-price .price-value {
    font-size: 28px;
  }
  
  .detail-stats {
    flex-wrap: wrap;
    gap: 16px;
  }
  
  .detail-actions {
    flex-direction: column;
  }
  
  .detail-buy-btn,
  .detail-favorite-btn {
    width: 100%;
  }
  
  .info-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .benefit-cards {
    grid-template-columns: 1fr;
  }
  
  .benefit-card {
    padding: 16px;
  }
}

@media (max-width: 480px) {
  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>
