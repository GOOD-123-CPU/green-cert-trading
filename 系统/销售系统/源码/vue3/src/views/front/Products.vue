<template>
  <div class="products-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <div class="title-container">
          <h2 class="page-title">
            <i class="el-icon-document-checked"></i>
            <span>绿证市场</span>
          </h2>
          <div class="page-subtitle">优质绿色电力证书，助力企业碳中和</div>
        </div>
        <div class="search-box">
          <el-input 
            v-model="searchKeyword" 
            placeholder="搜索绿证" 
            prefix-icon="el-icon-search"
            clearable
            @clear="handleSearch"
            @keyup.enter="handleSearch"
          >
          </el-input>
        </div>
      </div>

      <!-- 顶部过滤器 -->
      <div class="filter-bar">
        <div class="filter-group">
          <div class="filter-item">
            <el-dropdown trigger="click" @command="handleCategoryChange">
              <span class="filter-label" :class="{'active': selectedCategory}">
                <i class="el-icon-menu"></i>
                类型
                <i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                <el-dropdown-item command="">全部绿证</el-dropdown-item>
                <el-dropdown-item 
                  v-for="category in categories" 
                  :key="category.id"
                  :command="category.id"
                >{{ category.name }}</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>

          <div class="filter-item">
            <el-dropdown trigger="click" @command="handlePriceRangeChange">
              <span class="filter-label" :class="{'active': priceRange}">
                <i class="el-icon-price-tag"></i>
                价格
                <i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                <el-dropdown-item command="">全部价格</el-dropdown-item>
                <el-dropdown-item 
                  v-for="(range, index) in priceRanges" 
                  :key="index"
                  :command="range.value"
                >{{ range.label }}</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>

          <div class="filter-item">
            <el-dropdown trigger="click" @command="handleSortChange">
              <span class="filter-label" :class="{'active': sortBy !== 'default'}">
                <i class="el-icon-sort"></i>
                排序
                <i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                <el-dropdown-item 
                  v-for="option in sortOptions" 
                  :key="option.value"
                  :command="option.value"
                >{{ option.label }}</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>

        <div class="filter-actions">
          <el-button 
            link type="primary" 
            class="reset-btn" 
            @click="resetFilters" 
            v-if="hasFilters"
          >
            <i class="el-icon-refresh-right"></i> 重置筛选
          </el-button>
        </div>
      </div>

      <!-- 已选择的过滤条件 -->
      <div class="selected-filters" v-if="hasFilters">
        <div class="selected-filters-title">已选条件：</div>
        <div class="selected-filters-content">
          <el-tag 
            v-if="selectedCategory" 
            closable
            @close="handleCategoryChange('')"
            type="success"
            effect="light"
          >
            分类: {{ getCategoryName(selectedCategory) }}
          </el-tag>
          <el-tag 
            v-if="priceRange" 
            closable
            @close="handlePriceRangeChange('')"
            type="success"
            effect="light"
          >
            价格: {{ getPriceRangeLabel(priceRange) }}
          </el-tag>
          <el-tag 
            v-if="sortBy !== 'default'" 
            closable
            @close="handleSortChange('default')"
            type="success"
            effect="light"
          >
            {{ getSortLabel(sortBy) }}
          </el-tag>
          <el-tag 
            v-if="searchKeyword" 
            closable
            @close="clearSearch"
            type="success"
            effect="light"
          >
            关键词: {{ searchKeyword }}
          </el-tag>
        </div>
      </div>

      <!-- 商品列表 -->
      <div class="products-section" v-loading="loading">
        <transition-group name="fade-list" tag="div" class="grid-container">
          <div 
            v-for="product in products" 
            :key="product.id"
            class="product-item"
          >
            <product-card :product="product" @view-detail="handleViewDetail" />
          </div>
        </transition-group>
        
        <div v-if="!loading && products.length === 0" class="empty-state">
          <i class="el-icon-document"></i>
          <p>暂无相关绿证</p>
          <el-button type="primary" plain round @click="resetFilters">清除筛选条件</el-button>
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
      title="绿证详情"
      v-model="detailDialogVisible"
      width="900px"
      custom-class="product-detail-dialog"
      top="5vh"
    >
      <div v-if="selectedProduct" class="product-detail-content">
        <!-- 左侧：图片和关键信息 -->
        <div class="detail-left">
          <div class="detail-image-wrapper">
            <img 
              :src="selectedProduct.imageUrl?.startsWith('http') ? selectedProduct.imageUrl : `/api${selectedProduct.imageUrl}`" 
              :alt="selectedProduct.name"
              @error="handleDetailImageError"
            >
            <div class="detail-image-tags">
              <span v-if="selectedProduct.isNew" class="detail-tag new">新品</span>
              <span v-if="selectedProduct.isDiscount==1" class="detail-tag discount">特惠</span>
            </div>
          </div>
          
          <!-- 价格卡片 -->
          <div class="detail-price-card">
            <div class="detail-price-header">
              <span class="price-label">{{ selectedProduct.isDiscount==1 ? '特惠价格' : '绿证价格' }}</span>
              <span class="original-price" v-if="selectedProduct.isDiscount==1">原价 {{ selectedProduct.price }}积分</span>
            </div>
            <div class="detail-price-main">
              <span class="price-value">{{ selectedProduct.isDiscount==1 ? selectedProduct.discountPrice : selectedProduct.price }}</span>
              <span class="unit">积分/张</span>
            </div>
            <div class="detail-price-saving" v-if="selectedProduct.isDiscount==1">
              <i class="el-icon-s-finance"></i>
              每张节省 {{ selectedProduct.price - selectedProduct.discountPrice }} 积分
            </div>
          </div>

          <!-- 库存信息 -->
          <div class="detail-stock-info">
            <div class="stock-item">
              <i class="el-icon-box"></i>
              <span>可售: <strong>{{ selectedProduct.stock }}</strong> 张</span>
            </div>
            <div class="stock-item">
              <i class="el-icon-sold-out"></i>
              <span>已售: <strong>{{ selectedProduct.salesCount }}</strong> 张</span>
            </div>
          </div>

          <!-- 快速操作 -->
          <div class="detail-quick-actions">
            <el-button 
              type="primary" 
              class="detail-buy-btn"
              :disabled="selectedProduct.stock <= 0"
              @click="handleBuyFromDetail"
            >
              <i class="el-icon-shopping-cart-full"></i>
              {{ selectedProduct.stock <= 0 ? '已售罄' : '立即购买' }}
            </el-button>
            <el-button 
              type="default" 
              class="detail-cart-btn"
              :disabled="selectedProduct.stock <= 0"
              @click="handleAddToCartFromDetail"
            >
              <i class="el-icon-document-add"></i>
              加入待购
            </el-button>
          </div>
        </div>

        <!-- 右侧：详细信息 -->
        <div class="detail-right">
          <!-- 基本信息 -->
          <div class="detail-section">
            <h3 class="detail-title">{{ selectedProduct.name }}</h3>
            <p class="detail-desc">{{ selectedProduct.description || '优质绿色电力证书，来自可再生能源发电项目，助力企业实现碳中和目标。' }}</p>
          </div>

          <!-- 项目信息 -->
          <div class="detail-section">
            <h4 class="section-subtitle">
              <i class="el-icon-office-building"></i>
              项目信息
            </h4>
            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">项目编号</span>
                <span class="info-value">{{ selectedProduct.code || 'GEC-' + String(selectedProduct.id).padStart(8, '0') }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">发电类型</span>
                <span class="info-value">
                  <el-tag size="small" type="success">{{ selectedProduct.categoryName || '风力发电' }}</el-tag>
                </span>
              </div>
              <div class="info-item">
                <span class="info-label">项目地点</span>
                <span class="info-value">{{ selectedProduct.placeOfOrigin || '中国' }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">发电企业</span>
                <span class="info-value">{{ selectedProduct.company || '国家能源集团' }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">并网时间</span>
                <span class="info-value">{{ selectedProduct.gridDate || '2023年' }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">装机容量</span>
                <span class="info-value">{{ selectedProduct.capacity || '50MW' }}</span>
              </div>
            </div>
          </div>

          <!-- 环境效益 -->
          <div class="detail-section">
            <h4 class="section-subtitle">
              <i class="el-icon-sunny"></i>
              环境效益
            </h4>
            <div class="benefit-cards">
              <div class="benefit-card">
                <div class="benefit-icon co2">
                  <i class="el-icon-cloudy"></i>
                </div>
                <div class="benefit-info">
                  <span class="benefit-value">{{ selectedProduct.co2Reduction || '8,520' }} 吨</span>
                  <span class="benefit-label">减少CO₂排放</span>
                </div>
              </div>
              <div class="benefit-card">
                <div class="benefit-icon tree">
                  <i class="el-icon-s-custom"></i>
                </div>
                <div class="benefit-info">
                  <span class="benefit-value">{{ selectedProduct.treeEquivalent || '46.5' }} 万棵</span>
                  <span class="benefit-label">相当于植树</span>
                </div>
              </div>
              <div class="benefit-card">
                <div class="benefit-icon coal">
                  <i class="el-icon-box"></i>
                </div>
                <div class="benefit-info">
                  <span class="benefit-value">{{ selectedProduct.coalSaving || '3,420' }} 吨</span>
                  <span class="benefit-label">节约标准煤</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 绿证信息 -->
          <div class="detail-section">
            <h4 class="section-subtitle">
              <i class="el-icon-document-checked"></i>
              绿证信息
            </h4>
            <div class="certificate-info">
              <div class="cert-item">
                <span class="cert-label">绿证编号</span>
                <span class="cert-value">{{ selectedProduct.certificateCode || 'GEC-' + String(selectedProduct.id).padStart(8, '0') }}</span>
              </div>
              <div class="cert-item">
                <span class="cert-label">签发日期</span>
                <span class="cert-value">{{ selectedProduct.issueDate || '2024年' }}</span>
              </div>
              <div class="cert-item">
                <span class="cert-label">有效期至</span>
                <span class="cert-value">{{ selectedProduct.validDate || '长期有效' }}</span>
              </div>
              <div class="cert-item">
                <span class="cert-label">发电时段</span>
                <span class="cert-value">{{ selectedProduct.generationPeriod || '2024年1月-12月' }}</span>
              </div>
              <div class="cert-item">
                <span class="cert-label">认证机构</span>
                <span class="cert-value">{{ selectedProduct.issuer || '国家可再生能源信息管理中心' }}</span>
              </div>
              <div class="cert-item">
                <span class="cert-label">绿证类型</span>
                <span class="cert-value">{{ selectedProduct.certificateType || '绿色电力证书' }}</span>
              </div>
            </div>
          </div>

          <!-- 购买说明 -->
          <div class="detail-section">
            <h4 class="section-subtitle">
              <i class="el-icon-warning-outline"></i>
              购买说明
            </h4>
            <div class="rules-list">
              <div class="rule-line">
                <span class="rule-dot"></span>
                <span>绿证购买后可随时查看、下载电子证书</span>
              </div>
              <div class="rule-line">
                <span class="rule-dot"></span>
                <span>每张绿证对应1000千瓦时可再生能源电量</span>
              </div>
              <div class="rule-line">
                <span class="rule-dot"></span>
                <span>绿证可用于企业碳中和核算、绿色电力消费证明</span>
              </div>
              <div class="rule-line">
                <span class="rule-dot"></span>
                <span>购买后不支持退款，请确认后购买</span>
              </div>
              <div class="rule-line">
                <span class="rule-dot"></span>
                <span>如有疑问，请联系客服：400-888-8888</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import ProductCard from '@/components/front/ProductCard.vue'
import Request from '@/utils/request'
import { debounce } from 'lodash'

export default {
  name: 'Products',
  components: {
    FrontHeader,
    FrontFooter,
    ProductCard
  },
  data() {
    return {
      loading: false,
      products: [],
      categories: [],
      selectedCategory: '',
      priceRange: '',
      priceRanges: [
        { label: '0-50元', value: '0-50' },
        { label: '50-100元', value: '50-100' },
        { label: '100-200元', value: '100-200' },
        { label: '200元以上', value: '200-' }
      ],
      sortOptions: [
        { label: '默认排序', value: 'default' },
        { label: '销量优先', value: 'sales,desc' },
        { label: '价格从低到高', value: 'price,asc' },
        { label: '价格从高到低', value: 'price,desc' }
      ],
      sortBy: 'default',
      searchKeyword: '',
      currentPage: 1,
      pageSize: 12,
      total: 0,
      debouncedSearch: null,
      detailDialogVisible: false,
      selectedProduct: null
    }
  },
  computed: {
    hasFilters() {
      return this.selectedCategory || this.priceRange || this.sortBy !== 'default' || this.searchKeyword
    }
  },
  methods: {
    // 获取商品分类
    async getCategories() {
      try {
        const res = await Request.get('/category/all')
        if (res.code === '0') {
          this.categories = res.data
        }
      } catch (error) {
        console.error('获取分类失败:', error)
      }
    },
    // 获取商品列表
    async getProducts() {
      this.loading = true
      try {
        const params = {
          status: 1,
          currentPage: this.currentPage,
          size: this.pageSize
        }

        // 添加分类筛选
        if (this.selectedCategory) {
          params.categoryId = this.selectedCategory
        }

        // 添加价格区间筛选
        if (this.priceRange) {
          const [min, max] = this.priceRange.split('-')
          if (min) params.minPrice = min
          if (max) params.maxPrice = max
        }

        // 添加排序
        if (this.sortBy !== 'default') {
          const [field, order] = this.sortBy.split(',')
          params.sortField = field
          params.sortOrder = order
        }

        // 添加搜索关键词
        if (this.searchKeyword) {
          params.name = this.searchKeyword
        }

        const res = await Request.get('/product/page', { params })
        if (res.code === '0') {
          if (res.data && res.data.records) {
            this.products = res.data.records.map(product => ({
              ...product,
              isFavorite: false,
              imageUrl: product.imageUrl?.startsWith('http') ? product.imageUrl : `${product.imageUrl}`
            }))
            this.total = res.data.total
          } else {
            this.products = []
            this.total = 0
          }
        } else {
          this.products = []
          this.total = 0
        }
      } catch (error) {
        console.error('获取商品列表失败:', error)
        this.$message.error('获取商品列表失败')
        this.products = []
        this.total = 0
      } finally {
        this.loading = false
      }
    },
    handleCategoryChange(categoryId) {
      this.selectedCategory = categoryId
      this.currentPage = 1
      this.getProducts()
    },
    handlePriceRangeChange(range) {
      this.priceRange = range
      this.currentPage = 1
      this.getProducts()
    },
    handleSortChange(value) {
      this.sortBy = value
      this.currentPage = 1
      this.getProducts()
    },
    handleSearch() {
      this.debouncedSearch()
    },
    handlePageChange(page) {
      this.currentPage = page
      this.getProducts()
    },
    handleRouteChange() {
      const query = {}
      if (this.selectedCategory) {
        query.category = this.selectedCategory
      }
      if (this.searchKeyword) {
        query.keyword = this.searchKeyword
      }
      // 更新URL，但不触发路由变化
      this.$router.replace({ query }).catch(() => {})
    },
    getCategoryName(id) {
      const category = this.categories.find(c => c.id === id)
      return category ? category.name : '全部'
    },
    getPriceRangeLabel(value) {
      const range = this.priceRanges.find(r => r.value === value)
      return range ? range.label : '全部'
    },
    getSortLabel(value) {
      const option = this.sortOptions.find(o => o.value === value)
      return option ? option.label : '默认排序'
    },
    clearSearch() {
      this.searchKeyword = ''
      this.handleSearch()
    },
    resetFilters() {
      this.selectedCategory = ''
      this.priceRange = ''
      this.sortBy = 'default'
      this.searchKeyword = ''
      this.currentPage = 1
      this.getProducts()
    },
    handleSizeChange(size) {
      this.pageSize = size
      this.currentPage = 1
      this.getProducts()
    },
    // 查看详情
    handleViewDetail(product) {
      this.selectedProduct = product
      this.detailDialogVisible = true
    },
    // 详情页图片加载失败
    handleDetailImageError(e) {
      e.target.src = '/api/files/default-product.jpg'
    },
    // 从详情页购买
    handleBuyFromDetail() {
      if (!this.isLogin()) return
      this.detailDialogVisible = false
      this.$router.push(`/order?productId=${this.selectedProduct.id}`)
    },
    // 从详情页加入待购
    async handleAddToCartFromDetail() {
      if (!this.isLogin()) return
      try {
        const userInfo = JSON.parse(localStorage.getItem('frontUser') || '{}')
        const data = {
          userId: userInfo.id,
          productId: this.selectedProduct.id,
          quantity: 1
        }
        const res = await Request.post('/cart', data)
        if (res.code === '0') {
          this.$message.success('已添加到待购清单')
        } else {
          this.$message.error(res.msg || '添加失败')
        }
      } catch (error) {
        console.error('添加到待购清单失败:', error)
        this.$message.error('添加到待购清单失败')
      }
    },
    // 检查登录状态
    isLogin() {
      const userStr = localStorage.getItem('frontUser')
      if (!userStr) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return false
      }
      return true
    }
  },
  watch: {
    searchKeyword() {
      this.handleSearch()
      this.handleRouteChange()
    },
    selectedCategory() {
      this.handleRouteChange()
    },
    sortBy() {
      this.currentPage = 1
      this.getProducts()
    }
  },
  created() {
    this.debouncedSearch = debounce(() => {
      this.currentPage = 1
      this.getProducts()
    }, 300)

    this.getCategories()
    this.getProducts()
    
    const { category, keyword } = this.$route.query
    if (category) this.selectedCategory = category
    if (keyword) {
      this.searchKeyword = keyword
      this.handleSearch()
    }
  },
  beforeUnmount() {
    if (this.debouncedSearch) {
      this.debouncedSearch.cancel()
    }
  }
}
</script>

<style scoped>
.products-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(to bottom, #fff, #f8faf5);
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
  background: white;
  padding: 24px 30px;
  border-radius: 16px;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 6px;
  height: 100%;
  background: linear-gradient(to bottom, #67C23A, #85ce61);
}

.title-container {
  display: flex;
  flex-direction: column;
}

.page-title {
  display: flex;
  align-items: center;
  gap: 14px;
  margin: 0;
  font-size: 26px;
  font-weight: 600;
  color: #2c3e50;
}

.page-title i {
  font-size: 30px;
  color: #67C23A;
  background: rgba(103, 194, 58, 0.1);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.page-subtitle {
  margin-top: 8px;
  font-size: 15px;
  color: #909399;
  padding-left: 64px;
}

.search-box {
  width: 320px;
}

.search-box :deep(.el-input__inner) {
  height: 44px;
  border-radius: 22px;
  padding-left: 20px;
  border: 1px solid #ebeef5;
  transition: all 0.3s ease;
  font-size: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
}

.search-box :deep(.el-input__prefix) {
  left: 15px;
}

.search-box :deep(.el-input__inner:hover) {
  border-color: #c0c4cc;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.search-box :deep(.el-input__inner:focus) {
  border-color: #67C23A;
  box-shadow: 0 2px 12px rgba(103, 194, 58, 0.1);
}

/* 过滤器样式 */
.filter-bar {
  background: white;
  border-radius: 16px;
  padding: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  overflow: hidden;
}

.filter-group {
  display: flex;
  position: relative;
}

.filter-item {
  position: relative;
}

.filter-item:not(:last-child)::after {
  content: '';
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 1px;
  height: 20px;
  background: #ebeef5;
}

.filter-label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 16px 24px;
  transition: all 0.3s ease;
  color: #606266;
  font-size: 15px;
  position: relative;
  font-weight: 500;
}

.filter-label:hover, .filter-label.active {
  background: rgba(103, 194, 58, 0.08);
  color: #67C23A;
}

.filter-label.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 20px;
  height: 3px;
  background: #67C23A;
  border-radius: 3px;
}

.filter-actions {
  padding-right: 24px;
}

.reset-btn {
  color: #67C23A;
  font-size: 14px;
  font-weight: 500;
}

.reset-btn i {
  margin-right: 4px;
}

/* 已选择的过滤条件 */
.selected-filters {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
  padding: 16px 24px;
  background: rgba(103, 194, 58, 0.05);
  border-radius: 16px;
  border: 1px dashed rgba(103, 194, 58, 0.3);
}

.selected-filters-title {
  font-size: 14px;
  color: #67C23A;
  font-weight: 500;
  margin-right: 16px;
}

.selected-filters-content {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.selected-filters :deep(.el-tag) {
  padding: 0 12px;
  height: 32px;
  line-height: 30px;
  border-radius: 16px;
  font-size: 13px;
}

.selected-filters :deep(.el-tag .el-tag__close) {
  background-color: transparent;
  color: #67C23A;
  font-weight: bold;
  right: 0;
}

.selected-filters :deep(.el-tag .el-tag__close:hover) {
  background-color: #67C23A;
  color: white;
}

/* 下拉菜单样式优化 */
:deep(.el-dropdown-menu) {
  padding: 8px;
  border-radius: 12px;
  border: none;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
}

:deep(.el-dropdown-menu__item) {
  padding: 10px 20px;
  font-size: 14px;
  border-radius: 8px;
  margin: 4px 0;
  color: #606266;
  transition: all 0.2s ease;
}

:deep(.el-dropdown-menu__item:hover) {
  background-color: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

:deep(.el-dropdown-menu__item.is-disabled) {
  color: #c0c4cc;
  cursor: not-allowed;
  background-color: transparent;
}

/* 商品网格 */
.products-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  min-height: 500px;
  position: relative;
}

.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 30px;
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
.product-item:nth-child(7) { animation-delay: 0.35s; }
.product-item:nth-child(8) { animation-delay: 0.4s; }
.product-item:nth-child(9) { animation-delay: 0.45s; }
.product-item:nth-child(10) { animation-delay: 0.5s; }
.product-item:nth-child(11) { animation-delay: 0.55s; }
.product-item:nth-child(12) { animation-delay: 0.6s; }

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
  background-color: #67C23A;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled):hover) {
  color: #67C23A;
}

:deep(.el-pagination .btn-prev),
:deep(.el-pagination .btn-next) {
  border-radius: 50%;
  margin: 0 4px;
}

:deep(.el-select .el-input) {
  margin: 0 8px;
}

:deep(.el-pagination__total) {
  margin-right: 16px;
}

:deep(.el-pagination__jump) {
  margin-left: 16px;
}

/* 响应式布局优化 */
@media (max-width: 1200px) {
  .grid-container {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 24px;
  }
  
  .products-section {
    padding: 24px;
  }
}

@media (max-width: 992px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }
  
  .search-box {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 16px;
  }
  
  .page-header {
    padding: 20px;
    margin-bottom: 20px;
  }
  
  .page-title {
    font-size: 22px;
  }
  
  .page-title i {
    font-size: 24px;
    width: 42px;
    height: 42px;
  }
  
  .page-subtitle {
    padding-left: 56px;
    font-size: 14px;
  }

  .filter-bar {
    flex-direction: column;
  }
  
  .filter-group {
    width: 100%;
    overflow-x: auto;
    padding: 0;
  }
  
  .filter-label {
    padding: 14px 16px;
    white-space: nowrap;
    font-size: 14px;
  }
  
  .filter-actions {
    width: 100%;
    padding: 12px 16px;
    border-top: 1px solid #ebeef5;
    display: flex;
    justify-content: center;
  }

  .selected-filters {
    padding: 12px 16px;
    flex-direction: column;
    align-items: flex-start;
  }
  
  .selected-filters-title {
    margin-bottom: 8px;
    margin-right: 0;
  }
  
  .selected-filters-content {
    width: 100%;
  }

  .grid-container {
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
    gap: 16px;
  }
  
  .products-section {
    padding: 16px;
    border-radius: 12px;
  }
  
  .pagination-wrapper {
    margin-top: 24px;
  }
  
  :deep(.el-pagination) {
    padding: 12px;
    border-radius: 24px;
    flex-wrap: wrap;
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .grid-container {
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 12px;
  }
  
  .empty-state {
    padding: 60px 0;
  }
  
  .empty-state i {
    font-size: 48px;
  }
}

/* 详情对话框样式 */
.product-detail-content {
  display: flex;
  gap: 30px;
  max-height: 75vh;
  overflow-y: auto;
}

.detail-left {
  width: 320px;
  flex-shrink: 0;
  position: sticky;
  top: 0;
  height: fit-content;
}

.detail-image-wrapper {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 20px;
  background: #f8f9fa;
}

.detail-image-wrapper img {
  width: 100%;
  height: 220px;
  object-fit: cover;
}

.detail-image-tags {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  gap: 8px;
}

.detail-tag {
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
}

.detail-tag.new {
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
}

.detail-tag.discount {
  background: linear-gradient(135deg, #ff4757, #ff6b81);
  color: white;
}

/* 价格卡片 */
.detail-price-card {
  background: linear-gradient(135deg, #fff5f5, #fff);
  border: 1px solid #ffe4e4;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 16px;
}

.detail-price-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.detail-price-header .price-label {
  font-size: 14px;
  color: #ff4757;
  font-weight: 500;
}

.detail-price-header .original-price {
  font-size: 13px;
  color: #c0c4cc;
  text-decoration: line-through;
}

.detail-price-main {
  display: flex;
  align-items: baseline;
  gap: 4px;
  margin-bottom: 12px;
}

.detail-price-main .price-value {
  font-size: 42px;
  color: #ff4757;
  font-weight: 700;
  line-height: 1;
}

.detail-price-main .unit {
  font-size: 14px;
  color: #909399;
}

.detail-price-saving {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #67C23A;
  background: rgba(103, 194, 58, 0.1);
  padding: 8px 12px;
  border-radius: 8px;
}

.detail-price-saving i {
  font-size: 16px;
}

/* 库存信息 */
.detail-stock-info {
  background: #f8faf5;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 16px;
}

.stock-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px;
}

.stock-item:last-child {
  margin-bottom: 0;
}

.stock-item i {
  font-size: 16px;
  color: #67C23A;
}

.stock-item strong {
  color: #ff4757;
  font-size: 18px;
}

/* 快速操作 */
.detail-quick-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.detail-buy-btn {
  height: 48px;
  border-radius: 24px;
  font-size: 16px;
  font-weight: 600;
  background: linear-gradient(135deg, #ff4757, #ff6b81);
  border: none;
}

.detail-buy-btn:hover {
  background: linear-gradient(135deg, #ff6b81, #ff8fa3);
}

.detail-buy-btn:disabled {
  background: #c0c4cc;
}

.detail-cart-btn {
  height: 44px;
  border-radius: 22px;
  font-size: 15px;
  border: 1px solid #dcdfe6;
}

.detail-cart-btn:hover {
  border-color: #67C23A;
  color: #67C23A;
}

/* 右侧内容 */
.detail-right {
  flex: 1;
  min-width: 0;
}

.detail-section {
  margin-bottom: 28px;
  padding-bottom: 28px;
  border-bottom: 1px solid #ebeef5;
}

.detail-section:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
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
  color: #606266;
  margin: 0;
  line-height: 1.6;
}

.section-subtitle {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 16px;
}

.section-subtitle i {
  color: #67C23A;
  font-size: 18px;
}

/* 信息网格 */
.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
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

/* 规则列表 */
.rules-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.rule-line {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
}

.rule-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #67C23A;
  margin-top: 7px;
  flex-shrink: 0;
}

/* 响应式布局 */
@media (max-width: 768px) {
  .product-detail-content {
    flex-direction: column;
  }
  
  .detail-left {
    width: 100%;
    position: relative;
  }
  
  .benefit-cards {
    grid-template-columns: 1fr;
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style> 