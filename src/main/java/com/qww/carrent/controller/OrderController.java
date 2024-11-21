package com.qww.carrent.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.qww.carrent.annotation.AuthCheck;
import com.qww.carrent.common.*;
import com.qww.carrent.constant.UserConstant;
import com.qww.carrent.exception.BusinessException;
import com.qww.carrent.model.entity.Car;
import com.qww.carrent.model.entity.CarCategory;
import com.qww.carrent.model.entity.Order;
import com.qww.carrent.model.entity.User;
import com.qww.carrent.model.request.OrderAddRequest;
import com.qww.carrent.model.vo.CarVO;
import com.qww.carrent.model.vo.OrderVO;
import com.qww.carrent.service.CarCategoryService;
import com.qww.carrent.service.CarService;
import com.qww.carrent.service.OrderService;
import com.qww.carrent.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/order")
public class OrderController {

    @Resource
    private UserService userService;

    @Resource
    private OrderService orderService;

    @Resource
    private CarService carService;

    @Resource
    private CarCategoryService carCategoryService;

    @PostMapping("/add")
    public BaseResponse<Boolean> addOrder(@RequestBody OrderAddRequest orderAddRequest,
                                          HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Integer userId =  orderAddRequest.getUserId() == null? loginUser.getId() : orderAddRequest.getUserId();
        loginUser = userService.getById(userId);
        if(StringUtils.isEmpty(loginUser.getAddress()) || StringUtils.isEmpty(loginUser.getPhone())) {
            User user = new User();
            BeanUtils.copyProperties(loginUser, user);
            user.setPhone(orderAddRequest.getPhone());
            user.setAddress(orderAddRequest.getAddress());
            userService.updateById(user);
        }
        Car car = carService.getById(orderAddRequest.getCarId());
        Date rentalEndDate = orderAddRequest.getRentalEndDate();
        Date rentalStartDate = orderAddRequest.getRentalStartDate();
        long diffInMillies = rentalEndDate.getTime() - rentalStartDate.getTime();
        long diffInDays = TimeUnit.MILLISECONDS.toDays(diffInMillies);
        Order order = new Order();
        order.setUserId(userId);
        order.setCarId(car.getId());
        order.setTotalPrice(car.getRentPrice().multiply(BigDecimal.valueOf(diffInDays + 1)));
        order.setRentalStartDate(rentalStartDate);
        order.setRentalEndDate(rentalEndDate);
        boolean b1 = orderService.save(order);
        car.setStatus(2);
        boolean b2 = carService.updateById(car);
        return ResultUtils.success(b1 && b2);
    }

    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @PostMapping("/update")
    public BaseResponse<Boolean> updateOrder(@RequestBody Order order) {
        boolean b = orderService.updateById(order);
        return ResultUtils.success(b);
    }

    @PostMapping("/list")
    public BaseResponse<Page<OrderVO>> listOrders(@RequestBody PageRequest pageRequest,
                                                  HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Integer userId = loginUser.getId();
        QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId);
        queryWrapper.orderByDesc("createTime"); // 确保排序规则
        Page<Order> orderPage = orderService.page(
                new Page<>(pageRequest.getCurrent(), pageRequest.getPageSize()), queryWrapper
        );
        // 转换 Order 到 OrderVO
        List<OrderVO> orderVOList = orderPage.getRecords().stream().map(order -> {
            OrderVO orderVO = new OrderVO();
            BeanUtils.copyProperties(order, orderVO);
            CarVO carVO = carService.getCarDetailById(order.getCarId());
            orderVO.setCarVO(carVO);
            orderVO.setUser(loginUser);
            orderVO.setRentalStartDate(new SimpleDateFormat("yyyy-MM-dd").format(order.getRentalStartDate()));
            orderVO.setRentalEndDate(new SimpleDateFormat("yyyy-MM-dd").format(order.getRentalEndDate()));
            return orderVO;
        }).collect(Collectors.toList());
        Page<OrderVO> resultPage = new Page<>(orderPage.getCurrent(), orderPage.getSize(), orderPage.getTotal());
        resultPage.setRecords(orderVOList);
        return ResultUtils.success(resultPage);
    }

    @GetMapping("/list")
    public BaseResponse<List<OrderVO>> listOrdersByGet() {
        List<Order> orderList = orderService.list();
        List<OrderVO> orderVOList = orderList.stream().map(order -> {
            OrderVO orderVO = new OrderVO();
            BeanUtils.copyProperties(order, orderVO);
            CarVO carVO = carService.getCarDetailById(order.getCarId());
            orderVO.setCarVO(carVO);
            orderVO.setUser(userService.getById(order.getUserId()));
            orderVO.setRentalStartDate(new SimpleDateFormat("yyyy-MM-dd").format(order.getRentalStartDate()));
            orderVO.setRentalEndDate(new SimpleDateFormat("yyyy-MM-dd").format(order.getRentalEndDate()));
            return orderVO;
        }).collect(Collectors.toList());
        return ResultUtils.success(orderVOList);
    }

    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @PostMapping("/delete")
    public BaseResponse<Boolean> deleteOrder(@RequestBody DeleteRequest deleteRequest) {
        Integer id = deleteRequest.getId();
        boolean b = orderService.removeById(id);
        return ResultUtils.success(b);
    }

    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @PostMapping("/allowRental")
    public BaseResponse<Boolean> allowRental(@RequestBody DeleteRequest deleteRequest) {
        Integer id = deleteRequest.getId();
        Order order = orderService.getById(id);
        // 订单状态改为正在进行
        order.setStatus(1);
        boolean b = orderService.updateById(order);
        Car car = carService.getById(order.getCarId());
        CarCategory carCategory = carCategoryService.getById(car.getCarCategoryId());
        // 同类别的汽车的库存减1
        carCategory.setStock(carCategory.getStock() - 1);
        carCategoryService.updateById(carCategory);
        // 汽车状态改为已出租
        car.setStatus(1);
        carService.updateById(car);
        return ResultUtils.success(b);
    }

    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @PostMapping("/endRental")
    public BaseResponse<Boolean> endRental(@RequestBody DeleteRequest deleteRequest) {
        Integer id = deleteRequest.getId();
        Order order = orderService.getById(id);
        // 订单状态改为待评价
        order.setStatus(2);
        boolean b = orderService.updateById(order);
        Car car = carService.getById(order.getCarId());
        CarCategory carCategory = carCategoryService.getById(car.getCarCategoryId());
        // 同类别的汽车的库存加1
        carCategory.setStock(carCategory.getStock() + 1);
        carCategoryService.updateById(carCategory);
        // 汽车状态改为未出租
        car.setStatus(0);
        carService.updateById(car);
        return ResultUtils.success(b);
    }

    @GetMapping("/detail/{id}")
    public BaseResponse<OrderVO> detail(@PathVariable Long id) {
        Order order = orderService.getById(id);
        OrderVO orderVO = new OrderVO();
        BeanUtils.copyProperties(order, orderVO);
        CarVO carVO = carService.getCarDetailById(order.getCarId());
        orderVO.setCarVO(carVO);
        orderVO.setRentalStartDate(new SimpleDateFormat("yyyy-MM-dd").format(order.getRentalStartDate()));
        orderVO.setRentalEndDate(new SimpleDateFormat("yyyy-MM-dd").format(order.getRentalEndDate()));
        orderVO.setUser(userService.getById(order.getUserId()));
        return ResultUtils.success(orderVO);
    }

    @PostMapping("/evaluate")
    public BaseResponse<Boolean> evaluate(@RequestBody Order order, HttpServletRequest request) {
        String evaluation = order.getEvaluation();
        Integer id = order.getId();
        if (StringUtils.isEmpty(evaluation) || id == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        if (orderService.getById(id) == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "订单不存在");
        }
        order.setStatus(3);
        boolean b = orderService.updateById(order);
        return ResultUtils.success(b);
    }

}
