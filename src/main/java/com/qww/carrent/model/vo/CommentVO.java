package com.qww.carrent.model.vo;

import com.qww.carrent.model.entity.User;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
public class CommentVO implements Serializable {

    /**
     * id
     */
    private Integer id;

    /**
     * 用户id
     */
    private Integer userId;

    /**
     * 资讯id
     */
    private Integer newsId;

    /**
     * 评论内容
     */
    private String content;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 更新时间
     */
    private Date updateTime;

    private UserVO userVO;

    private static final long serialVersionUID = 1L;

}
