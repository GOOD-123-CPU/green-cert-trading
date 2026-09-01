package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.sql.Timestamp;

/**
 * 拼团参与记录
 */
@Data
@TableName("group_buying_member")
public class GroupBuyingMember {
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 拼团活动ID */
    private Long groupId;

    /** 参团用户ID */
    private Long userId;

    /** 购买数量 */
    private Integer quantity;

    /** 联系电话 */
    private String phone;

    /** 备注 */
    private String remark;

    private Timestamp createdAt;
}
