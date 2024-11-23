<template>
  <div style="max-width: 80%; display: flex; justify-content: center; align-items: center; margin: auto; padding: 20px">
    <div style="width: 220px;">
      <a-image
          :width="200"
          :height="300"
          :src="newsVO.imgUrl"
          style="border-radius: 6%"
      />
    </div>
    <div
        :style="{
        width: '60%',
        height: computedContentHeight + 'px',
        border: '1px solid #e8e8e8',
        borderRadius: '5px',
        backgroundColor: '#f9f9f9',
        boxShadow: '8px 8px 8px rgba(173, 216, 230, 0.5)',
        overflowY: contentOverflow ? 'auto' : 'hidden'
      }"
    >
      <div style="padding: 20px; display: flex;">
        <a-avatar :src="newsVO.user.userAvatar"/>
        <span style="font-size: 24px; margin-left: 10px">{{ newsVO.title }}</span>
      </div>
      <div style="padding: 10px">
        <h3 style="font-size: 20px;">描述：{{ newsVO.description }}</h3>
        <span style="font-size: 20px;margin-top: 20px;">内容：</span>
        <span style="font-size: 20px; color: black">{{ newsVO.content }}</span>
      </div>
    </div>
  </div>
  <div style="width: 800px; margin: 0 auto; margin-top: 20px">
    <div style="display: flex; justify-content: center; align-items: center">
      <div>
        <img :src="currentUser.userAvatar" width="40px" height="40px" style="border-radius: 50%; margin: 0 auto"/>
        <a-input placeholder="请输入评论（按住回车发送）" style="width: 240px; margin-left: 12px" v-model:value="content"
                 @keydown.enter="addComment"/>
      </div>
    </div>
    <a-divider>评论区</a-divider>
    <div v-if="commentList && commentList.length > 0" style="margin-left: 270px">
      <a-comment v-for="comment in commentList">
        <template #author>{{ comment.userVO.userName }}</template>
        <template #avatar>
          <a-avatar :src="comment.userVO.userAvatar" alt="匿名"/>
        </template>
        <template #content>
          <p>
            {{ comment.content }}
          </p>
        </template>
        <template #datetime>
          <span>{{ comment.createTIme }}</span>
        </template>
      </a-comment>
    </div>
    <a-empty description="暂无任何评论" v-if="!commentList || commentList.length < 1"/>
  </div>
</template>

<script setup lang="js">
import { onMounted, ref, computed } from "vue";
import myAxios from "../../plugins/myAxios.js";
import { useRoute } from "vue-router";
import { getCurrentUser } from "../../services/user.js";
import { message } from "ant-design-vue";

const route = useRoute();

const id = route.params.id;

const currentUser = ref({});
const content = ref('');
const commentList = ref([]);

const newsVO = ref({
  user: {},
  content: ''  // Initialize content as an empty string to prevent undefined errors
});

// 加载数据
const loadData = async () => {
  const res = await myAxios.get(`/news/detail/${id}`);
  if (res.data) {
    newsVO.value = res.data;
  }
  currentUser.value = await getCurrentUser();
  const result = await myAxios.get('/comment/list', {
    params: {
      newsId: id
    }
  });
  if (result.code === 0) {
    commentList.value = result.data;
  }
};

// 计算内容区域的高度
const computedContentHeight = computed(() => {
  // Ensure content exists before calculating length
  const contentLength = newsVO.value.content ? newsVO.value.content.length : 0;
  if (contentLength < 100) {
    return 300; // 小内容，不需要滚动
  } else if (contentLength < 500) {
    return 400; // 中等内容
  } else {
    return 500; // 长内容，需要更大的高度并且滚动
  }
});

// 判断是否需要滚动条
const contentOverflow = computed(() => {
  return newsVO.value.content && newsVO.value.content.length > 500; // 如果内容较长则需要显示滚动条
});

onMounted(async () => {
  loadData();
});

// 添加评论
const addComment = async () => {
  const res = await myAxios.post('/comment/add', {
    content: content.value,
    newsId: id
  });
  if (res.code === 0) {
    content.value = '';
    loadData();
    message.success('评论发表成功');
  }
};
</script>

<style scoped>
.a-input {
  margin-bottom: 10px;
}
</style>
