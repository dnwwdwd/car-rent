package com.qww.carrent.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qww.carrent.model.entity.Comment;
import com.qww.carrent.service.CommentService;
import com.qww.carrent.mapper.CommentMapper;
import org.springframework.stereotype.Service;

/**
* @author 何佳骏
* @description 针对表【comment(资讯的评论表)】的数据库操作Service实现
* @createDate 2024-11-22 13:30:15
*/
@Service
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment>
    implements CommentService{

}




