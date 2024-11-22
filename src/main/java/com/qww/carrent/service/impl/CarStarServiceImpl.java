package com.qww.carrent.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qww.carrent.model.entity.CarStar;
import com.qww.carrent.service.CarStarService;
import com.qww.carrent.mapper.CarStarMapper;
import org.springframework.stereotype.Service;


@Service
public class CarStarServiceImpl extends ServiceImpl<CarStarMapper, CarStar>
    implements CarStarService{

}




