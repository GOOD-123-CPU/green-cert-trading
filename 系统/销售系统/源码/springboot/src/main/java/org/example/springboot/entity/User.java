package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.sql.Timestamp;
import java.util.List;

/**
 * 用户实体
 * 安全说明：password 字段仅用于登录校验与持久化，
 * 通过 @JsonIgnore 保证永不出现在任何 JSON 响应中。
 */
@Data
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;

    @JsonIgnore
    private String password;

    private String name;
    private String role;
    private String email;
    private Integer status;
    private String businessLicense;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    @TableField(exist = false)
    private List<Menu> menuList;

    @TableField(exist = false)
    private String token;

    /** 注册时提交的邮箱验证码（不持久化，仅注册流程使用） */
    @TableField(exist = false)
    @com.fasterxml.jackson.annotation.JsonProperty("emailCode")
    private String emailCode;
}
