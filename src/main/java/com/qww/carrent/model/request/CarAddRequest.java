package com.qww.carrent.model.request;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class CarAddRequest implements Serializable {
    /**
     * id
     */
    private Integer id;

    private Integer carCategoryId;

    /**
     * 车牌号
     */
    private String carNumber;

    /**
     * 行驶里程（单位：km）
     */
    private Integer mileage;

    /**
     * 成色
     */
    private String quality;

    /**
     * 图片链接
     */
    private String imgUrl;

    /**
     * 单日租车价格
     */
    private BigDecimal rentPrice;

    /**
     * 颜色
     */
    private String color;

    /**
     * 状态（0 - 未出租 1 - 已出租）
     */
    private Integer status;
}
