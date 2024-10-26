-- 创建库
create database if not exists code_ranker;

-- 切换库
use code_ranker;

-- 用户登录/注册/介绍表
create table if not exists user
(
    id           bigint auto_increment comment 'id' primary key,
    userAccount  varchar(256)                           not null comment '账号',
    userPassword varchar(512)                           not null comment '密码',
    userName     varchar(256)                           null comment '用户昵称',
    userAvatar   varchar(1024)                          null comment '用户头像',
    userProfile  varchar(512)                           null comment '用户简介',
    userRole     varchar(256) default 'user'            not null comment '用户角色：user/admin/ban',
    createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete     tinyint      default 0                 not null comment '是否删除'
) comment '用户登录/注册/介绍表' collate = utf8mb4_unicode_ci;


create table code_ranker.github_user
(
    id                  bigint auto_increment comment 'id'
        primary key,
    login               varchar(512) null comment '用户名',
    node_id             varchar(256) null,
    avatar_url          varchar(512) null comment '头像链接',
    gravatar_id         varchar(256) null,
    url                 varchar(256) null comment '用户信息请求地址',
    html_url            varchar(256) null comment '用户主页链接',
    followers_url       varchar(256) null comment '粉丝信息请求地址',
    following_url       varchar(512) null comment '关注者信息请求地址',
    gists_url           varchar(256) null,
    starred_url         varchar(256) null comment '收藏某人项目的请求地址',
    subscriptions_url   varchar(256) null comment '订阅请求地址',
    organizations_url   varchar(256) null comment '组织请求地址',
    repos_url           varchar(256) null comment '个人项目请求地址',
    events_url          varchar(256) null comment '事件请求地址',
    received_events_url varchar(256) null comment '接受的事件请求地址',
    type                varchar(32)  null comment '类型 ',
    user_view_type      varchar(32)  null comment '用户访问类型',
    site_admin          tinyint      null comment '站点管理员（0 - 否 1 - 是）',
    name                varchar(256) null comment '昵称',
    company             varchar(256) null comment '公司',
    blog                varchar(256) null comment '博客',
    location            varchar(128) null comment '地区',
    email               varchar(64)  null comment '邮箱地址',
    hireable            varchar(256) null,
    bio                 varchar(256) null,
    twitter_username    varchar(256) null comment '推特昵称',
    public_repos        int          null comment '公共仓库数量',
    public_gists        int          null,
    followers           int          null comment '粉丝数量',
    following           int          null comment '关注者数量',
    created_at          datetime     null comment '创建时间',
    updated_at          datetime     null comment '更新时间'
)
    comment 'Github用户表';

create table code_ranker.github_user_project
(
    id                          bigint auto_increment comment 'id'
        primary key,
    node_id                     varchar(256)  null,
    name                        varchar(256)  null comment '项目名',
    full_name                   varchar(512)  null comment '全称',
    private                     tinyint       null comment '是否是私人的（0 - 否 1 - 是）',
    github_user_id              bigint        null comment '拥有人id',
    html_url                    varchar(256)  null comment '项目链接',
    description                 varchar(1024) null comment '项目描述/介绍',
    fork                        tinyint       null comment '是否复刻（0 - 否 1 - 是）',
    url                         varchar(256)  null comment '项目请求地址',
    forks_url                   varchar(256)  null comment '复刻请求地址',
    keys_url                    int           null comment 'key请求地址',
    collaborators_url           varchar(256)  null comment '协作者请求地址',
    teams_url                   varchar(256)  null comment '队伍请求地址',
    hooks_url                   varchar(256)  null comment 'hooks请求地址',
    issue_events_url            varchar(256)  null comment '问题事件请求地址',
    events_url                  varchar(256)  null comment '事件请求地址',
    branches_url                varchar(256)  null comment '分支请求地址',
    tags_url                    varchar(256)  null comment '标签请求地址',
    blobs_url                   varchar(256)  null comment 'git二进制请求地址',
    git_tags_url                varchar(256)  null comment 'git标签请求地址',
    git_refs_url                varchar(256)  null,
    trees_url                   varchar(256)  null,
    statuses_url                varchar(256)  null comment '状态请求地址',
    languages_url               varchar(256)  null comment '语言请求地址',
    stargazers_url              varchar(256)  null,
    contributors_url            varchar(256)  null comment '贡献者请求地址',
    subscribers_url             varchar(256)  null comment '订阅者请求地址',
    subscription_url            varchar(256)  null comment '订阅请求地址',
    commits_url                 varchar(256)  null comment '提交请求地址',
    git_commits_url             varchar(256)  null comment 'git请求地址',
    comments_url                varchar(256)  null comment '评论请求地址',
    issue_comment_url           varchar(256)  null comment '问题评论请求地址',
    contents_url                varchar(256)  null comment '内容请求地址',
    compare_url                 varchar(256)  null comment '比较请求地址',
    merges_url                  varchar(256)  null comment '合并请求地址',
    archive_url                 varchar(256)  null comment '归档请求地址',
    downloads_url               varchar(256)  null comment '下载请求地址',
    issues_url                  varchar(256)  null comment '问题请求地址',
    pulls_url                   varchar(256)  null comment '拉请求请求地址',
    milestones_url              varchar(256)  null comment '里程碑请求地址',
    notifications_url           varchar(256)  null comment '通知请求地址',
    labels_url                  varchar(256)  null comment '标签请求地址',
    releases_url                varchar(256)  null comment '发布请求地址',
    deployments_url             varchar(256)  null comment '部署请求地址',
    created_at                  datetime      null comment '创建时间',
    updated_at                  datetime      null comment '更新时间',
    pushed_at                   datetime      null comment '最后push时间',
    git_url                     varchar(256)  null comment 'git链接',
    ssh_url                     varchar(256)  null comment 'ssh链接',
    clone_url                   varchar(256)  null comment '克隆链接',
    svn_url                     varchar(256)  null comment 'svn链接',
    homepage                    varchar(256)  null comment '主页',
    size                        int           null comment '大小',
    stargazers_count            int           null,
    watchers_count              int           null comment '访问者数量',
    language                    varchar(256)  null comment '语言',
    has_issues                  tinyint       null comment '是否有问题（0 - 无 1 - 有）',
    has_projects                tinyint       null comment '是否有项目（0 - 无 1 - 有）',
    has_downloads               tinyint       null comment '是否有下载（0 - 无 1 - 有）',
    has_wiki                    tinyint       null comment '是否有wiki（0 - 无 1 - 有）',
    has_pages                   tinyint       null comment '是否有pages（0 - 无 1 - 有）',
    has_discussions             tinyint       null comment '是否有讨论（0 - 无 1 - 有）',
    forks_count                 int           null comment '复刻数量',
    mirror_url                  int           null comment '镜像链接',
    archived                    int           null comment '是否归档（0  - 否 1 - 是）',
    disabled                    int           null comment '是否可用（0  - 否 1 - 是）',
    open_issues_count           int           null,
    license                     varchar(256)  null,
    allow_forking               int           null comment '是否允许复刻（0  - 否 1 - 是）',
    is_template                 tinyint       null comment '是否是模板（0  - 否 1 - 是）',
    web_commit_signoff_required tinyint       null comment 'web提交要求说明（0  - 否 1 - 是）',
    topics                      varchar(512)  null comment '话题（Json 数组）',
    visibility                  varchar(32)   null comment '可见性',
    forks                       int           null comment '复刻数量',
    open_issues                 int           null,
    watchers                    int           null comment '访问人数',
    default_branch              varchar(256)  null comment '默认分支'
)
    comment 'Github用户项目表';

