<template>
  <div class="long-term-agreement-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <div class="title-container">
          <h2 class="page-title">
            <i class="el-icon-s-order"></i>
            <span>签订长期购买协议</span>
          </h2>
          <div class="page-subtitle">提前锁定绿证价格与供应量，规避市场价格波动风险</div>
        </div>
      </div>

      <!-- 协议优势 -->
      <div class="benefits-section">
        <div class="benefit-card">
          <div class="benefit-icon">
            <i class="el-icon-lock"></i>
          </div>
          <div class="benefit-info">
            <div class="benefit-title">价格锁定</div>
            <div class="benefit-desc">提前锁定绿证价格，规避市场波动风险</div>
          </div>
        </div>
        <div class="benefit-card">
          <div class="benefit-icon">
            <i class="el-icon-s-check"></i>
          </div>
          <div class="benefit-info">
            <div class="benefit-title">供应保障</div>
            <div class="benefit-desc">确保稳定绿证供应量，满足长期需求</div>
          </div>
        </div>
        <div class="benefit-card">
          <div class="benefit-icon">
            <i class="el-icon-office-building"></i>
          </div>
          <div class="benefit-info">
            <div class="benefit-title">ESG合规</div>
            <div class="benefit-desc">满足企业ESG披露和供应链准入要求</div>
          </div>
        </div>
        <div class="benefit-card">
          <div class="benefit-icon">
            <i class="el-icon-s-platform"></i>
          </div>
          <div class="benefit-info">
            <div class="benefit-title">一站式签约</div>
            <div class="benefit-desc">平台统一对接卖家，无需线下逐一对接</div>
          </div>
        </div>
      </div>

      <!-- 协议类型筛选 -->
      <div class="filter-section">
        <div class="filter-tabs">
          <span 
            class="tab-item" 
            :class="{ active: currentTab === 'all' }"
            @click="currentTab = 'all'"
          >全部协议</span>
          <span 
            class="tab-item" 
            :class="{ active: currentTab === 'monthly' }"
            @click="currentTab = 'monthly'"
          >月度协议</span>
          <span 
            class="tab-item" 
            :class="{ active: currentTab === 'quarterly' }"
            @click="currentTab = 'quarterly'"
          >季度协议</span>
          <span 
            class="tab-item" 
            :class="{ active: currentTab === 'yearly' }"
            @click="currentTab = 'yearly'"
          >年度协议</span>
        </div>
      </div>

      <!-- 协议产品列表 -->
      <div class="agreement-list-section" v-loading="loading">
        <div class="agreement-list">
          <div 
            v-for="agreement in filteredAgreements" 
            :key="agreement.id"
            class="agreement-card"
            :class="{ 'hot': agreement.isHot, 'recommended': agreement.isRecommended }"
          >
            <!-- 标签 -->
            <div class="card-tags">
              <span v-if="agreement.isHot" class="tag hot">热门</span>
              <span v-if="agreement.isRecommended" class="tag recommended">推荐</span>
              <span class="tag type">{{ agreement.typeLabel }}</span>
            </div>

            <!-- 协议信息 -->
            <div class="agreement-header">
              <h3 class="agreement-name">{{ agreement.name }}</h3>
              <p class="agreement-desc">{{ agreement.description }}</p>
            </div>

            <!-- 价格信息 -->
            <div class="price-section">
              <div class="price-main">
                <span class="price-symbol">¥</span>
                <span class="price-value">{{ agreement.price }}</span>
                <span class="price-unit">/{{ agreement.unit }}</span>
              </div>
              <div class="price-compare">
                市场价 <span class="market-price">¥{{ agreement.marketPrice }}</span>
                <span class="save-tag">省{{ calculateSave(agreement.price, agreement.marketPrice) }}%</span>
              </div>
            </div>

            <!-- 协议详情 -->
            <div class="agreement-details">
              <div class="detail-item">
                <i class="el-icon-time"></i>
                <span class="detail-label">协议期限</span>
                <span class="detail-value">{{ agreement.duration }}</span>
              </div>
              <div class="detail-item">
                <i class="el-icon-s-goods"></i>
                <span class="detail-label">最小采购量</span>
                <span class="detail-value">{{ agreement.minQuantity }} {{ agreement.unit }}</span>
              </div>
              <div class="detail-item">
                <i class="el-icon-s-marketing"></i>
                <span class="detail-label">预计总量</span>
                <span class="detail-value">{{ agreement.estimatedTotal }} {{ agreement.unit }}</span>
              </div>
              <div class="detail-item">
                <i class="el-icon-document-checked"></i>
                <span class="detail-label">交付方式</span>
                <span class="detail-value">{{ agreement.deliveryMethod }}</span>
              </div>
            </div>

            <!-- 服务保障 -->
            <div class="service-guarantee">
              <div class="guarantee-item" v-for="(item, index) in agreement.guarantees" :key="index">
                <i class="el-icon-check"></i>
                <span>{{ item }}</span>
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="action-section">
              <el-button 
                type="primary" 
                class="sign-btn"
                @click="handleSign(agreement)"
              >
                <i class="el-icon-edit"></i>
                立即签约
              </el-button>
              <el-button 
                link type="primary" 
                class="detail-btn"
                @click="handleViewDetail(agreement)"
              >
                查看详情
              </el-button>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="!loading && filteredAgreements.length === 0" class="empty-state">
          <i class="el-icon-s-order"></i>
          <p>暂无相关协议产品</p>
          <el-button type="primary" plain round @click="currentTab = 'all'">查看全部</el-button>
        </div>
      </div>

      <!-- 签约流程说明 -->
      <div class="process-section">
        <h3 class="section-title">
          <i class="el-icon-s-claim"></i>
          签约流程
        </h3>
        <div class="process-steps">
          <div class="process-step">
            <div class="step-number">1</div>
            <div class="step-icon">
              <i class="el-icon-search"></i>
            </div>
            <div class="step-title">选择协议</div>
            <div class="step-desc">浏览并选择适合您的长期采购协议</div>
          </div>
          <div class="step-arrow">
            <i class="el-icon-arrow-right"></i>
          </div>
          <div class="process-step">
            <div class="step-number">2</div>
            <div class="step-icon">
              <i class="el-icon-edit"></i>
            </div>
            <div class="step-title">提交申请</div>
            <div class="step-desc">填写企业信息和采购需求</div>
          </div>
          <div class="step-arrow">
            <i class="el-icon-arrow-right"></i>
          </div>
          <div class="process-step">
            <div class="step-number">3</div>
            <div class="step-icon">
              <i class="el-icon-s-check"></i>
            </div>
            <div class="step-title">资质审核</div>
            <div class="step-desc">平台审核企业资质和信用</div>
          </div>
          <div class="step-arrow">
            <i class="el-icon-arrow-right"></i>
          </div>
          <div class="process-step">
            <div class="step-number">4</div>
            <div class="step-icon">
              <i class="el-icon-document"></i>
            </div>
            <div class="step-title">签订合同</div>
            <div class="step-desc">在线签署长期采购协议</div>
          </div>
          <div class="step-arrow">
            <i class="el-icon-arrow-right"></i>
          </div>
          <div class="process-step">
            <div class="step-number">5</div>
            <div class="step-icon">
              <i class="el-icon-success"></i>
            </div>
            <div class="step-title">履约交付</div>
            <div class="step-desc">按协议约定定期交付绿证</div>
          </div>
        </div>
      </div>

      <!-- 服务承诺 -->
      <div class="commitment-section">
        <h3 class="section-title">
          <i class="el-icon-s-promotion"></i>
          服务承诺
        </h3>
        <div class="commitment-grid">
          <div class="commitment-item">
            <div class="commitment-icon">
              <i class="el-icon-s-finance"></i>
            </div>
            <h4>价格透明</h4>
            <p>协议价格公开透明，无隐藏费用</p>
          </div>
          <div class="commitment-item">
            <div class="commitment-icon">
              <i class="el-icon-s-claim"></i>
            </div>
            <h4>履约保障</h4>
            <p>平台担保履约，确保绿证按时交付</p>
          </div>
          <div class="commitment-item">
            <div class="commitment-icon">
              <i class="el-icon-service"></i>
            </div>
            <h4>专属服务</h4>
            <p>配备专属客户经理，全程跟踪服务</p>
          </div>
          <div class="commitment-item">
            <div class="commitment-icon">
              <i class="el-icon-s-data"></i>
            </div>
            <h4>数据支持</h4>
            <p>提供完整交易数据，助力ESG报告</p>
          </div>
        </div>
      </div>
    </div>
    <front-footer></front-footer>

    <!-- 签约申请对话框 -->
    <el-dialog
      title="长期采购协议签约申请"
      v-model="signDialogVisible"
      width="700px"
      custom-class="sign-dialog"
      :close-on-click-modal="false"
    >
      <div v-if="selectedAgreement" class="sign-dialog-content">
        <!-- 协议信息摘要 -->
        <div class="agreement-summary">
          <div class="summary-header">
            <h4>{{ selectedAgreement.name }}</h4>
            <el-tag type="success">{{ selectedAgreement.typeLabel }}</el-tag>
          </div>
          <div class="summary-info">
            <div class="info-row">
              <span class="label">协议价格：</span>
              <span class="value price">¥{{ selectedAgreement.price }}/{{ selectedAgreement.unit }}</span>
            </div>
            <div class="info-row">
              <span class="label">协议期限：</span>
              <span class="value">{{ selectedAgreement.duration }}</span>
            </div>
            <div class="info-row">
              <span class="label">最小采购量：</span>
              <span class="value">{{ selectedAgreement.minQuantity }} {{ selectedAgreement.unit }}</span>
            </div>
          </div>
        </div>

        <!-- 申请表单 -->
        <el-form :model="signForm" :rules="signRules" ref="signForm" label-width="120px" class="sign-form">
          <h5 class="form-section-title">企业信息</h5>
          <el-form-item label="企业名称" prop="companyName">
            <el-input v-model="signForm.companyName" placeholder="请输入企业全称"></el-input>
          </el-form-item>
          <el-form-item label="统一社会信用代码" prop="creditCode">
            <el-input v-model="signForm.creditCode" placeholder="请输入统一社会信用代码"></el-input>
          </el-form-item>
          <el-form-item label="企业联系人" prop="contactName">
            <el-input v-model="signForm.contactName" placeholder="请输入联系人姓名"></el-input>
          </el-form-item>
          <el-form-item label="联系电话" prop="contactPhone">
            <el-input v-model="signForm.contactPhone" placeholder="请输入联系电话"></el-input>
          </el-form-item>
          <el-form-item label="联系邮箱" prop="contactEmail">
            <el-input v-model="signForm.contactEmail" placeholder="请输入联系邮箱"></el-input>
          </el-form-item>

          <h5 class="form-section-title">采购需求</h5>
          <el-form-item label="采购数量" prop="quantity">
            <el-input-number 
              v-model="signForm.quantity" 
              :min="selectedAgreement.minQuantity" 
              :step="100"
              style="width: 200px;"
            ></el-input-number>
            <span class="unit-text">{{ selectedAgreement.unit }}</span>
          </el-form-item>
          <el-form-item label="预计开始时间" prop="startDate">
            <el-date-picker
              v-model="signForm.startDate"
              type="date"
              placeholder="选择协议开始日期"
              style="width: 200px;"
            ></el-date-picker>
          </el-form-item>
          <el-form-item label="用途说明" prop="purpose">
            <el-select v-model="signForm.purpose" placeholder="请选择用途" style="width: 200px;">
              <el-option label="企业碳中和" value="carbon_neutral"></el-option>
              <el-option label="ESG披露" value="esg"></el-option>
              <el-option label="供应链准入" value="supply_chain"></el-option>
              <el-option label="绿色电力消费" value="green_power"></el-option>
              <el-option label="其他" value="other"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="备注说明" prop="remark">
            <el-input 
              v-model="signForm.remark" 
              type="textarea" 
              :rows="3"
              placeholder="请输入其他备注信息（选填）"
            ></el-input>
          </el-form-item>

          <h5 class="form-section-title">协议条款</h5>
          <div class="terms-section">
            <el-checkbox v-model="signForm.agreeTerms">
              我已阅读并同意
              <el-button link type="primary" @click="showTerms">《长期采购协议条款》</el-button>
            </el-checkbox>
            <div class="terms-summary">
              <p><i class="el-icon-info"></i> 签约即表示同意以下核心条款：</p>
              <ul>
                <li>按协议约定价格和数量采购绿证</li>
                <li>按时支付协议款项</li>
                <li>平台将统一对接卖家，确保绿证供应</li>
                <li>协议期内价格锁定，不受市场波动影响</li>
              </ul>
            </div>
          </div>
        </el-form>
      </div>
      <template #footer>
        <div class="dialog-footer">
        <el-button @click="signDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitSign" :loading="submitting" :disabled="!signForm.agreeTerms">
          提交申请
        </el-button>
      </div>
      </template>
    </el-dialog>

    <!-- 协议详情对话框 -->
    <el-dialog
      :title="selectedAgreement ? selectedAgreement.name + ' - 详情' : '协议详情'"
      v-model="detailDialogVisible"
      width="900px"
      custom-class="detail-dialog"
      :close-on-click-modal="false"
      top="5vh"
    >
      <div v-if="selectedAgreement" class="detail-dialog-content">
        <!-- 头部信息 -->
        <div class="detail-header">
          <div class="detail-tags">
            <el-tag v-if="selectedAgreement.isHot" type="danger">热门</el-tag>
            <el-tag v-if="selectedAgreement.isRecommended" type="success">推荐</el-tag>
            <el-tag type="primary">{{ selectedAgreement.typeLabel }}</el-tag>
          </div>
          <h3 class="detail-title">{{ selectedAgreement.name }}</h3>
          <p class="detail-desc">{{ selectedAgreement.description }}</p>
        </div>

        <!-- 价格信息 -->
        <div class="detail-price-section">
          <div class="price-main">
            <span class="price-symbol">¥</span>
            <span class="price-value">{{ selectedAgreement.price }}</span>
            <span class="price-unit">/{{ selectedAgreement.unit }}</span>
          </div>
          <div class="price-info">
            <span class="market-price">市场价 ¥{{ selectedAgreement.marketPrice }}</span>
            <span class="save-amount">预计节省 ¥{{ calculateSaveAmount(selectedAgreement.price, selectedAgreement.marketPrice, selectedAgreement.estimatedTotal) }}</span>
          </div>
        </div>

        <!-- 协议规格 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-s-order"></i> 协议规格</h4>
          <div class="spec-grid">
            <div class="spec-item">
              <span class="spec-label">协议类型</span>
              <span class="spec-value">{{ selectedAgreement.typeLabel }}</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">协议期限</span>
              <span class="spec-value">{{ selectedAgreement.duration }}</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">最小采购量</span>
              <span class="spec-value">{{ selectedAgreement.minQuantity }} {{ selectedAgreement.unit }}</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">预计总量</span>
              <span class="spec-value">{{ selectedAgreement.estimatedTotal }} {{ selectedAgreement.unit }}</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">交付周期</span>
              <span class="spec-value">{{ selectedAgreement.deliveryCycle }}</span>
            </div>
            <div class="spec-item">
              <span class="spec-label">交付方式</span>
              <span class="spec-value">{{ selectedAgreement.deliveryMethod }}</span>
            </div>
          </div>
        </div>

        <!-- 服务保障 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-s-claim"></i> 服务保障</h4>
          <div class="guarantee-list">
            <div class="guarantee-item" v-for="(item, index) in selectedAgreement.guarantees" :key="index">
              <i class="el-icon-check"></i>
              <span>{{ item }}</span>
            </div>
          </div>
        </div>

        <!-- 适用场景 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-s-flag"></i> 适用场景</h4>
          <div class="scenario-tags">
            <el-tag v-for="(scenario, index) in selectedAgreement.scenarios" :key="index" type="info" effect="plain">
              {{ scenario }}
            </el-tag>
          </div>
        </div>

        <!-- 协议条款 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-document"></i> 协议条款</h4>
          <div class="terms-list">
            <div class="term-item" v-for="(term, index) in selectedAgreement.terms" :key="index">
              <div class="term-number">{{ index + 1 }}</div>
              <div class="term-content">
                <h5>{{ term.title }}</h5>
                <p>{{ term.content }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="detail-actions">
          <el-button type="primary" size="large" class="sign-btn" @click="handleSignFromDetail">
            <i class="el-icon-edit"></i>
            立即签约
          </el-button>
          <el-button size="large" @click="detailDialogVisible = false">
            关闭
          </el-button>
        </div>
      </div>
    </el-dialog>

    <!-- 协议条款弹窗 -->
    <el-dialog
      title="长期采购协议条款"
      v-model="termsDialogVisible"
      width="800px"
      custom-class="terms-dialog"
    >
      <div class="terms-content">
        <h4>一、协议主体</h4>
        <p>本协议由采购企业（以下简称"甲方"）与绿证交易平台（以下简称"乙方"）共同签署，平台将统一对接绿证卖家，确保绿证供应。</p>
        
        <h4>二、协议期限</h4>
        <p>协议期限根据选择的协议类型确定，包括月度、季度、年度等不同时间跨度。协议到期后，双方可协商续约。</p>
        
        <h4>三、价格锁定</h4>
        <p>协议期内，绿证采购价格按签约时确定的价格执行，不受市场价格波动影响。甲方享受价格保护，乙方承担市场风险。</p>
        
        <h4>四、供应保障</h4>
        <p>乙方承诺按协议约定的时间和数量向甲方交付绿证。如因乙方原因导致供应不足，乙方应承担相应违约责任。</p>
        
        <h4>五、付款方式</h4>
        <p>甲方可选择按月预付、季度结算或年度一次性付款等方式。具体付款方式在签约时确定。</p>
        
        <h4>六、交付方式</h4>
        <p>绿证以电子凭证形式交付，甲方可在平台账户中查看、下载和管理绿证。乙方确保绿证的真实性和有效性。</p>
        
        <h4>七、违约责任</h4>
        <p>任何一方违反协议约定，应承担相应的违约责任。具体违约责任在协议正文中详细约定。</p>
        
        <h4>八、争议解决</h4>
        <p>协议履行过程中如发生争议，双方应友好协商解决；协商不成的，可向乙方所在地人民法院提起诉讼。</p>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import Request from '@/utils/request'

export default {
  name: 'LongTermAgreement',
  components: {
    FrontHeader,
    FrontFooter
  },
  data() {
    return {
      loading: false,
      currentTab: 'all',
      agreements: [],
      signDialogVisible: false,
      detailDialogVisible: false,
      termsDialogVisible: false,
      selectedAgreement: null,
      submitting: false,
      signForm: {
        companyName: '',
        creditCode: '',
        contactName: '',
        contactPhone: '',
        contactEmail: '',
        quantity: 100,
        startDate: '',
        purpose: '',
        remark: '',
        agreeTerms: false
      },
      signRules: {
        companyName: [
          { required: true, message: '请输入企业名称', trigger: 'blur' }
        ],
        creditCode: [
          { required: true, message: '请输入统一社会信用代码', trigger: 'blur' },
          { pattern: /^[0-9A-HJ-NPQRTUWXY]{2}\d{6}[0-9A-HJ-NPQRTUWXY]{10}$/, message: '请输入正确的统一社会信用代码', trigger: 'blur' }
        ],
        contactName: [
          { required: true, message: '请输入联系人姓名', trigger: 'blur' }
        ],
        contactPhone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ],
        contactEmail: [
          { required: true, message: '请输入联系邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ],
        quantity: [
          { required: true, message: '请输入采购数量', trigger: 'change' }
        ],
        startDate: [
          { required: true, message: '请选择预计开始时间', trigger: 'change' }
        ],
        purpose: [
          { required: true, message: '请选择用途说明', trigger: 'change' }
        ]
      }
    }
  },
  computed: {
    filteredAgreements() {
      if (this.currentTab === 'all') {
        return this.agreements
      }
      return this.agreements.filter(item => item.type === this.currentTab)
    }
  },
  methods: {
    // 获取协议列表
    async getAgreements() {
      this.loading = true
      try {
        // 协议方案为平台内置展示模板；用户已提交的签约申请走真实接口
        this.agreements = this.buildTemplates()
      } finally {
        this.loading = false
      }
    },
    // 计算节省百分比
    calculateSave(price, marketPrice) {
      return Math.round((1 - price / marketPrice) * 100)
    },
    // 计算节省金额
    calculateSaveAmount(price, marketPrice, total) {
      return ((marketPrice - price) * total).toLocaleString()
    },
    // 处理签约
    handleSign(agreement) {
      const userInfo = localStorage.getItem('frontUser')
      if (!userInfo) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      this.selectedAgreement = agreement
      this.signForm.quantity = agreement.minQuantity
      this.signForm.agreeTerms = false
      this.signDialogVisible = true
    },
    // 从详情页签约
    handleSignFromDetail() {
      this.detailDialogVisible = false
      setTimeout(() => {
        this.handleSign(this.selectedAgreement)
      }, 300)
    },
    // 查看详情
    handleViewDetail(agreement) {
      this.selectedAgreement = agreement
      this.detailDialogVisible = true
    },
    // 显示条款
    showTerms() {
      this.termsDialogVisible = true
    },
    // 平台内置协议模板（演示数据）
    buildTemplates() {
      return [
        { id: 1, name: '月度绿证采购协议', description: '适合有短期绿证需求的企业，按月锁定价格和供应量，灵活调整采购计划', type: 'monthly', typeLabel: '月度协议', price: 28.8, marketPrice: 35.0, unit: '张', duration: '1个月', minQuantity: 100, estimatedTotal: 100, deliveryCycle: '每月交付', deliveryMethod: '电子凭证', isHot: false, isRecommended: false, guarantees: ['价格锁定', '供应保障', '灵活调整', '专属客服'], scenarios: ['短期碳中和需求', '月度ESG报告', '临时供应链准入'], terms: [{ title: '协议期限', content: '协议有效期为1个月，自签约之日起计算。到期后可选择续约或终止。' }, { title: '价格锁定', content: '协议期内绿证价格锁定为¥28.8/张，不受市场价格波动影响。' }, { title: '交付方式', content: '每月按约定数量交付绿证，以电子凭证形式发放至企业账户。' }, { title: '付款方式', content: '签约时预付全部款项，支持银行转账、在线支付等多种方式。' }] },
        { id: 2, name: '季度绿证采购协议', description: '适合有稳定季度需求的企业，享受更优惠价格，季度统一结算', type: 'quarterly', typeLabel: '季度协议', price: 26.8, marketPrice: 35.0, unit: '张', duration: '3个月', minQuantity: 300, estimatedTotal: 300, deliveryCycle: '每月交付', deliveryMethod: '电子凭证', isHot: true, isRecommended: false, guarantees: ['价格优惠', '供应稳定', '季度结算', '专属客服', '数据报告'], scenarios: ['季度碳中和目标', '季度ESG披露', '供应链季度审核', '绿色电力消费证明'], terms: [{ title: '协议期限', content: '协议有效期为3个月，自签约之日起计算。季度结束后可续约。' }, { title: '价格优惠', content: '季度协议享受更优惠价格¥26.8/张，比月度协议节省约7%。' }, { title: '交付方式', content: '每月按约定数量交付绿证，季度内总量不少于最小采购量。' }, { title: '付款方式', content: '支持季度预付或按月分期付款，具体方式可协商确定。' }] },
        { id: 3, name: '年度绿证采购协议', description: '适合有长期稳定需求的企业，享受最优价格，年度统一规划，满足ESG披露和供应链准入要求', type: 'yearly', typeLabel: '年度协议', price: 24.8, marketPrice: 35.0, unit: '张', duration: '12个月', minQuantity: 1000, estimatedTotal: 1200, deliveryCycle: '每月交付', deliveryMethod: '电子凭证', isHot: false, isRecommended: true, guarantees: ['最优价格', '优先供应', '年度结算', '专属客户经理', '完整数据报告', 'ESG支持'], scenarios: ['年度碳中和目标', '年度ESG报告', '供应链长期准入', '绿色电力消费规划', '企业可持续发展'], terms: [{ title: '协议期限', content: '协议有效期为12个月，自签约之日起计算。年度结束后优先续约。' }, { title: '最优价格', content: '年度协议享受最优价格¥24.8/张，比市场价节省约29%。' }, { title: '优先供应', content: '在供应紧张时，年度协议客户享受优先供应保障。' }, { title: '交付方式', content: '每月按约定数量交付绿证，年度内总量不少于最小采购量。' }, { title: '付款方式', content: '支持年度预付、季度付款或按月分期，灵活选择付款方式。' }, { title: 'ESG支持', content: '提供完整的绿证消费数据报告，支持企业ESG披露和审计。' }] }
      ]
    },
    // 提交签约申请
    submitSign() {
      this.$refs.signForm.validate(async (valid) => {
        if (!valid) {
          return false
        }
        
        if (!this.signForm.agreeTerms) {
          this.$message.warning('请阅读并同意协议条款')
          return
        }

        this.submitting = true
        try {
          const res = await Request.post('/agreement/apply', {
            name: this.selectedAgreement ? this.selectedAgreement.name : '',
            type: this.selectedAgreement ? this.selectedAgreement.type : 'monthly',
            companyName: this.signForm.companyName,
            creditCode: this.signForm.creditCode,
            contactName: this.signForm.contactName,
            contactPhone: this.signForm.contactPhone,
            contactEmail: this.signForm.contactEmail,
            quantity: this.signForm.quantity,
            startDate: this.signForm.startDate,
            purpose: this.signForm.purpose,
            remark: this.signForm.remark
          })
          if (res.code === '0') {
            this.$message.success(res.msg || '签约申请已提交，我们将尽快与您联系！')
            this.signDialogVisible = false
            this.$refs.signForm.resetFields()
            this.signForm.agreeTerms = false
          } else {
            this.$message.error(res.msg || '提交失败，请重试')
          }
        } catch (error) {
          this.$message.error('提交失败，请重试')
        } finally {
          this.submitting = false
        }
      })
    }
  },
  created() {
    this.getAgreements()
  }
}
</script>

<style scoped>
.long-term-agreement-page {
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
  background: linear-gradient(135deg, #67C23A 0%, #85ce61 100%);
  padding: 30px;
  border-radius: 16px;
  box-shadow: 0 8px 24px rgba(103, 194, 58, 0.25);
  position: relative;
  overflow: hidden;
}

.page-header::before {
  content: '';
  position: absolute;
  left: -50%;
  top: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 60%);
  animation: pulse 4s ease-in-out infinite;
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

/* 优势卡片 */
.benefits-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.benefit-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
}

.benefit-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.benefit-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
  flex-shrink: 0;
}

.benefit-info {
  flex: 1;
}

.benefit-title {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 4px;
}

.benefit-desc {
  font-size: 13px;
  color: #909399;
  line-height: 1.5;
}

/* 筛选标签 */
.filter-section {
  margin-bottom: 24px;
}

.filter-tabs {
  display: flex;
  gap: 12px;
  background: white;
  padding: 16px 24px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.tab-item {
  padding: 10px 24px;
  border-radius: 20px;
  font-size: 14px;
  color: #606266;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #f5f7fa;
}

.tab-item:hover {
  background: #e4e7ed;
}

.tab-item.active {
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  font-weight: 500;
}

/* 协议列表 */
.agreement-list-section {
  margin-bottom: 30px;
}

.agreement-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 24px;
}

.agreement-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
  position: relative;
  border: 2px solid transparent;
}

.agreement-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
}

.agreement-card.hot {
  border-color: #f56c6c;
}

.agreement-card.recommended {
  border-color: #67C23A;
}

.card-tags {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.tag {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.tag.hot {
  background: #fef0f0;
  color: #f56c6c;
}

.tag.recommended {
  background: #f0f9eb;
  color: #67C23A;
}

.tag.type {
  background: #ecf5ff;
  color: #409EFF;
}

.agreement-header {
  margin-bottom: 16px;
}

.agreement-name {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 8px;
}

.agreement-desc {
  font-size: 13px;
  color: #909399;
  margin: 0;
  line-height: 1.5;
}

/* 价格区域 */
.price-section {
  background: linear-gradient(135deg, #f8faf5, #fff);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 16px;
}

.price-main {
  display: flex;
  align-items: baseline;
  gap: 4px;
  margin-bottom: 8px;
}

.price-symbol {
  font-size: 20px;
  color: #f56c6c;
  font-weight: 600;
}

.price-value {
  font-size: 32px;
  color: #f56c6c;
  font-weight: 700;
}

.price-unit {
  font-size: 14px;
  color: #909399;
}

.price-compare {
  font-size: 13px;
  color: #909399;
}

.market-price {
  text-decoration: line-through;
  margin-right: 8px;
}

.save-tag {
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  padding: 2px 10px;
  border-radius: 10px;
  font-size: 12px;
}

/* 协议详情 */
.agreement-details {
  margin-bottom: 16px;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 0;
  border-bottom: 1px dashed #e4e7ed;
}

.detail-item:last-child {
  border-bottom: none;
}

.detail-item i {
  color: #67C23A;
  font-size: 14px;
}

.detail-label {
  font-size: 13px;
  color: #909399;
  flex: 1;
}

.detail-value {
  font-size: 13px;
  color: #2c3e50;
  font-weight: 500;
}

/* 服务保障 */
.service-guarantee {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 16px;
}

.guarantee-item {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  background: #f0f9eb;
  border-radius: 8px;
  font-size: 12px;
  color: #67C23A;
}

.guarantee-item i {
  font-size: 12px;
}

/* 操作按钮 */
.action-section {
  display: flex;
  gap: 12px;
}

.sign-btn {
  flex: 1;
  height: 44px;
  border-radius: 22px;
  font-size: 15px;
  font-weight: 500;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  border: none;
}

.sign-btn:hover {
  background: linear-gradient(135deg, #5ab82f, #79c152);
}

.detail-btn {
  color: #909399;
}

.detail-btn:hover {
  color: #67C23A;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 0;
  color: #909399;
  background: white;
  border-radius: 16px;
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

/* 流程说明 */
.process-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  margin-bottom: 30px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 24px;
}

.section-title i {
  color: #67C23A;
  font-size: 22px;
}

.process-steps {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: 16px;
}

.process-step {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 20px;
  background: #f8faf5;
  border-radius: 12px;
  width: 160px;
  position: relative;
}

.step-number {
  position: absolute;
  top: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
}

.step-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.step-icon i {
  font-size: 20px;
  color: #67C23A;
}

.step-title {
  font-size: 15px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 6px;
}

.step-desc {
  font-size: 12px;
  color: #909399;
  line-height: 1.4;
}

.step-arrow {
  color: #c0c4cc;
  font-size: 20px;
}

/* 服务承诺 */
.commitment-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
}

.commitment-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
}

.commitment-item {
  text-align: center;
  padding: 24px;
  background: #f8faf5;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.commitment-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(103, 194, 58, 0.15);
}

.commitment-icon {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
}

.commitment-icon i {
  font-size: 24px;
  color: white;
}

.commitment-item h4 {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 8px;
}

.commitment-item p {
  font-size: 13px;
  color: #909399;
  margin: 0;
  line-height: 1.5;
}

/* 签约对话框 */
.sign-dialog-content {
  max-height: 60vh;
  overflow-y: auto;
}

.agreement-summary {
  background: #f8faf5;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
}

.summary-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.summary-header h4 {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
}

.summary-info .info-row {
  display: flex;
  padding: 8px 0;
  border-bottom: 1px dashed #e4e7ed;
}

.summary-info .info-row:last-child {
  border-bottom: none;
}

.summary-info .label {
  font-size: 13px;
  color: #909399;
  width: 100px;
}

.summary-info .value {
  font-size: 13px;
  color: #2c3e50;
  font-weight: 500;
}

.summary-info .value.price {
  color: #f56c6c;
  font-size: 16px;
  font-weight: 600;
}

.form-section-title {
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  margin: 24px 0 16px;
  padding-bottom: 8px;
  border-bottom: 1px solid #e4e7ed;
}

.unit-text {
  margin-left: 8px;
  color: #909399;
}

.terms-section {
  margin-top: 16px;
}

.terms-summary {
  margin-top: 12px;
  padding: 16px;
  background: #f8faf5;
  border-radius: 8px;
}

.terms-summary p {
  font-size: 13px;
  color: #67C23A;
  margin: 0 0 8px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.terms-summary ul {
  margin: 0;
  padding-left: 20px;
}

.terms-summary li {
  font-size: 13px;
  color: #606266;
  line-height: 1.8;
}

/* 详情对话框 */
.detail-dialog-content {
  max-height: 70vh;
  overflow-y: auto;
}

.detail-header {
  margin-bottom: 24px;
}

.detail-tags {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
}

.detail-title {
  font-size: 22px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 10px;
}

.detail-desc {
  font-size: 14px;
  color: #909399;
  margin: 0;
  line-height: 1.6;
}

.detail-price-section {
  background: linear-gradient(135deg, #f8faf5, #fff);
  border: 1px solid #e4e7ed;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
}

.detail-price-section .price-main {
  margin-bottom: 12px;
}

.detail-price-section .price-info {
  display: flex;
  gap: 16px;
  font-size: 14px;
}

.detail-price-section .market-price {
  color: #909399;
  text-decoration: line-through;
}

.detail-price-section .save-amount {
  color: #67C23A;
  font-weight: 500;
}

.detail-section {
  margin-bottom: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #ebeef5;
}

.detail-section:last-of-type {
  border-bottom: none;
}

.detail-section .section-title {
  font-size: 16px;
  margin-bottom: 16px;
}

.spec-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.spec-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.spec-label {
  font-size: 13px;
  color: #909399;
}

.spec-value {
  font-size: 14px;
  color: #2c3e50;
  font-weight: 500;
}

.guarantee-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.guarantee-list .guarantee-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: #f0f9eb;
  border-radius: 8px;
  font-size: 14px;
  color: #67C23A;
}

.scenario-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.terms-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.term-item {
  display: flex;
  gap: 12px;
}

.term-number {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  flex-shrink: 0;
}

.term-content h5 {
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 6px;
}

.term-content p {
  font-size: 13px;
  color: #606266;
  margin: 0;
  line-height: 1.6;
}

.detail-actions {
  display: flex;
  gap: 16px;
  margin-top: 24px;
}

.detail-actions .sign-btn {
  flex: 1;
  height: 48px;
  border-radius: 24px;
  font-size: 16px;
}

/* 条款弹窗 */
.terms-content {
  max-height: 60vh;
  overflow-y: auto;
  padding-right: 16px;
}

.terms-content h4 {
  font-size: 15px;
  font-weight: 600;
  color: #2c3e50;
  margin: 20px 0 10px;
}

.terms-content h4:first-child {
  margin-top: 0;
}

.terms-content p {
  font-size: 14px;
  color: #606266;
  line-height: 1.8;
  margin: 0 0 16px;
}

/* 响应式布局 */
@media (max-width: 1200px) {
  .benefits-section {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .commitment-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .spec-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 992px) {
  .page-header {
    padding: 24px;
  }
  
  .page-title {
    font-size: 22px;
  }
  
  .page-title i {
    width: 48px;
    height: 48px;
    font-size: 24px;
  }
  
  .page-subtitle {
    padding-left: 62px;
  }
  
  .process-steps {
    flex-direction: column;
  }
  
  .step-arrow {
    transform: rotate(90deg);
  }
  
  .process-step {
    width: 100%;
    max-width: 300px;
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 16px;
  }
  
  .benefits-section {
    grid-template-columns: 1fr;
  }
  
  .filter-tabs {
    flex-wrap: wrap;
    padding: 12px 16px;
  }
  
  .tab-item {
    padding: 8px 16px;
    font-size: 13px;
  }
  
  .agreement-list {
    grid-template-columns: 1fr;
  }
  
  .commitment-grid {
    grid-template-columns: 1fr;
  }
  
  .spec-grid {
    grid-template-columns: 1fr;
  }
  
  .detail-actions {
    flex-direction: column;
  }
}
</style>
