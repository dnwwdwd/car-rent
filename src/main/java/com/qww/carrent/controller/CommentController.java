package com.qww.carrent.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.qww.carrent.common.BaseResponse;
import com.qww.carrent.common.DeleteRequest;
import com.qww.carrent.common.ErrorCode;
import com.qww.carrent.common.ResultUtils;
import com.qww.carrent.exception.BusinessException;
import com.qww.carrent.model.entity.Comment;
import com.qww.carrent.model.entity.News;
import com.qww.carrent.model.entity.User;
import com.qww.carrent.model.vo.CommentVO;
import com.qww.carrent.model.vo.UserVO;
import com.qww.carrent.service.CommentService;
import com.qww.carrent.service.NewsService;
import com.qww.carrent.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/comment")
public class CommentController {

    @Resource
    private UserService userService;

    @Resource
    private CommentService commentService;

    @Resource
    private NewsService newsService;


    @PostMapping("/add")
    public BaseResponse<Boolean> addComment(@RequestBody Comment comment, HttpServletRequest request) {
        Integer newsId = comment.getNewsId();
        News news = newsService.getById(newsId);
        User loginUser = userService.getLoginUser(request);
        if (StringUtils.isEmpty(comment.getContent())) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "评论不得为空");
        }
        if (news == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "资讯不存在");
        }
        Integer userId = loginUser.getId();
        comment.setUserId(userId);
        boolean b = commentService.save(comment);
        return ResultUtils.success(b);
    }

    @GetMapping("/list")
    public BaseResponse<List<CommentVO>> listComments(@RequestParam("newsId") Integer newsId) {
        News news = newsService.getById(newsId);
        if (news == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "资讯不存在");
        }
        QueryWrapper<Comment> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("newsId", newsId);
        List<Comment> commentList = commentService.list(queryWrapper);
        List<CommentVO> commentVOS = commentList.stream().map(c -> {
            CommentVO commentVO = new CommentVO();
            BeanUtils.copyProperties(c, commentVO);
            UserVO userVO = new UserVO();
            BeanUtils.copyProperties(userService.getById(c.getUserId()), userVO);
            commentVO.setUserVO(userVO);
            return commentVO;
        }).collect(Collectors.toList());
        return ResultUtils.success(commentVOS);
    }

    @GetMapping("/list/all")
    public BaseResponse<List<Comment>> listAllComments(HttpServletRequest request) {
        if (!userService.isAdmin(request)) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        List<Comment> commentList = commentService.list();
        return ResultUtils.success(commentList);
    }

    @PostMapping("/update")
    public BaseResponse<Boolean> updateComment(@RequestBody Comment comment, HttpServletRequest request) {
        if (!userService.isAdmin(request)) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean b = commentService.updateById(comment);
        return ResultUtils.success(b);
    }

    @PostMapping("/delete")
    public BaseResponse<Boolean> deleteComment(@RequestBody DeleteRequest deleteRequest,
                                               HttpServletRequest request) {
        if (!userService.isAdmin(request)) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        Integer id = deleteRequest.getId();
        boolean b = commentService.removeById(id);
        return ResultUtils.success(b);
    }

}
