package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * 绿证拼团活动
 */
@Data
@TableName("group_buying")
public class GroupBuying {
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 关联商品ID */
    private Long productId;

    /** 拼团名称 */
    private String name;

    /** 活动描述 */
    private String description;

    /** 活动图片URL */
    private String imageUrl;

    /** 原价 */
    private BigDecimal originalPrice;

    /** 拼团价 */
    private BigDecimal groupPrice;

    /** 成团所需人数 */
    private Integer targetCount;

    /** 当前已参团人数 */
    private Integer currentCount;

    /** 状态: 0-进行中 1-已成团 2-已结束 */
    private Integer status;

    /** 截止时间 */
    private Timestamp endTime;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    @TableField(exist = false)
    private Product product;
}
