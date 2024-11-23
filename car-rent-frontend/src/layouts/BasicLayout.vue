<template>
  <a-layout class="layout" style="min-height: 100vh; display: flex; flex-direction: column;">
    <a-layout-header :style="{ background: '#fff', display: 'flex', alignItems: 'center', marginBottom: '24px' }">
      <img src="../assets/logo.png" alt="Logo" style="height: 40px; margin-right: 20px"/>
      <span style="font-size: 15px; color: #1E90FF">基于Java的汽车租赁平台</span>
      <!-- 动态高亮菜单项 -->
      <a-menu
          :selectedKeys="selectedKeys"
          theme="light"
          mode="horizontal"
          :style="{ lineHeight: '64px', flexGrow: 1 }"
      >
        <a-menu-item key="1">
          <router-link to="/">首页</router-link>
        </a-menu-item>
        <a-menu-item key="2">
          <router-link to="/car/rent">租车</router-link>
        </a-menu-item>
        <a-menu-item key="3">
          <router-link to="/order">我的订单</router-link>
        </a-menu-item>
        <a-menu-item key="4">
          <router-link to="/news">资讯</router-link>
        </a-menu-item>
        <a-menu-item key="5">
          <router-link to="/my/car/star">我的收藏</router-link>
        </a-menu-item>
      </a-menu>

      <a-button class="editable-add-btn" style="margin-bottom: 8px; margin-right: 28px; margin-top: 12px; color: #4290FF" @click="handleAdd">
        发布资讯
      </a-button>
      <a-modal v-model:open="open" title="发布资讯" @ok="handleOk" cancelText="取消" okText="确认添加">
        资讯名称：
        <a-input v-model:value="formModal.title" class="a-input"/>
        资讯描述：
        <a-input v-model:value="formModal.description" class="a-input"/>
        图片：
        <a-input v-model:value="formModal.imgUrl" class="a-input"/>
        资讯内容：
        <a-input v-model:value="formModal.content" class="a-input"/>
      </a-modal>

      <a-dropdown style="margin-left: auto">
        <div>
          <a-avatar
              shape="circle"
              :src="user.userAvatar"
          />
          <span style="margin-left: 3px">{{user.userName}}</span>
        </div>
        <template #overlay>
          <a-menu>
            <a-menu-item>
              <router-link to="/admin/carRentManagement" v-if="isAdmin">后台管理</router-link>
            </a-menu-item>
            <a-menu-item>
              <router-link to="/user/setting">个人设置</router-link>
            </a-menu-item>
            <a-menu-item>
              <router-link to="/user/login" @click="userLogout">退出登录</router-link>
            </a-menu-item>
          </a-menu>
        </template>
      </a-dropdown>
    </a-layout-header>

    <a-layout-content style="padding: 0 50px; height:100%">
      <router-view/>
    </a-layout-content>

  </a-layout>
</template>

<script lang="js" setup>
import {onMounted, ref, watchEffect} from 'vue';
import {useRoute, useRouter} from 'vue-router';
import myAxios from "../plugins/myAxios.js";
import {message} from "ant-design-vue";
import {getCurrentUser} from "../services/user.js";

const selectedKeys = ref([]);

const route = useRoute();
const router = useRouter();
const isAdmin = ref(false);
const user = ref({});

const open = ref(false);

const formModal = ref({
  userId: '',
  title: '',
  description: '',
  imgUrl: '',
  content: '',
});

onMounted(async () => {
  if (!route.path.includes('/user/login') && !route.path.includes('/user/register')) {
    const res = await getCurrentUser();
    if (res) {
      user.value = res;
      isAdmin.value = user.value.userRole === "admin";
    }
    if (res.code === 40100) {
      router.push('/user/login')
    }
  }
});


watchEffect(() => {
  switch (route.path) {
    case '/':
      selectedKeys.value = ['1'];
      break;
    case '/car/rent':
      selectedKeys.value = ['2'];
      break;
    case '/order':
      selectedKeys.value = ['3'];
      break;
    case '/news':
      selectedKeys.value = ['4'];
      break;
    case '/my/car/star':
      selectedKeys.value = ['5'];
      break;
    default:
      selectedKeys.value = [];
  }
});

const userLogout = async () => {
  const res = await myAxios.post('/user/logout');
  message.success('退出成功');
};

const handleAdd = () => {
  open.value = true;
};

const handleOk = async () => {
  // 请求后端，添加表格项
  const result = await myAxios.post('/news/add', formModal.value);
  if (result.code === 0) {
    message.success('添加成功');
    open.value = false;
    window.location.reload();
  } else {
    message.error('添加失败');
  }
  // 重新加载表格数据
  loadData();
};

</script>

<style scoped>

</style>
