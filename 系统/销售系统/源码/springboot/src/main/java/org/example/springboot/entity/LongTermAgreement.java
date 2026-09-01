package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 长期购买协议（企业绿证采购协议）
 */
@Data
@TableName("long_term_agreement")
public class LongTermAgreement {
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 协议模板ID（签约时关联的协议产品，可为空表示定制协议） */
    private Long templateId;

    /** 协议名称 */
    private String name;

    /** 协议类型: monthly-月度 quarterly-季度 yearly-年度 */
    private String type;

    /** 企业名称 */
    private String companyName;

    /** 统一社会信用代码 */
    private String creditCode;

    /** 联系人姓名 */
    private String contactName;

    /** 联系电话 */
    private String contactPhone;

    /** 联系邮箱 */
    private String contactEmail;

    /** 采购数量 */
    private Integer quantity;

    /** 协议单价 */
    private BigDecimal price;

    /** 预计开始日期 */
    private Timestamp startDate;

    /** 用途说明 */
    private String purpose;

    /** 备注 */
    private String remark;

    /** 状态: 0-待审核 1-已通过 2-已拒绝 3-已终止 */
    private Integer status;

    /** 提交用户ID */
    private Long userId;

    private Timestamp createdAt;

    private Timestamp updatedAt;
}
