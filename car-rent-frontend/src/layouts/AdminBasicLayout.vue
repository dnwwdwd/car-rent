<template>
  <a-layout style="min-height: 100vh">
    <a-layout-sider v-model:collapsed="collapsed" collapsible>
      <div style="display: flex; justify-content: center; align-items: center; margin-top: 20px; margin-bottom: 5px;">
        <img src="../assets/logo.png" width="32" height="30" style="margin-right: 10px;"/>
        <span style="color: yellowgreen">基于Java的汽车租赁平台</span>
      </div>
      <a-menu v-model:selectedKeys="selectedKeys" theme="dark" mode="inline">
        <a-menu-item key="1">
          <router-link to="/admin/carRentManagement">
            <CarOutlined/>
            <span>汽车管理</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="2">
          <router-link to="/admin/carCategoryManagement">
            <FormOutlined/>
            <span>汽车分类管理</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="3">
          <router-link to="/admin/orderManagement">
            <desktop-outlined/>
            <span>订单管理</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="4">
          <router-link to="/admin/newsManagement">
            <ContainerOutlined/>
            <span>资讯管理</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="5">
          <router-link to="/admin/commentManagement">
            <CommentOutlined/>
            <span>评论管理</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="6">
          <router-link to="/admin/userManagement">
            <user-outlined/>
            <span>用户管理</span>
          </router-link>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
    <a-layout>
      <a-layout-header style="background: #fff; padding: 0; height: 60px">
        <div style="display: flex; justify-content: space-between; align-items: center">
          <span style="font-size: 20px; margin-left: 20px; color: #1E90FF">{{ title }}</span>
          <div style="margin-right: 30px">
            <a-dropdown>
              <div>
                <a-avatar
                    shape="circle"
                    :src="user.userAvatar"
                />
                <span style="margin-left: 3px">{{ user.userName }}</span>
              </div>
              <template #overlay>
                <a-menu>
                  <a-menu-item>
                    <router-link to="/">前台页面</router-link>
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
          </div>
        </div>
      </a-layout-header>
      <a-layout-content style="margin: 0 16px">
        <router-view/>
      </a-layout-content>
      <a-layout-footer style="text-align: center">
        Ant Design ©2018 Created by Ant UED
      </a-layout-footer>
    </a-layout>
  </a-layout>
</template>
<script lang="js" setup>
import {
  CarOutlined,
  CommentOutlined,
  DesktopOutlined,
  FormOutlined,
  UserOutlined,
  ContainerOutlined
} from '@ant-design/icons-vue';
import {onMounted, ref, watchEffect} from 'vue';
import {useRoute, useRouter} from "vue-router";
import {getCurrentUser} from "../services/user.js";
import {message} from "ant-design-vue";
import myAxios from "../plugins/myAxios.js";
import routes from "../route/index.js";

const collapsed = ref(false);
const selectedKeys = ref([]);

const title = ref('');

const route = useRoute();
const router = useRouter();

const user = ref({});

watchEffect(() => {
  // 根据当前路由的 path 来设置选中的菜单项
  switch (route.path) {
    case '/admin/carRentManagement':
      selectedKeys.value = ['1'];
      break;
    case '/admin/carCategoryManagement':
      selectedKeys.value = ['2'];
      break;
    case '/admin/orderManagement':
      selectedKeys.value = ['3'];
      break;
    case '/admin/newsManagement':
      selectedKeys.value = ['4'];
      break;
    case '/admin/commentManagement':
      selectedKeys.value = ['5'];
      break;
    case '/admin/userManagement':
      selectedKeys.value = ['6'];
      break;
    default:
      // 如果没有匹配到任何菜单项，清空选中项
      selectedKeys.value = [];
  }
});

router.beforeEach((to, from) => {
  routes.forEach(route => {
    if (to.path === route.path) {
      title.value = route.title;
    }
  });
});

onMounted(async () => {
  if (!route.path.includes('/user/login') && !route.path.includes('/user/register')) {
    const res = await getCurrentUser();
    if (res) {
      user.value = res;
    }
  }
});

const userLogout = async () => {
  const res = await myAxios.post('/user/logout');
  message.success('退出成功');
};

</script>

<style scoped>
#components-layout-demo-side .logo {
  height: 32px;
  margin: 16px;
  background: rgba(255, 255, 255, 0.3);
}

.site-layout .site-layout-background {
  background: #fff;
}

[data-theme='dark'] .site-layout .site-layout-background {
  background: #141414;
}
</style>
