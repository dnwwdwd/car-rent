<template>
  <div style="max-width: 80%; margin: auto;">
    <a-list item-layout="vertical" size="large" :pagination="pagination" :data-source="listData" bordered>
      <template #renderItem="{ item }">
        <a-list-item key="item.title" @click="router.push(`/news/detail/${item.id}`)">
          <template #extra>
            <img
                height="100px"
                width="120px"
                alt="logo"
                :src="item.imgUrl"
            />
          </template>
          <a-list-item-meta :description="item.description">
            <template #title>
              <a :href="item.href">{{ item.title }}</a>
            </template>
            <template #avatar><a-avatar :src="item.user.userAvatar" /></template>
          </a-list-item-meta>
          {{ item.content }}
        </a-list-item>
      </template>
    </a-list>
  </div>
</template>
<script lang="js" setup>
import {onMounted, ref} from "vue";
import myAxios from "../../plugins/myAxios.js";
import {useRouter} from "vue-router";

const router = useRouter();

const listData = ref([]);

const pagination = {
  onChange: (page) => {
    loadData(page);
  },
  pageSize: 4,
};

const loadData = async (page) => {
  const res = await myAxios.get(`/news/list`, {
    pageSize: pagination.pageSize,
    pageNum: page,
  });
  listData.value = res.data;
}

onMounted(async () => {
  loadData(1);
});

</script>