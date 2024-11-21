package com.qww.carrent.controller;

import cn.hutool.core.collection.CollectionUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.qww.carrent.common.BaseResponse;
import com.qww.carrent.common.ErrorCode;
import com.qww.carrent.common.ResultUtils;
import com.qww.carrent.exception.BusinessException;
import com.qww.carrent.model.entity.Car;
import com.qww.carrent.model.entity.CarStar;
import com.qww.carrent.model.entity.User;
import com.qww.carrent.model.request.CarStarRequest;
import com.qww.carrent.model.vo.CarVO;
import com.qww.carrent.service.CarService;
import com.qww.carrent.service.CarStarService;
import com.qww.carrent.service.UserService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/car_star")
public class CarStarController {

    @Resource
    private CarStarService carStarService;

    @Resource
    private UserService userService;

    @Resource
    private CarService carService;

    @PostMapping("/add")
    public BaseResponse<Boolean> addCarStar(@RequestBody CarStarRequest carStarRequest, HttpServletRequest request) {
        Integer carId = carStarRequest.getCarId();
        User loginUser = userService.getLoginUser(request);
        Integer userId = loginUser.getId();
        QueryWrapper<CarStar> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("carId", carId);
        queryWrapper.eq("userId", userId);
        long count = carStarService.count(queryWrapper);
        if (count > 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "您已收藏过了");
        }
        CarStar carStar = new CarStar();
        carStar.setCarId(carId);
        carStar.setUserId(userId);
        boolean b = carStarService.save(carStar);
        return ResultUtils.success(b);
    }

    @PostMapping("/delete")
    public BaseResponse<Boolean> deleteCarStar(@RequestBody CarStarRequest carStarRequest, HttpServletRequest request) {
        Integer carId = carStarRequest.getCarId();
        User loginUser = userService.getLoginUser(request);
        Integer userId = loginUser.getId();
        QueryWrapper<CarStar> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("carId", carId);
        queryWrapper.eq("userId", userId);
        long count = carStarService.count(queryWrapper);
        if (count < 1) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "您还未收藏");
        }
        boolean b = carStarService.remove(queryWrapper);
        return ResultUtils.success(b);
    }

    @GetMapping("/list/my")
    public BaseResponse<List<CarVO>> getMyCarStarList(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Integer userId = loginUser.getId();
        QueryWrapper<CarStar> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId);
        List<CarStar> carStarList = carStarService.list(queryWrapper);
        if (CollectionUtil.isEmpty(carStarList)) {
            return ResultUtils.success(null);
        }
        List<Integer> carIds = carStarList.stream().map(CarStar::getCarId).collect(Collectors.toList());
        List<Car> carList = carService.listByIds(carIds);
        List<CarVO> carVOList = carList.stream().map(car ->
                carService.getCarDetailById(car.getId())).collect(Collectors.toList());
        return ResultUtils.success(carVOList);
    }

    @PostMapping("/is")
    public BaseResponse<Boolean> isCarStar(@RequestBody CarStarRequest carStarRequest, HttpServletRequest request) {
        Integer carId = carStarRequest.getCarId();
        User loginUser = userService.getLoginUser(request);
        Integer userId = loginUser.getId();
        QueryWrapper<CarStar> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("carId", carId);
        queryWrapper.eq("userId", userId);
        long count = carStarService.count(queryWrapper);
        return ResultUtils.success(count > 0);
    }

}
