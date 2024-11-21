<template>
  <a-table :columns="columns" :data-source="dataSource" bordered>
    <template #bodyCell="{ column, text, record }">
      <template v-if="['content'].includes(column.dataIndex)">
        <div>
          <a-input
              v-if="editableData[record.key]"
              v-model:value="editableData[record.key][column.dataIndex]"
              style="margin: -5px 0"
          />
          <template v-else>
              {{ text }}
          </template>
        </div>
      </template>
      <template v-if="column.dataIndex === 'userId'">
        <a-select
            v-if="editableData[record.key]"
            v-model:value="editableData[record.key][column.dataIndex]"
            style="width: 120px; margin-top: 10px"
        >
          <a-select-option
              v-for="id in userIds"
              :key="id"
              :value="id"
          >
            {{ id }}
          </a-select-option>
        </a-select>
      </template>
      <template v-if="column.dataIndex === 'newsId'">
        <a-select
            v-if="editableData[record.key]"
            v-model:value="editableData[record.key][column.dataIndex]"
            style="width: 120px; margin-top: 10px"
        >
          <a-select-option
              v-for="id in newsIds"
              :key="id"
              :value="id"
          >
            {{ id }}
          </a-select-option>
        </a-select>
      </template>
      <!-- 对 operation 字段显示编辑/保存/取消/删除操作 -->
      <template v-else-if="column.dataIndex === 'operation'">
        <div class="editable-row-operations">
        <span v-if="editableData[record.key]">
          <a-typography-link @click="save(record.key)">确定</a-typography-link>
          <a-popconfirm title="你确定取消吗？" @confirm="cancel(record.key)" ok-text="确定" cancel-text="取消">
            <a>取消</a>
          </a-popconfirm>
        </span>
          <span v-else>
          <a @click="edit(record.key)">修改</a>
          <a-popconfirm title="你确定删除吗？" @confirm="onDelete(record.key)" ok-text="确定" cancel-text="取消">
            <a>删除</a>
          </a-popconfirm>
        </span>
        </div>
      </template>
    </template>
  </a-table>

</template>

<script setup>
import {cloneDeep} from 'lodash-es';
import {onMounted, reactive, ref} from 'vue';
import myAxios from "../../plugins/myAxios.js";
import {message} from "ant-design-vue";

// 表格列定义
const columns = [
  {
    title: 'id',
    dataIndex: 'id',
    width: '10%',
  },
  {
    title: '评论者 ID',
    dataIndex: 'userId',
    width: '10%',
  },
  {
    title: '论坛 ID',
    dataIndex: 'newsId',
    width: '10%',
  },
  {
    title: '评论内容',
    dataIndex: 'content',
    width: '20%',
  },
  {
    title: '操作',
    dataIndex: 'operation',
    width: '15%',
  },
];

// 响应式数据源
const dataSource = ref([]);
const editableData = reactive({});

const newsIds = ref([]);

const userIds = ref([]);

// 编辑函数，点击编辑按钮时调用
const edit = (key) => {
  editableData[key] = cloneDeep(dataSource.value.find(item => item.key === key));
};

const save = async (key) => {
  // 编辑保存后的新值
  const editedData = editableData[key];
  // 请求后端更新数据
  const res = await myAxios.post('/comment/update', editedData);
  if (res.code === 0) {
    Object.assign(dataSource.value.find(item => item.key === key), editedData);
    message.success('修改成功');
  } else {
    message.error('修改失败');
  }
  delete editableData[key];
};

// 取消函数，点击取消按钮时调用
const cancel = (key) => {
  delete editableData[key];
};

// 删除函数，点击删除按钮时调用
const onDelete = async (key) => {
  console.log(key);
  const item = dataSource.value.find(item => item.key === key);
  console.log(item.id);
  // 请求后端删除数据
  const res = await myAxios.post('/comment/delete', {
    id: item.id,
  });
  if (res.code === 0) {
    dataSource.value = dataSource.value.filter(item => item.key !== key);
    message.success('删除成功');
  } else {
    message.error('删除失败');
  }
};

const loadData = async () => {
  const res = await myAxios.get('/comment/list/all');
  if (res.code === 0) {
    dataSource.value = res.data.map((item, index) => ({
      ...item,
      key: index, // 添加key属性，值从0开始递增
    }));
  }
  const resp = await myAxios.get('/user/list/id');
  if (resp.code === 0) {
    userIds.value = resp.data;
  }
  const result = await myAxios.get('/news/list');
  if (result.code === 0) {
    newsIds.value = result.data.map(item => item.id);
  }
};


onMounted(async () => {
  loadData();
});
</script>

<style scoped>
.editable-row-operations a {
  margin-right: 8px;
}

.editable-add-btn {
  margin-bottom: 8px;
}
</style>
