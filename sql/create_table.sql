-- 创建库
create database if not exists car_rent;

-- 切换库
use car_rent;

create table car_rent.car
(
    id            int auto_increment comment 'id'
        primary key,
    carCategoryId int                                null comment '汽车分类id',
    carNumber     varchar(32)                        null comment '车牌号',
    mileage       int                                null comment '行驶里程（单位：km）',
    quality       varchar(32)                        null comment '成色',
    imgUrl        varchar(1024)                      null comment '图片链接',
    rentPrice     decimal(10, 2)                     null comment '单日租车价格',
    color         varchar(16)                        null comment '颜色',
    status        tinyint  default 0                 not null comment '状态（0 - 未出租 1 - 已出租 2 - 已被预约）',
    createTime    datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime    datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete      tinyint  default 0                 not null comment '是否删除'
)
    comment '汽车详情表';


create table car_rent.car_category
(
    id           int auto_increment comment 'id'
        primary key,
    brand        varchar(128)                       null comment '品牌',
    type         varchar(128)                       null comment '车型',
    imgUrl       varchar(256)                       null comment '图片',
    stock        int                                null comment '库存数量',
    averagePrice decimal(10, 2)                     null comment '平均价格',
    createTime   datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime   datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete     tinyint  default 0                 not null comment '是否删除（0 - 否 1 - 是）'
)
    comment '汽车表';


create table car_rent.car_star
(
    id         int auto_increment comment 'id'
        primary key,
    carId      int                                null comment '汽车id',
    userId     int                                null comment '用户id',
    createTime datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
)
    comment '汽车收藏表';



create table car_rent.comment
(
    id         int auto_increment comment 'id'
        primary key,
    userId     int                                null comment '用户id',
    newsId     int                                null comment '资讯id',
    content    varchar(512)                       null comment '评论内容',
    createTime datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
)
    comment '资讯的评论表';



create table car_rent.news
(
    id          int auto_increment comment 'id'
        primary key,
    title       varchar(512)                       null comment '资讯标题',
    userId      int                                null comment '用户id',
    description varchar(256)                       null comment '资讯描述',
    content     varchar(1280)                      null comment '资讯内容',
    imgUrl      varchar(256)                       null comment '图片地址',
    createTime  datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime  datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '修改时间',
    isDelete    tinyint  default 0                 not null comment '是否删除'
)
    comment '资讯表';



create table car_rent.`order`
(
    id              int auto_increment comment 'id'
        primary key,
    carId           int                                null comment '汽车详情id',
    userId          int                                null comment '用户id',
    totalPrice      decimal(10, 2)                     null comment '总价格',
    rentalStartDate datetime                           null comment '租赁开始时间',
    rentalEndDate   datetime                           null comment '租赁结束时间',
    status          tinyint  default 0                 not null comment '状态（0 - 等待商家交接 1 - 订单进行中 2 - 待评价 3 - 订单已结束）',
    evaluation      varchar(1280)                      null comment '评价',
    createTime      datetime default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime      datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete        tinyint  default 0                 not null comment '是否删除'
)
    comment '订单表';



create table car_rent.user
(
    id           int auto_increment comment 'id'
        primary key,
    userAccount  varchar(256)                                                                                                     not null comment '账号',
    userPassword varchar(512)                                                                                                     not null comment '密码',
    userName     varchar(256)                                                                                                     null comment '用户昵称',
    userAvatar   varchar(1024) default 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/image-20241119111441579.png' not null comment '用户头像',
    phone        varchar(32)                                                                                                      null comment '手机号码',
    userRole     varchar(256)  default 'user'                                                                                     not null comment '用户角色：user/admin/ban',
    address      varchar(64)                                                                                                      null comment '家庭住址',
    createTime   datetime      default CURRENT_TIMESTAMP                                                                          not null comment '创建时间',
    updateTime   datetime      default CURRENT_TIMESTAMP                                                                          not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete     tinyint       default 0                                                                                          not null comment '是否删除'
)
    comment '用户登录/注册/介绍表' collate = utf8mb4_unicode_ci;



INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (1, 1, '京A8888', 1000, '六成新', 'https://www.axfilm.com/public/842f1ad70a3c5bcb591c1e81d71128eb.jpg', 1000.00, '白色', 0, '2024-10-28 16:28:59', '2024-11-20 13:04:30', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (2, 1, '京B00000', 100, '八成新', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.ZNLoND95Na42tec9yPmyIQHaFj?rs=1&pid=ImgDetMain', 1200.00, '白色', 0, '2024-10-29 15:36:50', '2024-10-29 15:36:50', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (3, 3, '鄂A00001', 100, '九成新', 'https://n.sinaimg.cn/sinacn20/16/w1920h1296/20181108/7ea6-hnprhzw5248511.jpg', 2550.00, '蓝色', 2, '2024-11-05 10:13:41', '2024-11-05 10:15:13', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (4, 2, '苏A00000', 220, '九成新', 'https://img1.xcarimg.com/b63/s8742/20170324101225975627214431258.jpg', 2100.00, '黑色', 0, '2024-11-05 10:15:13', '2024-11-05 10:15:13', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (5, 4, '苏B00001', 90, '九九新', 'https://n.sinaimg.cn/sinakd20200618ac/600/w1920h1080/20200618/557a-ivffpcs1988820.jpg', 2000.00, '橙色', 0, '2024-11-05 10:17:44', '2024-11-05 10:17:44', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (6, 5, '沪A00001', 100, '九成新', 'https://s3.xchuxing.com/xchuxing/forum/201905/30/105008mk1cajc12cau2aaa.jpeg', 3000.00, '红色', 0, '2024-11-05 10:20:10', '2024-11-05 10:20:10', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (7, 6, '苏A11111', 100, '九成新', 'https://image.bitautoimg.com/appimage-630-w1/news/2023/12/30/516cafaeef0f45bd984a57fefd283bd5.jpg', 1000.00, '橄榄绿', 0, '2024-11-05 10:22:46', '2024-11-05 10:22:46', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (8, 2, 'A88888', 90, '九成新', 'https://img3.bitautoimg.com/autoalbum/files/20220826/41/202208267227150750804141771_3000x2000_w1.jpg', 1990.00, '白色', 0, '2024-11-22 15:29:06', '2024-11-22 15:29:06', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (9, 6, '京A101010', 1000, '很差', 'https://img2.bitautoimg.com/autoalbum/files/20231228/972/202312281835374965497214264_3000x2000_w1.jpg', 600.00, '蓝色', 0, '2024-11-23 17:03:14', '2024-11-23 17:03:14', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (10, 6, '鄂B00001', 100, '八成新', 'https://img.pcauto.com.cn/images/upload/upc/tx/auto5/2403/28/c21/414642038_1711595339638_1024.jpg', 1200.00, '紫色', 0, '2024-11-23 17:04:21', '2024-11-23 17:04:21', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (11, 6, '新A00001', 80, '九成新', 'https://img2.bitautoimg.com/autoalbum/files/20231216/752/202312161529273518775238543_3000x2000_w1.jpg', 1400.00, '白色', 0, '2024-11-23 17:06:21', '2024-11-23 17:06:21', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (12, 11, '苏H00001', 200, '八成新', 'https://auto.sinaimg.cn/autoimg/car/15/96/131289615_src.JPG', 80.00, '金色', 0, '2024-11-23 17:12:33', '2024-11-23 17:12:33', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (13, 11, '苏H00022', 200, '七成新', 'https://img4.bitautoimg.com/autoalbum/files/20220729/352/20220729195_9872755_22.jpg', 80.00, '白色', 0, '2024-11-23 17:13:11', '2024-11-23 17:13:11', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (14, 11, '苏G00001', 1000, '很差', 'https://a3.ifengimg.com/autoimg/67/90/1839067_8.jpg', 50.00, '棕色', 0, '2024-11-23 17:15:41', '2024-11-23 17:15:41', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (15, 3, '沪A00001', 78, '九成新', 'https://n.sinaimg.cn/sinacn19/600/w1920h1080/20181026/fa82-hmxrkzx3177781.jpg', 1300.00, '白色', 0, '2024-11-23 17:17:34', '2024-11-23 17:17:34', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (16, 3, '苏B8888', 194, '八成新', 'https://img4.bitautoimg.com/autoalbum/files/20230509/331/202305093763363625433159438_3000x2000_w1.jpg', 1280.00, '蓝色', 0, '2024-11-23 17:18:26', '2024-11-23 17:18:26', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (17, 5, '京B11111', 100, '九五新', 'https://www.modiauto.com.cn/auto/images/202208/202208301303026f6a888087e91.jpg?image_process=resize,fw_800,fh_600', 3500.00, '黄色', 0, '2024-11-23 17:19:42', '2024-11-23 17:19:42', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (18, 5, '鄂C77777', 120, '九成新', 'https://img1.bitautoimg.com/autoalbum/files/20230629/567/202306294583803524956787157_3000x2000_w1.jpg', 3900.00, '白色', 0, '2024-11-23 17:20:50', '2024-11-23 17:20:50', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (19, 4, '浙A000001', 184, '八成新', 'https://n.sinaimg.cn/sinakd20200618ac/600/w1920h1080/20200618/4db5-ivffpcs1988821.jpg', 2110.00, '绿色', 0, '2024-11-23 17:22:17', '2024-11-23 17:22:17', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (20, 4, '苏E55555', 555, '七成新', 'https://img.pcauto.com.cn/images/upload/upc/tx/auto5/2212/22/c21/346011005_1671713682677.jpg', 1800.00, '黑色', 0, '2024-11-23 17:23:30', '2024-11-23 17:23:30', 0);


INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (1, '奔驰', 'e300', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.ZNLoND95Na42tec9yPmyIQHaFj?rs=1&pid=ImgDetMain', 3, 1700.00, '2024-10-28 16:15:11', '2024-10-29 15:55:45', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (2, '奥迪', 'A8', 'https://img1.xcarimg.com/b63/s15358/2000_1500_20220913174500029869827614065.jpg', 3, 3000.00, '2024-10-29 17:24:12', '2024-11-05 10:19:00', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (3, '宝马', 'X5', 'https://p3.dcarimg.com/img/tos-cn-i-dcdx/0910570e872a4d80b5a4f64f07010009~1200x0.webp', 3, 2000.00, '2024-11-05 10:12:02', '2024-11-05 10:12:02', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (4, '兰博基尼', 'Urus', 'https://n.sinaimg.cn/autosina/autotopic/560/w1080h1080/20200312/6333-iqrhckn6983356.jpg', 10, 2100.00, '2024-11-05 10:16:38', '2024-11-05 10:16:38', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (5, '法拉利', 'SF90', 'https://auto.sinaimg.cn/autoimg/serial/00/00/3730_45966_950.jpg', 4, 3000.00, '2024-11-05 10:19:00', '2024-11-05 10:19:00', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (6, '小米', 'Su7', 'https://static.xkwo.com/xiaok/0285cd2e91674a0dab2fcf350bfabbb5.png', 5, 1000.00, '2024-11-05 10:20:56', '2024-11-05 10:20:56', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (7, '五菱宏光', 'L', 'https://img1.xcarimg.com/news/3/33550/33552/846_635_20190306114842595962466045492.jpg', 7, 100.00, '2024-11-23 17:08:15', '2024-11-23 17:10:54', 1);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (8, '1', '1', 'https://img1.xcarimg.com/news/3/33550/33552/846_635_20190306114842595962466045492.jpg', 1, null, '2024-11-23 17:08:46', '2024-11-23 17:10:53', 1);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (9, '1', '1', 'https://img1.xcarimg.com/news/3/33550/33552/846_635_20190306114842595962466045492.jpg', 1, null, '2024-11-23 17:09:02', '2024-11-23 17:10:51', 1);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (10, '1', '1', 'https://img1.xcarimg.com/news/3/33550/33552/846_635_20190306114842595962466045492.jpg', 1, null, '2024-11-23 17:10:34', '2024-11-23 17:10:48', 1);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (11, '五菱宏光', 'L', 'https://img1.xcarimg.com/news/3/33550/33552/846_635_20190306114842595962466045492.jpg', 5, 100.00, '2024-11-23 17:11:39', '2024-11-23 17:11:39', 0);


INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (1, 3, 1, '2024-11-20 12:37:35', '2024-11-20 12:37:35');
INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (3, 7, 1, '2024-11-20 13:49:26', '2024-11-20 13:49:26');
INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (4, 3, 2, '2024-11-22 14:41:26', '2024-11-22 14:41:26');
INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (5, 4, 2, '2024-11-22 14:41:31', '2024-11-22 14:41:31');
INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (6, 5, 2, '2024-11-22 14:41:36', '2024-11-22 14:41:36');
INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (7, 7, 2, '2024-11-22 14:42:52', '2024-11-22 14:42:52');


INSERT INTO car_rent.comment (id, userId, newsId, content, createTime, updateTime) VALUES (2, 1, 1, '我觉得还是奔驰好', '2024-11-20 15:31:32', '2024-11-20 15:31:32');
INSERT INTO car_rent.comment (id, userId, newsId, content, createTime, updateTime) VALUES (3, 2, 1, '有人一起去开赛车吗？', '2024-11-22 15:14:51', '2024-11-22 15:14:51');
INSERT INTO car_rent.comment (id, userId, newsId, content, createTime, updateTime) VALUES (4, 1, 5, '我觉得论手动挡还得是五菱宏光', '2024-11-22 15:51:26', '2024-11-22 15:51:26');
INSERT INTO car_rent.comment (id, userId, newsId, content, createTime, updateTime) VALUES (5, 1, 3, '我还是比较喜欢小米Su7', '2024-11-22 15:51:43', '2024-11-22 15:51:43');


INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (1, '奔驰好还是宝马好？', 1, '汽车资讯', '汽车资讯111', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.ZNLoND95Na42tec9yPmyIQHaFj?rs=1&pid=ImgDetMain', '2024-10-29 13:48:29', '2024-10-29 15:10:43', 0);
INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (2, '男子DIY自制了防雨摩托车，效果杠杠滴！全程记录改造过程！', 1, '男子DIY自制了防雨摩托车，效果杠杠滴！全程记录改造过程！', '男子DIY自制了防雨摩托车，效果杠杠滴！全程记录改造过程！', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/20241122152203.png', '2024-11-22 15:22:26', '2024-11-22 15:22:26', 0);
INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (3, '尊界S800正式曝光', 1, '11月15日，华为常务董事、终端BG董事长、智能汽车解决方案BU董事长余承东站在汇集问界、智界、享界的2024广州车展鸿蒙智行主展台上，透露了尊界的正式发布时间。“尊界将于11月26日的华为发布会上，与Mate70手机一同正式发布。”', '11月15日，华为常务董事、终端BG董事长、智能汽车解决方案BU董事长余承东站在汇集问界、智界、享界的2024广州车展鸿蒙智行主展台上，透露了尊界的正式发布时间。“尊界将于11月26日的华为发布会上，与Mate70手机一同正式发布。”', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/20241122152422.png', '2024-11-22 15:24:29', '2024-11-22 15:40:02', 0);
INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (4, '11万多买B级车，这3台车才是家用车首选！', 1, '深蓝SL03：这不是普通的"网红脸"', '要说最近圈内最火的"黑马"，星海S7绝对榜上有名。11.98万的起售价着实让不少对手捏了把汗。这家伙的身材更是傲人：4935/1915/1495mm的车身尺寸配上2915mm轴距，站在它旁边，连隔壁家的豪车都得稍稍收敛几分。最绝的是，人家还有个0.191的风阻系数，这数据搁五年前，那都是高端跑车才敢说的话。', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/20241122153143.png', '2024-11-22 15:34:02', '2024-11-22 15:34:02', 0);
INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (5, '主打乐趣！2024年手动挡新车推荐', 1, '前段时间，老王拍了一条手动挡车型的视频，比较让人意外的是在评论区引出了大批手动挡爱好者留言，许多车友表示自己现在开的车是手动挡，下一台车也会选择手动挡，不为其他，就为了这种原始的机械驾驶感受。所以今天我们就以手动挡带来的驾驶乐趣为前提，给大家推荐几款价格亲民，并且具有一定操作乐趣的手动挡车型，希望可以帮助到大家。', '速腾2025款200TSI手动飞越版 对于喜欢手动挡，但预算有限的车迷来说，大众的手动挡车型绝对是很有代表性的。一方面，大众的手动挡有着极具吸入感的换挡体验，另一方面，配合德系底盘调教，在驾驶维度，大众的手动挡车型也有着十分不错的操控乐趣。捷达VS5 280TSI手动先锋版 如果说买速腾1.2T手动挡看中的是大众品牌的话，那么在更低的价位，其实还有一款性能更强的“大众“手动挡车型，它就是捷达VS5。', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/20241122154757.png', '2024-11-22 15:48:03', '2024-11-22 15:48:03', 0);
INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (6, '1', 331382786, '1', '无', 'https://img.pcauto.com.cn/images/upload/upc/tx/auto5/2212/22/c21/346011005_1671713682677.jpg', '2024-11-23 17:25:42', '2024-11-23 17:27:03', 1);


INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (4, 1, 1, 2000.00, '2024-10-26 08:00:00', '2024-11-30 08:00:00', 3, 'nice！！！', '2024-10-28 21:05:30', '2024-11-20 14:17:28', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (5, 2, 1, 3600.00, '2024-10-28 17:34:49', '2024-10-30 17:34:49', 3, '还不错，希望下次还能体验', '2024-10-29 17:34:58', '2024-11-20 14:17:42', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (6, 1, 1, 2000.00, '2024-10-29 22:17:40', '2024-10-30 22:17:40', 3, '体验很不错！！！', '2024-10-29 22:18:18', '2024-11-20 13:23:41', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (7, 3, 1, 5100.00, '2024-11-20 12:39:42', '2024-11-21 12:39:42', 3, '体验还不错哦！！！', '2024-11-20 12:40:01', '2024-11-20 13:48:27', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (8, 2, 1, 2400.00, '2024-11-20 13:33:10', '2024-11-21 13:33:10', 3, '论体验还得是奔驰', '2024-11-20 13:33:19', '2024-11-20 13:48:42', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (9, 2, 1, 1200.00, '2024-11-22 13:49:55', '2024-11-22 13:49:55', 2, null, '2024-11-22 13:50:15', '2024-11-22 13:50:15', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (10, 3, 1, 2550.00, '2024-11-22 15:55:07', '2024-11-22 15:55:07', 0, null, '2024-11-22 15:55:15', '2024-11-22 15:55:15', 0);


INSERT INTO car_rent.user (id, userAccount, userPassword, userName, userAvatar, phone, userRole, address, createTime, updateTime, isDelete) VALUES (1, 'admin', '85a3c0ee19def3570aa9250cdb982fa7', '钱魏魏', 'https://th.bing.com/th/id/OIP._BCxtPP8Vz8-XTNS05yuRQHaHa?rs=1&pid=ImgDetMain', '124456344', 'admin', '泰州', '2024-10-28 13:24:05', '2024-11-19 11:16:03', 0);
INSERT INTO car_rent.user (id, userAccount, userPassword, userName, userAvatar, phone, userRole, address, createTime, updateTime, isDelete) VALUES (2, 'qianweiwei', '85a3c0ee19def3570aa9250cdb982fa7', '钱魏魏', 'https://th.bing.com/th/id/OIP.1nIZwFTzM-j-dFBoTCqLbgAAAA?w=400&h=400&rs=1&pid=ImgDetMain', '18329424', 'user', '江苏省淮安市', '2024-10-29 16:28:29', '2024-11-19 11:16:12', 0);
INSERT INTO car_rent.user (id, userAccount, userPassword, userName, userAvatar, phone, userRole, address, createTime, updateTime, isDelete) VALUES (1480626177, 'luren', '85a3c0ee19def3570aa9250cdb982fa7', 'luren', 'https://th.bing.com/th/id/OIP.A13DFy8roQXafCGCBsJuTgAAAA?w=300&h=300&rs=1&pid=ImgDetMain', '24894289', 'user', '南京', '2024-11-20 13:55:47', '2024-11-20 13:57:08', 0);
