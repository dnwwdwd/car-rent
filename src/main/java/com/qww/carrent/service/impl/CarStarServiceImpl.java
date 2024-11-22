package com.qww.carrent.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qww.carrent.model.entity.CarStar;
import com.qww.carrent.service.CarStarService;
import com.qww.carrent.mapper.CarStarMapper;
import org.springframework.stereotype.Service;

/**
* @author 何佳骏
* @description 针对表【car_star(汽车收藏表)】的数据库操作Service实现
* @createDate 2024-11-22 13:28:40
*/
@Service
public class CarStarServiceImpl extends ServiceImpl<CarStarMapper, CarStar>
    implements CarStarService{

}




