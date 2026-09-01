<template>
  <div class="group-buying-page">
    <front-header></front-header>
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <div class="title-container">
          <h2 class="page-title">
            <i class="el-icon-user-solid"></i>
            <span>绿证拼团活动</span>
          </h2>
          <div class="page-subtitle">多人拼团，享受更优惠的绿证价格</div>
        </div>
      </div>

      <!-- 拼团活动统计 -->
      <div class="stats-section">
        <div class="stat-card">
          <div class="stat-icon">
            <i class="el-icon-s-flag"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.ongoing }}</div>
            <div class="stat-label">进行中</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon hot">
            <i class="el-icon-s-claim"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.success }}</div>
            <div class="stat-label">拼团成功</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon success">
            <i class="el-icon-s-custom"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.participants }}</div>
            <div class="stat-label">参与人数</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon warning">
            <i class="el-icon-s-goods"></i>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.savedAmount }}</div>
            <div class="stat-label">累计节省(万元)</div>
          </div>
        </div>
      </div>

      <!-- 拼团活动列表 -->
      <div class="group-list-section" v-loading="loading">
        <div class="section-header">
          <h3 class="section-title">
            <i class="el-icon-s-promotion"></i>
            热门拼团
          </h3>
          <div class="filter-tabs">
            <span 
              class="tab-item" 
              :class="{ active: currentTab === 'all' }"
              @click="currentTab = 'all'"
            >全部</span>
            <span 
              class="tab-item" 
              :class="{ active: currentTab === 'ongoing' }"
              @click="currentTab = 'ongoing'"
            >进行中</span>
            <span 
              class="tab-item" 
              :class="{ active: currentTab === 'success' }"
              @click="currentTab = 'success'"
            >即将成团</span>
          </div>
        </div>

        <div class="group-list">
          <div 
            v-for="group in filteredGroups" 
            :key="group.id"
            class="group-card"
            :class="{ 'ending-soon': group.isEndingSoon, 'full': group.current >= group.target }"
          >
            <!-- 标签 -->
            <div class="card-tags">
              <span v-if="group.isEndingSoon" class="tag ending">即将截止</span>
              <span v-if="group.current >= group.target" class="tag full">已满员</span>
              <span v-else-if="group.discount" class="tag discount">{{ group.discount }}折</span>
            </div>

            <!-- 商品图片 -->
            <div class="product-image" @click="handleViewDetail(group)">
              <img :src="group.image" :alt="group.name" @error="handleImageError($event, group)">
              <div class="image-overlay">
                <span class="view-detail">查看详情</span>
              </div>
            </div>

            <!-- 商品信息 -->
            <div class="product-info">
              <h4 class="product-name">{{ group.name }}</h4>
              <p class="product-desc">{{ group.description }}</p>
              
              <!-- 价格信息 -->
              <div class="price-info">
                <div class="current-price">
                  <span class="price-label">拼团价</span>
                  <span class="price-value">¥{{ group.groupPrice }}</span>
                  <span class="unit">/张</span>
                </div>
                <div class="original-price">
                  原价 ¥{{ group.originalPrice }}/张
                </div>
              </div>

              <!-- 进度信息 -->
              <div class="progress-section">
                <div class="progress-header">
                  <span class="progress-text">已拼 {{ group.current }}/{{ group.target }} 人</span>
                  <span class="remain-text">还差 {{ group.target - group.current }} 人</span>
                </div>
                <div class="progress-bar">
                  <div 
                    class="progress-fill" 
                    :style="{ width: (group.current / group.target * 100) + '%' }"
                  ></div>
                </div>
                <div class="time-left">
                  <i class="el-icon-time"></i>
                  剩余 {{ formatTimeLeft(group.endTime) }}
                </div>
              </div>

              <!-- 参与用户头像 -->
              <div class="participants">
                <div class="avatar-list">
                  <img 
                    v-for="(user, index) in group.participants.slice(0, 5)" 
                    :key="index"
                    :src="user.avatar" 
                    class="participant-avatar"
                    :title="user.name"
                  >
                  <div v-if="group.participants.length > 5" class="more-avatars">
                    +{{ group.participants.length - 5 }}
                  </div>
                </div>
                <span class="participant-count">{{ group.participants.length }}人已参与</span>
              </div>

              <!-- 操作按钮 -->
              <div class="action-section">
                <el-button 
                  type="primary" 
                  class="join-btn"
                  :disabled="group.current >= group.target || group.status === 'ended'"
                  @click="handleJoin(group)"
                >
                  <i class="el-icon-s-flag"></i>
                  {{ group.current >= group.target ? '已满员' : (group.status === 'ended' ? '已结束' : '立即参团') }}
                </el-button>
                <el-button 
                  link type="primary" 
                  class="share-btn"
                  @click="handleShare(group)"
                >
                  <i class="el-icon-share"></i>
                  分享
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-if="!loading && filteredGroups.length === 0" class="empty-state">
          <i class="el-icon-s-promotion"></i>
          <p>暂无拼团活动</p>
          <el-button type="primary" plain round @click="currentTab = 'all'">查看全部</el-button>
        </div>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination
            background
            :current-page="currentPage"
            :page-size="pageSize"
            :total="total"
            layout="prev, pager, next, jumper, total"
            @current-change="handlePageChange"
          >
          </el-pagination>
        </div>
      </div>

      <!-- 拼团规则说明 -->
      <div class="rules-section">
        <h3 class="section-title">
          <i class="el-icon-question"></i>
          拼团规则
        </h3>
        <div class="rules-content">
          <div class="rule-item">
            <div class="rule-number">1</div>
            <div class="rule-text">
              <h4>选择拼团</h4>
              <p>浏览并选择您感兴趣的绿证拼团活动</p>
            </div>
          </div>
          <div class="rule-item">
            <div class="rule-number">2</div>
            <div class="rule-text">
              <h4>参与拼团</h4>
              <p>点击"立即参团"按钮，支付拼团价格</p>
            </div>
          </div>
          <div class="rule-item">
            <div class="rule-number">3</div>
            <div class="rule-text">
              <h4>邀请好友</h4>
              <p>分享拼团链接给好友，邀请一起参与</p>
            </div>
          </div>
          <div class="rule-item">
            <div class="rule-number">4</div>
            <div class="rule-text">
              <h4>拼团成功</h4>
              <p>达到目标人数后，拼团成功，获得绿证</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <front-footer></front-footer>

    <!-- 绿证团购详情对话框 -->
    <el-dialog
      :title="selectedGroup ? selectedGroup.name + ' - 详情' : '绿证详情'"
      v-model="detailDialogVisible"
      width="900px"
      custom-class="detail-dialog"
      :close-on-click-modal="false"
      top="5vh"
    >
      <div v-if="selectedGroup" class="detail-dialog-content">
        <!-- 顶部信息区 -->
        <div class="detail-header">
          <div class="detail-image-section">
            <img :src="selectedGroup.image" :alt="selectedGroup.name" @error="handleImageError($event, selectedGroup)">
            <div class="image-tags">
              <span v-if="selectedGroup.isEndingSoon" class="detail-tag ending">即将截止</span>
              <span v-if="selectedGroup.current >= selectedGroup.target" class="detail-tag full">已满员</span>
              <span v-else-if="selectedGroup.discount" class="detail-tag discount">{{ selectedGroup.discount }}折</span>
            </div>
          </div>
          <div class="detail-basic-info">
            <h3 class="detail-title">{{ selectedGroup.name }}</h3>
            <p class="detail-desc">{{ selectedGroup.description }}</p>
            
            <!-- 价格信息 -->
            <div class="detail-price-section">
              <div class="detail-current-price">
                <span class="price-symbol">¥</span>
                <span class="price-value">{{ selectedGroup.groupPrice }}</span>
                <span class="price-unit">/张</span>
              </div>
              <div class="detail-original-price">
                原价 <span class="original-value">¥{{ selectedGroup.originalPrice }}/张</span>
                <span class="save-amount">省 ¥{{ (selectedGroup.originalPrice - selectedGroup.groupPrice).toFixed(2) }}</span>
              </div>
            </div>

            <!-- 统计信息 -->
            <div class="detail-stats">
              <div class="stat-item">
                <i class="el-icon-s-flag"></i>
                <span class="stat-label">目标人数</span>
                <span class="stat-value">{{ selectedGroup.target }}人</span>
              </div>
              <div class="stat-item">
                <i class="el-icon-s-custom"></i>
                <span class="stat-label">已参与</span>
                <span class="stat-value">{{ selectedGroup.current }}人</span>
              </div>
              <div class="stat-item">
                <i class="el-icon-time"></i>
                <span class="stat-label">剩余时间</span>
                <span class="stat-value" :class="{ 'ending-soon': selectedGroup.isEndingSoon }">{{ formatTimeLeft(selectedGroup.endTime) }}</span>
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="detail-actions">
              <el-button 
                type="primary" 
                size="large"
                class="detail-join-btn"
                :disabled="selectedGroup.current >= selectedGroup.target || selectedGroup.status === 'ended'"
                @click="handleJoinFromDetail"
              >
                <i class="el-icon-s-flag"></i>
                {{ selectedGroup.current >= selectedGroup.target ? '已满员' : (selectedGroup.status === 'ended' ? '已结束' : '立即参团') }}
              </el-button>
              <el-button 
                type="default" 
                size="large"
                class="detail-share-btn"
                @click="handleShare(selectedGroup)"
              >
                <i class="el-icon-share"></i>
                分享团购
              </el-button>
            </div>
          </div>
        </div>

        <!-- 进度信息 -->
        <div class="detail-progress-section">
          <div class="progress-header">
            <h4><i class="el-icon-s-data"></i> 团购进度</h4>
            <span class="progress-percent">{{ Math.round(selectedGroup.current / selectedGroup.target * 100) }}%</span>
          </div>
          <el-progress 
            :percentage="Math.round(selectedGroup.current / selectedGroup.target * 100)" 
            :color="progressColors"
            :stroke-width="16"
            :show-text="false"
          ></el-progress>
          <div class="progress-detail">
            <span>已拼 {{ selectedGroup.current }} 人</span>
            <span v-if="selectedGroup.current < selectedGroup.target" class="need-more">还差 {{ selectedGroup.target - selectedGroup.current }} 人成团</span>
            <span v-else class="success-text">拼团成功</span>
          </div>
        </div>

        <!-- 参与者列表 -->
        <div class="detail-participants-section">
          <h4><i class="el-icon-s-custom"></i> 参与用户 ({{ selectedGroup.participants.length }}人)</h4>
          <div class="participants-list">
            <div 
              v-for="(user, index) in selectedGroup.participants" 
              :key="index"
              class="participant-item"
            >
              <img :src="user.avatar" :alt="user.name" class="participant-avatar-large">
              <span class="participant-name">{{ user.name }}</span>
              <span v-if="index === 0" class="participant-role">团长</span>
            </div>
          </div>
        </div>

        <!-- 绿证项目信息 -->
        <div class="detail-section">
          <h4 class="section-title"><i class="el-icon-office-building"></i> 项目信息</h4>
          <div class="info-grid">
            <div class="info-item">
              <span class="info-label">项目编号</span>
              <span class="info-value">{{ selectedGroup.projectCode || 'GEC-' + String(selectedGroup.id).padStart(8, '0') }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">发电类型</span>
              <span class="info-value">
                <el-tag size="small" type="success">{{ selectedGroup.categoryName || '风力发电' }}</el-tag>
              </span>
            </div>
            <div class="info-item">
              <span class="info-label">项目地点</span>
              <span class="info-value">{{ selectedGroup.placeOfOrigin || '中国' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">发电企业</span>
              <span class="info-value">{{ selectedGroup.company || '国家能源集团' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">并网时间</span>
              <span class="info-value">{{ selectedGroup.gridDate || '2023年' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">装机容量</span>
              <span class="info-value">{{ selectedGroup.capacity || '50MW' }}</span>
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
                <span class="benefit-value">{{ selectedGroup.co2Reduction || '8,520' }} 吨</span>
                <span class="benefit-label">减少CO₂排放</span>
              </div>
            </div>
            <div class="benefit-card">
              <div class="benefit-icon tree">
                <i class="el-icon-s-custom"></i>
              </div>
              <div class="benefit-info">
                <span class="benefit-value">{{ selectedGroup.treeEquivalent || '46.5' }} 万棵</span>
                <span class="benefit-label">相当于植树</span>
              </div>
            </div>
            <div class="benefit-card">
              <div class="benefit-icon coal">
                <i class="el-icon-box"></i>
              </div>
              <div class="benefit-info">
                <span class="benefit-value">{{ selectedGroup.coalSaving || '3,420' }} 吨</span>
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
              <span class="cert-value">{{ selectedGroup.certificateCode || 'GEC-' + String(selectedGroup.id).padStart(8, '0') }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">签发日期</span>
              <span class="cert-value">{{ selectedGroup.issueDate || '2024年' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">有效期至</span>
              <span class="cert-value">{{ selectedGroup.validDate || '长期有效' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">发电时段</span>
              <span class="cert-value">{{ selectedGroup.generationPeriod || '2024年1月-12月' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">认证机构</span>
              <span class="cert-value">{{ selectedGroup.issuer || '国家可再生能源信息管理中心' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">绿证类型</span>
              <span class="cert-value">{{ selectedGroup.certificateType || '绿色电力证书' }}</span>
            </div>
            <div class="cert-item">
              <span class="cert-label">年发电量</span>
              <span class="cert-value">{{ selectedGroup.generation || '45,600' }} {{ selectedGroup.unit || 'MWh' }}</span>
            </div>
          </div>
        </div>

        <!-- 团购详情信息 -->
        <div class="detail-info-section">
          <h4><i class="el-icon-info"></i> 团购详情</h4>
          <div class="info-grid">
            <div class="info-item">
              <span class="info-label">团购编号</span>
              <span class="info-value">GB-{{ String(selectedGroup.id).padStart(6, '0') }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">绿证类型</span>
              <span class="info-value">{{ selectedGroup.categoryName || '风电绿证' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">发行地区</span>
              <span class="info-value">{{ selectedGroup.placeOfOrigin || selectedGroup.name.split('绿证')[0] }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">有效期</span>
              <span class="info-value">{{ selectedGroup.validDate || '永久有效' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">使用范围</span>
              <span class="info-value">全国通用</span>
            </div>
            <div class="info-item">
              <span class="info-label">交付方式</span>
              <span class="info-value">电子凭证</span>
            </div>
          </div>
        </div>

        <!-- 团购须知 -->
        <div class="detail-rules-section">
          <h4><i class="el-icon-warning"></i> 购买须知</h4>
          <ul class="rules-list">
            <li><i class="el-icon-check"></i> 参团后不可取消订单，请确认后再参与</li>
            <li><i class="el-icon-check"></i> 团购成功后，绿证将在24小时内发放至您的账户</li>
            <li><i class="el-icon-check"></i> 如团购失败，已支付金额将原路退回</li>
            <li><i class="el-icon-check"></i> 每个账号限购10张绿证</li>
            <li><i class="el-icon-check"></i> 绿证购买后可随时查看、下载电子证书</li>
            <li><i class="el-icon-check"></i> 每张绿证对应1000千瓦时可再生能源电量</li>
            <li><i class="el-icon-check"></i> 如有疑问，请联系客服：400-888-8888</li>
          </ul>
        </div>
      </div>
    </el-dialog>

    <!-- 分享对话框 -->
    <el-dialog
      title="分享团购"
      v-model="shareDialogVisible"
      width="500px"
      custom-class="share-dialog"
      :close-on-click-modal="true"
    >
      <div v-if="shareGroup" class="share-dialog-content">
        <!-- 分享预览卡片 -->
        <div class="share-preview-card">
          <div class="share-preview-image">
            <img :src="shareGroup.image" :alt="shareGroup.name" @error="handleImageError($event, shareGroup)">
          </div>
          <div class="share-preview-info">
            <h4 class="share-preview-title">{{ shareGroup.name }}</h4>
            <p class="share-preview-price">
              <span class="share-price">¥{{ shareGroup.groupPrice }}</span>
              <span class="share-original">¥{{ shareGroup.originalPrice }}</span>
            </p>
            <p class="share-preview-desc">
              <i class="el-icon-s-custom"></i> {{ shareGroup.current }}/{{ shareGroup.target }}人
              <span class="share-discount" v-if="shareGroup.discount">{{ shareGroup.discount }}折</span>
            </p>
          </div>
        </div>

        <!-- 分享链接 -->
        <div class="share-link-section">
          <h5><i class="el-icon-link"></i> 分享链接</h5>
          <div class="share-link-box">
            <el-input 
              v-model="shareUrl" 
              readonly 
              class="share-link-input"
            ></el-input>
            <el-button 
              type="primary" 
              class="copy-btn"
              @click="copyShareLink"
            >
              <i class="el-icon-document-copy"></i> 复制
            </el-button>
          </div>
        </div>

        <!-- 分享海报 -->
        <div class="share-poster-section">
          <h5><i class="el-icon-picture"></i> 分享海报</h5>
          <div class="poster-preview" ref="posterRef">
            <div class="poster-content">
              <div class="poster-header">
                <img :src="shareGroup.image" class="poster-bg">
                <div class="poster-overlay">
                  <span class="poster-tag" v-if="shareGroup.discount">{{ shareGroup.discount }}折</span>
                </div>
              </div>
              <div class="poster-body">
                <h3 class="poster-title">{{ shareGroup.name }}</h3>
                <p class="poster-desc">{{ shareGroup.description }}</p>
                <div class="poster-price">
                  <span class="poster-current">¥{{ shareGroup.groupPrice }}</span>
                  <span class="poster-original">¥{{ shareGroup.originalPrice }}</span>
                </div>
                <div class="poster-progress">
                  <div class="poster-progress-bar">
                    <div class="poster-progress-fill" :style="{ width: (shareGroup.current / shareGroup.target * 100) + '%' }"></div>
                  </div>
                  <span class="poster-progress-text">已拼{{ shareGroup.current }}人</span>
                </div>
              </div>
              <div class="poster-footer">
                <div class="poster-qrcode">
                  <div class="qrcode-placeholder">
                    <i class="el-icon-full-screen"></i>
                    <span>扫码参团</span>
                  </div>
                </div>
                <p class="poster-tip">长按识别二维码，立即参与团购</p>
              </div>
            </div>
          </div>
          <el-button 
            type="success" 
            class="download-poster-btn"
            @click="downloadPoster"
          >
            <i class="el-icon-download"></i> 下载分享海报
          </el-button>
        </div>

        <!-- 社交分享 -->
        <div class="social-share-section">
          <h5><i class="el-icon-share"></i> 分享到</h5>
          <div class="social-share-buttons">
            <div class="social-btn wechat" @click="shareToWechat">
              <i class="el-icon-chat-dot-round"></i>
              <span>微信</span>
            </div>
            <div class="social-btn weibo" @click="shareToWeibo">
              <i class="el-icon-s-promotion"></i>
              <span>微博</span>
            </div>
            <div class="social-btn qq" @click="shareToQQ">
              <i class="el-icon-chat-square"></i>
              <span>QQ</span>
            </div>
            <div class="social-btn email" @click="shareToEmail">
              <i class="el-icon-message"></i>
              <span>邮件</span>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 参团对话框 -->
    <el-dialog
      title="参与拼团"
      v-model="joinDialogVisible"
      width="500px"
      custom-class="join-dialog"
    >
      <div v-if="selectedGroup" class="join-dialog-content">
        <div class="dialog-product">
          <img :src="selectedGroup.image" :alt="selectedGroup.name" @error="handleImageError($event, selectedGroup)">
          <div class="dialog-product-info">
            <h4>{{ selectedGroup.name }}</h4>
            <p class="dialog-price">
              <span class="price">¥{{ selectedGroup.groupPrice }}</span>
              <span class="original">¥{{ selectedGroup.originalPrice }}</span>
            </p>
          </div>
        </div>
        <div class="dialog-progress">
          <p>当前进度：{{ selectedGroup.current }}/{{ selectedGroup.target }} 人</p>
          <el-progress 
            :percentage="Math.round(selectedGroup.current / selectedGroup.target * 100)" 
            :color="progressColors"
          ></el-progress>
        </div>
        <div class="dialog-form">
          <el-form :model="joinForm" label-width="80px">
            <el-form-item label="购买数量">
              <el-input-number 
                v-model="joinForm.quantity" 
                :min="1" 
                :max="10"
                @change="calculateTotal"
              ></el-input-number>
            </el-form-item>
            <el-form-item label="总计金额">
              <span class="total-price">¥{{ totalPrice }}</span>
            </el-form-item>
            <el-form-item label="联系电话">
              <el-input v-model="joinForm.phone" placeholder="请输入联系电话"></el-input>
            </el-form-item>
            <el-form-item label="备注">
              <el-input 
                v-model="joinForm.remark" 
                type="textarea" 
                :rows="2"
                placeholder="请输入备注信息（选填）"
              ></el-input>
            </el-form-item>
          </el-form>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
        <el-button @click="joinDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmJoin" :loading="submitting">
          确认参团
        </el-button>
      </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import img0 from '@/assets/imgs/1.jpg'
import img1 from '@/assets/imgs/2.jpg'
import img2 from '@/assets/imgs/3.jpg'
import img3 from '@/assets/imgs/4.jpg'
import img4 from '@/assets/imgs/img1.png'
import img5 from '@/assets/imgs/img2.png'
import img6 from '@/assets/imgs/img3.jpg'
import FrontHeader from '@/components/front/FrontHeader.vue'
import FrontFooter from '@/components/front/FrontFooter.vue'
import Request from '@/utils/request'

export default {
  name: 'GroupBuying',
  components: {
    FrontHeader,
    FrontFooter
  },
  data() {
    return {
      loading: false,
      currentTab: 'all',
      currentPage: 1,
      pageSize: 8,
      total: 0,
      stats: {
        ongoing: 12,
        success: 156,
        participants: 2890,
        savedAmount: 45.8
      },
      groups: [],
      joinDialogVisible: false,
      selectedGroup: null,
      submitting: false,
      joinForm: {
        quantity: 1,
        phone: '',
        remark: ''
      },
      detailDialogVisible: false,
      shareDialogVisible: false,
      shareGroup: null,
      progressColors: [
        { color: '#f56c6c', percentage: 20 },
        { color: '#e6a23c', percentage: 40 },
        { color: '#5cb87a', percentage: 60 },
        { color: '#1989fa', percentage: 80 },
        { color: '#67C23A', percentage: 100 }
      ]
    }
  },
  computed: {
    filteredGroups() {
      let result = this.groups
      if (this.currentTab === 'ongoing') {
        result = result.filter(g => g.status === 'ongoing')
      } else if (this.currentTab === 'success') {
        result = result.filter(g => g.current >= g.target * 0.8 && g.current < g.target)
      }
      return result
    },
    totalPrice() {
      if (!this.selectedGroup) return 0
      return (this.selectedGroup.groupPrice * this.joinForm.quantity).toFixed(2)
    }
  },
  methods: {
    // 获取拼团列表
    // 获取拼团列表（真实接口）
    async getGroups() {
      this.loading = true
      try {
        const res = await Request.get('/group-buying/page', {
          params: { currentPage: this.currentPage, size: this.pageSize }
        })
        if (res.code === '0' && res.data && res.data.records) {
          this.groups = res.data.records.map(g => ({
            id: g.id,
            name: g.name,
            description: g.description,
            image: g.imageUrl || (g.product && g.product.imageUrl) || '',
            originalPrice: parseFloat(g.originalPrice),
            groupPrice: parseFloat(g.groupPrice),
            discount: Math.round((parseFloat(g.groupPrice) / parseFloat(g.originalPrice)) * 10),
            target: g.targetCount,
            current: g.currentCount,
            status: g.status === 1 ? 'success' : 'ongoing',
            endTime: g.endTime ? new Date(g.endTime) : null,
            isEndingSoon: g.endTime ? (new Date(g.endTime) - new Date()) < 3 * 24 * 60 * 60 * 1000 : false,
            productId: g.productId,
            certificateCode: g.product ? `GEC-${String(g.productId).padStart(6, '0')}` : '',
            categoryName: g.product && g.product.category ? g.product.category.name : '',
            placeOfOrigin: g.product ? g.product.placeOfOrigin : '',
            company: g.product && g.product.merchant ? g.product.merchant.name : ''
          }))
          this.total = res.data.total
        } else {
          this.groups = []
          this.total = 0
        }
      } catch (error) {
        console.error('获取拼团列表失败:', error)
        this.$message.error('获取拼团列表失败')
      } finally {
        this.loading = false
      }
    },

    // 格式化剩余时间
    formatTimeLeft(endTime) {
      const now = new Date()
      const diff = endTime - now
      if (diff <= 0) return '已结束'
      
      const days = Math.floor(diff / (1000 * 60 * 60 * 24))
      const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
      
      if (days > 0) {
        return `${days}天${hours}小时`
      }
      return `${hours}小时`
    },
    // 查看详情
    handleViewDetail(group) {
      this.selectedGroup = group
      this.detailDialogVisible = true
    },
    // 从详情页参团
    handleJoinFromDetail() {
      this.detailDialogVisible = false
      setTimeout(() => {
        this.handleJoin(this.selectedGroup)
      }, 300)
    },
    // 处理参团
    handleJoin(group) {
      const userInfo = localStorage.getItem('frontUser')
      if (!userInfo) {
        this.$message.warning('请先登录')
        this.$router.push('/login')
        return
      }
      this.selectedGroup = group
      this.joinForm.quantity = 1
      this.joinForm.phone = ''
      this.joinForm.remark = ''
      this.joinDialogVisible = true
    },
    // 计算总价
    calculateTotal() {
      // 计算逻辑在 computed 中
    },
    // 确认参团（真实接口）
    async confirmJoin() {
      if (!this.joinForm.phone) {
        this.$message.warning('请输入联系电话')
        return
      }

      this.submitting = true
      try {
        const res = await Request.post(`/group-buying/${this.selectedGroup.id}/join`, {
          quantity: this.joinForm.quantity,
          phone: this.joinForm.phone,
          remark: this.joinForm.remark
        })
        if (res.code === '0') {
          this.$message.success('参团成功！')
          this.joinDialogVisible = false
          this.getGroups() // 刷新列表
        } else {
          this.$message.error(res.msg || '参团失败，请重试')
        }
      } catch (error) {
        this.$message.error('参团失败，请重试')
      } finally {
        this.submitting = false
      }
    },
    // 处理分享
    handleShare(group) {
      this.shareGroup = group
      this.shareDialogVisible = true
    },
    // 计算分享链接
    shareUrl() {
      if (!this.shareGroup) return ''
      return `${window.location.origin}/group-buying?id=${this.shareGroup.id}`
    },
    // 复制分享链接
    copyShareLink() {
      const url = this.shareUrl()
      if (!url) return
      
      // 创建临时文本区域
      const textarea = document.createElement('textarea')
      textarea.value = url
      textarea.style.position = 'fixed'
      textarea.style.opacity = '0'
      document.body.appendChild(textarea)
      textarea.select()
      
      try {
        document.execCommand('copy')
        this.$message.success('链接已复制到剪贴板')
      } catch (err) {
        this.$message.error('复制失败，请手动复制')
      }
      document.body.removeChild(textarea)
    },
    // 下载分享海报
    downloadPoster() {
      this.$message.info('海报生成中，请稍候...')
      // 模拟海报生成
      setTimeout(() => {
        // 创建一个canvas来生成海报
        const canvas = document.createElement('canvas')
        canvas.width = 375
        canvas.height = 600
        const ctx = canvas.getContext('2d')
        
        // 绘制背景
        ctx.fillStyle = '#ffffff'
        ctx.fillRect(0, 0, 375, 600)
        
        // 绘制标题背景
        ctx.fillStyle = '#67C23A'
        ctx.fillRect(0, 0, 375, 60)
        
        // 绘制标题文字
        ctx.fillStyle = '#ffffff'
        ctx.font = 'bold 20px Arial'
        ctx.textAlign = 'center'
        ctx.fillText('绿证拼团', 187.5, 38)
        
        // 绘制商品名称
        ctx.fillStyle = '#2c3e50'
        ctx.font = 'bold 18px Arial'
        ctx.textAlign = 'left'
        const name = this.shareGroup.name
        ctx.fillText(name.length > 15 ? name.substring(0, 15) + '...' : name, 20, 100)
        
        // 绘制价格
        ctx.fillStyle = '#f56c6c'
        ctx.font = 'bold 32px Arial'
        ctx.fillText('¥' + this.shareGroup.groupPrice, 20, 150)
        
        ctx.fillStyle = '#909399'
        ctx.font = '14px Arial'
        ctx.fillText('原价 ¥' + this.shareGroup.originalPrice, 120, 150)
        
        // 绘制进度
        ctx.fillStyle = '#606266'
        ctx.font = '14px Arial'
        ctx.fillText('已拼 ' + this.shareGroup.current + '/' + this.shareGroup.target + ' 人', 20, 190)
        
        // 绘制进度条背景
        ctx.fillStyle = '#ebeef5'
        ctx.fillRect(20, 200, 335, 12)
        
        // 绘制进度条
        ctx.fillStyle = '#67C23A'
        const progressWidth = (this.shareGroup.current / this.shareGroup.target) * 335
        ctx.fillRect(20, 200, progressWidth, 12)
        
        // 绘制二维码区域
        ctx.fillStyle = '#f8faf5'
        ctx.fillRect(87.5, 280, 200, 200)
        
        ctx.fillStyle = '#67C23A'
        ctx.font = 'bold 16px Arial'
        ctx.textAlign = 'center'
        ctx.fillText('扫码立即参团', 187.5, 380)
        
        // 绘制底部文字
        ctx.fillStyle = '#909399'
        ctx.font = '12px Arial'
        ctx.fillText('长按识别二维码，享受优惠价格', 187.5, 520)
        
        // 下载海报
        const link = document.createElement('a')
        link.download = `绿证拼团-${this.shareGroup.name}.png`
        link.href = canvas.toDataURL('image/png')
        link.click()
        
        this.$message.success('海报已生成并下载')
      }, 500)
    },
    // 分享到微信
    shareToWechat() {
      this.$message.info('请使用微信扫一扫功能，扫描生成的海报二维码')
      this.downloadPoster()
    },
    // 分享到微博
    shareToWeibo() {
      const url = encodeURIComponent(this.shareUrl())
      const title = encodeURIComponent(`快来参加${this.shareGroup.name}，拼团价仅需¥${this.shareGroup.groupPrice}！`)
      const pic = encodeURIComponent(this.shareGroup.image)
      window.open(`https://service.weibo.com/share/share.php?url=${url}&title=${title}&pic=${pic}`, '_blank')
    },
    // 分享到QQ
    shareToQQ() {
      const url = encodeURIComponent(this.shareUrl())
      const title = encodeURIComponent(this.shareGroup.name)
      const desc = encodeURIComponent(`${this.shareGroup.description}，拼团价仅需¥${this.shareGroup.groupPrice}！`)
      const pics = encodeURIComponent(this.shareGroup.image)
      window.open(`https://connect.qq.com/widget/shareqq/index.html?url=${url}&title=${title}&desc=${desc}&pics=${pics}`, '_blank')
    },
    // 分享到邮件
    shareToEmail() {
      const subject = encodeURIComponent(`推荐：${this.shareGroup.name}`)
      const body = encodeURIComponent(`
您好！

我想推荐一个超值的绿证拼团活动给您：

【${this.shareGroup.name}】
拼团价：¥${this.shareGroup.groupPrice}（原价¥${this.shareGroup.originalPrice}）
已拼：${this.shareGroup.current}/${this.shareGroup.target}人

${this.shareGroup.description}

点击链接立即参与：${this.shareUrl()}

期待您的参与！
      `)
      window.location.href = `mailto:?subject=${subject}&body=${body}`
    },
    // 分页
    handlePageChange(page) {
      this.currentPage = page
      this.getGroups()
    },
    // 图片加载失败处理
    handleImageError(event, group) {
      // 使用本地默认图片替换
      const defaultImages = [
        img0,
        img1,
        img2,
        img3,
        img4,
        img5,
        img6
      ]
      // 根据group id选择一个默认图片
      const index = (group.id - 1) % defaultImages.length
      event.target.src = defaultImages[index]
    }
  },
  created() {
    this.getGroups()
  }
}
</script>

<style scoped>
.group-buying-page {
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

/* 统计卡片 */
.stats-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
}

.stat-icon.hot {
  background: linear-gradient(135deg, #f56c6c, #f78989);
}

.stat-icon.success {
  background: linear-gradient(135deg, #409EFF, #66b1ff);
}

.stat-icon.warning {
  background: linear-gradient(135deg, #e6a23c, #ebb563);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 6px;
}

/* 拼团列表 */
.group-list-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
  margin-bottom: 30px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
}

.section-title i {
  color: #67C23A;
  font-size: 22px;
}

.filter-tabs {
  display: flex;
  gap: 8px;
}

.tab-item {
  padding: 8px 20px;
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
}

/* 拼团卡片 */
.group-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;
}

.group-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
  position: relative;
  border: 2px solid transparent;
}

.group-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
}

.group-card.ending-soon {
  border-color: #e6a23c;
}

.group-card.full {
  border-color: #67C23A;
}

.card-tags {
  position: absolute;
  top: 12px;
  left: 12px;
  z-index: 10;
  display: flex;
  gap: 8px;
}

.tag {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.tag.ending {
  background: #fdf6ec;
  color: #e6a23c;
}

.tag.full {
  background: #f0f9eb;
  color: #67C23A;
}

.tag.discount {
  background: linear-gradient(135deg, #f56c6c, #f78989);
  color: white;
}

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

.group-card:hover .product-image img {
  transform: scale(1.05);
}

.image-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.group-card:hover .image-overlay {
  opacity: 1;
}

.view-detail {
  padding: 10px 24px;
  background: white;
  color: #67C23A;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
}

.product-info {
  padding: 20px;
}

.product-name {
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 8px;
  line-height: 1.4;
}

.product-desc {
  font-size: 14px;
  color: #909399;
  margin: 0 0 16px;
  line-height: 1.5;
}

/* 价格信息 */
.price-info {
  margin-bottom: 16px;
}

.current-price {
  display: flex;
  align-items: baseline;
  gap: 6px;
}

.price-label {
  font-size: 13px;
  color: #f56c6c;
  font-weight: 500;
}

.price-value {
  font-size: 28px;
  font-weight: 700;
  color: #f56c6c;
  line-height: 1;
}

.unit {
  font-size: 14px;
  color: #909399;
}

.original-price {
  font-size: 13px;
  color: #c0c4cc;
  text-decoration: line-through;
  margin-top: 4px;
}

/* 进度条 */
.progress-section {
  margin-bottom: 16px;
}

.progress-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 13px;
}

.progress-text {
  color: #67C23A;
  font-weight: 500;
}

.remain-text {
  color: #f56c6c;
  font-weight: 500;
}

.progress-bar {
  height: 8px;
  background: #ebeef5;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 10px;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #67C23A, #85ce61);
  border-radius: 4px;
  transition: width 0.5s ease;
}

.time-left {
  font-size: 13px;
  color: #e6a23c;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 参与者 */
.participants {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.avatar-list {
  display: flex;
  align-items: center;
}

.participant-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid white;
  margin-left: -8px;
  object-fit: cover;
}

.participant-avatar:first-child {
  margin-left: 0;
}

.more-avatars {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #e4e7ed;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: #606266;
  border: 2px solid white;
  margin-left: -8px;
}

.participant-count {
  font-size: 13px;
  color: #909399;
}

/* 操作按钮 */
.action-section {
  display: flex;
  gap: 12px;
}

.join-btn {
  flex: 1;
  height: 44px;
  border-radius: 22px;
  font-size: 15px;
  font-weight: 500;
  background: linear-gradient(135deg, #f56c6c, #f78989);
  border: none;
}

.join-btn:hover {
  background: linear-gradient(135deg, #f78989, #fab6b6);
}

.join-btn:disabled {
  background: #c0c4cc;
  cursor: not-allowed;
}

.share-btn {
  color: #909399;
}

.share-btn:hover {
  color: #67C23A;
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

/* 规则说明 */
.rules-section {
  background: white;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
}

.rules-content {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
  margin-top: 24px;
}

.rule-item {
  display: flex;
  gap: 16px;
  padding: 20px;
  background: #f8faf5;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.rule-item:hover {
  background: rgba(103, 194, 58, 0.1);
  transform: translateY(-4px);
}

.rule-number {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, #67C23A, #85ce61);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
  flex-shrink: 0;
}

.rule-text h4 {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 6px;
}

.rule-text p {
  font-size: 13px;
  color: #909399;
  margin: 0;
  line-height: 1.5;
}

/* 详情对话框样式 */
.detail-dialog-content {
  padding: 0;
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

.detail-tag.ending {
  background: #fdf6ec;
  color: #e6a23c;
}

.detail-tag.full {
  background: #f0f9eb;
  color: #67C23A;
}

.detail-tag.discount {
  background: linear-gradient(135deg, #f56c6c, #f78989);
  color: white;
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
  background: linear-gradient(135deg, #fef5f5, #fff);
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
  color: #f56c6c;
  font-weight: 600;
}

.detail-current-price .price-value {
  font-size: 36px;
  color: #f56c6c;
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
  margin-bottom: 24px;
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

/* 操作按钮 */
.detail-actions {
  display: flex;
  gap: 16px;
  margin-top: auto;
}

.detail-join-btn {
  flex: 1;
  height: 48px;
  border-radius: 24px;
  font-size: 16px;
  font-weight: 500;
  background: linear-gradient(135deg, #f56c6c, #f78989);
  border: none;
}

.detail-join-btn:hover {
  background: linear-gradient(135deg, #f78989, #fab6b6);
}

.detail-join-btn:disabled {
  background: #c0c4cc;
}

.detail-share-btn {
  height: 48px;
  border-radius: 24px;
  font-size: 16px;
  padding: 0 30px;
}

/* 进度区域 */
.detail-progress-section {
  background: #f8faf5;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
}

.progress-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.progress-header h4 {
  margin: 0;
  font-size: 16px;
  color: #2c3e50;
  display: flex;
  align-items: center;
  gap: 8px;
}

.progress-header h4 i {
  color: #67C23A;
}

.progress-percent {
  font-size: 18px;
  font-weight: 700;
  color: #67C23A;
}

.progress-detail {
  display: flex;
  justify-content: space-between;
  margin-top: 12px;
  font-size: 14px;
}

.progress-detail .need-more {
  color: #f56c6c;
  font-weight: 500;
}

.progress-detail .success-text {
  color: #67C23A;
  font-weight: 500;
}

/* 参与者区域 */
.detail-participants-section {
  margin-bottom: 24px;
}

.detail-participants-section h4 {
  font-size: 16px;
  color: #2c3e50;
  margin: 0 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.detail-participants-section h4 i {
  color: #67C23A;
}

.participants-list {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.participant-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  position: relative;
}

.participant-avatar-large {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #ebeef5;
  transition: all 0.3s ease;
}

.participant-item:hover .participant-avatar-large {
  border-color: #67C23A;
  transform: scale(1.05);
}

.participant-name {
  font-size: 13px;
  color: #606266;
}

.participant-role {
  position: absolute;
  top: -4px;
  right: -4px;
  background: linear-gradient(135deg, #f56c6c, #f78989);
  color: white;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 10px;
  font-weight: 500;
}

/* 详情信息区域 */
.detail-info-section {
  background: #f8faf5;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 24px;
}

.detail-info-section h4 {
  font-size: 16px;
  color: #2c3e50;
  margin: 0 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.detail-info-section h4 i {
  color: #67C23A;
}

/* 通用详情区块样式 */
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

/* 团购须知 */
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

/* 分享对话框样式 */
.share-dialog-content {
  padding: 0;
}

/* 分享预览卡片 */
.share-preview-card {
  display: flex;
  gap: 16px;
  background: linear-gradient(135deg, #f8faf5, #fff);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 24px;
  border: 1px solid #e4e7ed;
}

.share-preview-image {
  flex: 0 0 100px;
  height: 100px;
  border-radius: 8px;
  overflow: hidden;
}

.share-preview-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.share-preview-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.share-preview-title {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 8px;
  line-height: 1.4;
}

.share-preview-price {
  margin: 0 0 8px;
}

.share-price {
  font-size: 20px;
  font-weight: 700;
  color: #f56c6c;
  margin-right: 8px;
}

.share-original {
  font-size: 13px;
  color: #c0c4cc;
  text-decoration: line-through;
}

.share-preview-desc {
  font-size: 13px;
  color: #606266;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.share-preview-desc i {
  color: #67C23A;
}

.share-discount {
  background: linear-gradient(135deg, #f56c6c, #f78989);
  color: white;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
}

/* 分享链接区域 */
.share-link-section {
  margin-bottom: 24px;
}

.share-link-section h5,
.share-poster-section h5,
.social-share-section h5 {
  font-size: 14px;
  color: #606266;
  margin: 0 0 12px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.share-link-section h5 i,
.share-poster-section h5 i,
.social-share-section h5 i {
  color: #67C23A;
}

.share-link-box {
  display: flex;
  gap: 12px;
}

.share-link-input {
  flex: 1;
}

.share-link-input :deep(.el-input__inner) {
  background: #f5f7fa;
  color: #606266;
}

.copy-btn {
  border-radius: 8px;
}

/* 分享海报区域 */
.share-poster-section {
  margin-bottom: 24px;
}

.poster-preview {
  background: #f5f7fa;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 16px;
  display: flex;
  justify-content: center;
}

.poster-content {
  width: 280px;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.poster-header {
  position: relative;
  height: 140px;
}

.poster-bg {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.poster-overlay {
  position: absolute;
  top: 12px;
  left: 12px;
}

.poster-tag {
  background: linear-gradient(135deg, #f56c6c, #f78989);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.poster-body {
  padding: 16px;
}

.poster-title {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 8px;
  line-height: 1.4;
}

.poster-desc {
  font-size: 12px;
  color: #909399;
  margin: 0 0 12px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.poster-price {
  margin-bottom: 12px;
}

.poster-current {
  font-size: 24px;
  font-weight: 700;
  color: #f56c6c;
  margin-right: 8px;
}

.poster-original {
  font-size: 13px;
  color: #c0c4cc;
  text-decoration: line-through;
}

.poster-progress {
  display: flex;
  align-items: center;
  gap: 8px;
}

.poster-progress-bar {
  flex: 1;
  height: 6px;
  background: #ebeef5;
  border-radius: 3px;
  overflow: hidden;
}

.poster-progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #67C23A, #85ce61);
  border-radius: 3px;
  transition: width 0.5s ease;
}

.poster-progress-text {
  font-size: 12px;
  color: #67C23A;
  font-weight: 500;
}

.poster-footer {
  background: #f8faf5;
  padding: 16px;
  text-align: center;
}

.poster-qrcode {
  width: 100px;
  height: 100px;
  margin: 0 auto 12px;
  background: white;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px dashed #dcdfe6;
}

.qrcode-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #909399;
}

.qrcode-placeholder i {
  font-size: 32px;
  margin-bottom: 4px;
  color: #67C23A;
}

.qrcode-placeholder span {
  font-size: 12px;
}

.poster-tip {
  font-size: 12px;
  color: #606266;
  margin: 0;
}

.download-poster-btn {
  width: 100%;
  height: 44px;
  border-radius: 22px;
  font-size: 15px;
}

/* 社交分享区域 */
.social-share-section {
  margin-bottom: 16px;
}

.social-share-buttons {
  display: flex;
  justify-content: space-around;
  gap: 16px;
}

.social-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 12px 20px;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.social-btn:hover {
  background: #f5f7fa;
  transform: translateY(-2px);
}

.social-btn i {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  transition: all 0.3s ease;
}

.social-btn.wechat i {
  background: linear-gradient(135deg, #07c160, #10b981);
}

.social-btn.weibo i {
  background: linear-gradient(135deg, #ff8200, #ff9500);
}

.social-btn.qq i {
  background: linear-gradient(135deg, #12b7f5, #00a1d6);
}

.social-btn.email i {
  background: linear-gradient(135deg, #67C23A, #85ce61);
}

.social-btn span {
  font-size: 13px;
  color: #606266;
}

/* 对话框样式 */
.join-dialog-content {
  padding: 10px 0;
}

.dialog-product {
  display: flex;
  gap: 16px;
  padding-bottom: 20px;
  border-bottom: 1px solid #ebeef5;
  margin-bottom: 20px;
}

.dialog-product img {
  width: 100px;
  height: 100px;
  border-radius: 8px;
  object-fit: cover;
}

.dialog-product-info h4 {
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 10px;
}

.dialog-price {
  display: flex;
  align-items: baseline;
  gap: 10px;
}

.dialog-price .price {
  font-size: 24px;
  font-weight: 700;
  color: #f56c6c;
}

.dialog-price .original {
  font-size: 14px;
  color: #c0c4cc;
  text-decoration: line-through;
}

.dialog-progress {
  margin-bottom: 20px;
}

.dialog-progress p {
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px;
}

.total-price {
  font-size: 24px;
  font-weight: 700;
  color: #f56c6c;
}

/* 响应式布局 */
@media (max-width: 1200px) {
  .stats-section {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .rules-content {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .detail-header {
    flex-direction: column;
  }
  
  .detail-image-section {
    flex: 1;
    width: 100%;
  }
  
  .info-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 992px) {
  .detail-dialog {
    width: 90% !important;
  }
  
  .detail-actions {
    flex-direction: column;
  }
  
  .detail-join-btn,
  .detail-share-btn {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 16px;
  }
  
  .page-header {
    padding: 20px;
  }
  
  .stats-section {
    grid-template-columns: 1fr;
  }
  
  .group-list {
    grid-template-columns: 1fr;
  }
  
  .section-header {
    flex-direction: column;
    gap: 16px;
    align-items: flex-start;
  }
  
  .rules-content {
    grid-template-columns: 1fr;
  }
  
  .detail-dialog {
    width: 95% !important;
  }
  
  .detail-header {
    gap: 20px;
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
  
  .info-grid {
    grid-template-columns: 1fr;
  }
  
  .participants-list {
    gap: 12px;
  }
  
  .participant-avatar-large {
    width: 48px;
    height: 48px;
  }
  
  .benefit-cards {
    grid-template-columns: 1fr;
  }
  
  .benefit-card {
    padding: 16px;
  }
}
</style>
