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
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (3, 3, '鄂A00001', 100, '九成新', 'https://n.sinaimg.cn/sinacn20/16/w1920h1296/20181108/7ea6-hnprhzw5248511.jpg', 2550.00, '蓝色', 0, '2024-11-05 10:13:41', '2024-11-05 10:15:13', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (4, 2, '苏A00000', 220, '九成新', 'https://img1.xcarimg.com/b63/s8742/20170324101225975627214431258.jpg', 2100.00, '黑色', 0, '2024-11-05 10:15:13', '2024-11-05 10:15:13', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (5, 4, '苏B00001', 90, '九九新', 'https://n.sinaimg.cn/sinakd20200618ac/600/w1920h1080/20200618/557a-ivffpcs1988820.jpg', 2000.00, '橙色', 0, '2024-11-05 10:17:44', '2024-11-05 10:17:44', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (6, 5, '沪A00001', 100, '九成新', 'https://s3.xchuxing.com/xchuxing/forum/201905/30/105008mk1cajc12cau2aaa.jpeg', 3000.00, '红色', 0, '2024-11-05 10:20:10', '2024-11-05 10:20:10', 0);
INSERT INTO car_rent.car (id, carCategoryId, carNumber, mileage, quality, imgUrl, rentPrice, color, status, createTime, updateTime, isDelete) VALUES (7, 6, '苏A11111', 100, '九成新', 'https://image.bitautoimg.com/appimage-630-w1/news/2023/12/30/516cafaeef0f45bd984a57fefd283bd5.jpg', 1000.00, '橄榄绿', 0, '2024-11-05 10:22:46', '2024-11-05 10:22:46', 0);


INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (1, '奔驰', 'e300', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.ZNLoND95Na42tec9yPmyIQHaFj?rs=1&pid=ImgDetMain', 3, 1700.00, '2024-10-28 16:15:11', '2024-10-29 15:55:45', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (2, '奥迪', 'A8', 'https://img1.xcarimg.com/b63/s15358/2000_1500_20220913174500029869827614065.jpg', 3, 3000.00, '2024-10-29 17:24:12', '2024-11-05 10:19:00', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (3, '宝马', 'X5', 'https://p3.dcarimg.com/img/tos-cn-i-dcdx/0910570e872a4d80b5a4f64f07010009~1200x0.webp', 3, 2000.00, '2024-11-05 10:12:02', '2024-11-05 10:12:02', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (4, '兰博基尼', 'Urus', 'https://n.sinaimg.cn/autosina/autotopic/560/w1080h1080/20200312/6333-iqrhckn6983356.jpg', 10, 2100.00, '2024-11-05 10:16:38', '2024-11-05 10:16:38', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (5, '法拉利', 'SF90', 'https://auto.sinaimg.cn/autoimg/serial/00/00/3730_45966_950.jpg', 4, 3000.00, '2024-11-05 10:19:00', '2024-11-05 10:19:00', 0);
INSERT INTO car_rent.car_category (id, brand, type, imgUrl, stock, averagePrice, createTime, updateTime, isDelete) VALUES (6, '小米', 'Su7', 'https://static.xkwo.com/xiaok/0285cd2e91674a0dab2fcf350bfabbb5.png', 5, 1000.00, '2024-11-05 10:20:56', '2024-11-05 10:20:56', 0);


INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (1, 3, 1, '2024-11-20 12:37:35', '2024-11-20 12:37:35');
INSERT INTO car_rent.car_star (id, carId, userId, createTime, updateTime) VALUES (3, 7, 1, '2024-11-20 13:49:26', '2024-11-20 13:49:26');


INSERT INTO car_rent.comment (id, userId, newsId, content, createTime, updateTime) VALUES (2, 1, 1, '我觉得还是奔驰好', '2024-11-20 15:31:32', '2024-11-20 15:31:32');


INSERT INTO car_rent.news (id, title, userId, description, content, imgUrl, createTime, updateTime, isDelete) VALUES (1, '奔驰好还是宝马好？', 1, '汽车资讯', '汽车资讯111', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.ZNLoND95Na42tec9yPmyIQHaFj?rs=1&pid=ImgDetMain', '2024-10-29 13:48:29', '2024-10-29 15:10:43', 0);


INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (4, 1, 1, 2000.00, '2024-10-26 08:00:00', '2024-11-30 08:00:00', 3, 'nice！！！', '2024-10-28 21:05:30', '2024-11-20 14:17:28', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (5, 2, 1, 3600.00, '2024-10-28 17:34:49', '2024-10-30 17:34:49', 3, '还不错，希望下次还能体验', '2024-10-29 17:34:58', '2024-11-20 14:17:42', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (6, 1, 1, 2000.00, '2024-10-29 22:17:40', '2024-10-30 22:17:40', 3, '体验很不错！！！', '2024-10-29 22:18:18', '2024-11-20 13:23:41', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (7, 3, 1, 5100.00, '2024-11-20 12:39:42', '2024-11-21 12:39:42', 3, '体验还不错哦！！！', '2024-11-20 12:40:01', '2024-11-20 13:48:27', 0);
INSERT INTO car_rent.`order` (id, carId, userId, totalPrice, rentalStartDate, rentalEndDate, status, evaluation, createTime, updateTime, isDelete) VALUES (8, 2, 1, 2400.00, '2024-11-20 13:33:10', '2024-11-21 13:33:10', 3, '论体验还得是奔驰', '2024-11-20 13:33:19', '2024-11-20 13:48:42', 0);


INSERT INTO car_rent.user (id, userAccount, userPassword, userName, userAvatar, phone, userRole, address, createTime, updateTime, isDelete) VALUES (1, 'admin', '85a3c0ee19def3570aa9250cdb982fa7', '钱魏魏', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/image-20241119111441579.png', '124456344', 'admin', '淮安', '2024-10-28 13:24:05', '2024-11-19 11:16:03', 0);
INSERT INTO car_rent.user (id, userAccount, userPassword, userName, userAvatar, phone, userRole, address, createTime, updateTime, isDelete) VALUES (2, 'qianweiwei', '85a3c0ee19def3570aa9250cdb982fa7', '钱魏魏', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/image-20241119111441579.png', '18329424', 'user', '江苏省淮安市', '2024-10-29 16:28:29', '2024-11-19 11:16:12', 0);
INSERT INTO car_rent.user (id, userAccount, userPassword, userName, userAvatar, phone, userRole, address, createTime, updateTime, isDelete) VALUES (1480626177, 'luren', '85a3c0ee19def3570aa9250cdb982fa7', 'luren', 'https://hejiajun-img-bucket.oss-cn-wuhan-lr.aliyuncs.com/img/image-20241119111441579.png', '24894289', 'user', '南京', '2024-11-20 13:55:47', '2024-11-20 13:57:08', 0);
