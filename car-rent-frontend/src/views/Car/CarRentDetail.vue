<template>
  <div style="max-width: 85%; display: flex; justify-content: center; align-items: center; margin: auto; padding: 18px">
    <div style="width: 240px">
      <a-image
          :width="240"
          :height="340"
          :src="carVO.imgUrl"
          style="border-radius: 6%"
      />
    </div>
    <div style="width: 50%; margin-left: 28px; border: 1px solid #e8e8e8;
    border-radius: 5px; background-color: #f9f9f9; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);" :data-content="watermarkContent" id="watermark">
      <div style="padding: 12px">
        <span style="font-size: 27px">品牌：{{ carVO.brand }}</span>
        <span style="margin-left: 10px; font-size: 15px">型号：{{ carVO.type }}</span>
      </div>
      <a-divider/>
      <div style="padding: 10px">
        <h3 style="font-size: 18px">成色：{{ carVO.quality }}</h3>
        <h3 style="font-size: 18px">单日租车价格：{{ carVO.rentPrice }}</h3>
        <h3 style="font-size: 18px">车牌号：{{ carVO.carNumber }}</h3>
        <h3 style="font-size: 18px">里程数：{{ carVO.mileage }}</h3>
        <h3 style="font-size: 18px">颜色：{{ carVO.color }}</h3>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <h3 style="font-size: 18px">是否已出租：{{ carVO.status === 1 ? '是' : '否' }}</h3>
          <a-button v-if="!isStarred" @click="addCarStar" style="margin-left: 220px; color: #1E90FF">收藏</a-button>
          <a-button v-if="isStarred" @click="deleteCarStar" style="margin-left: 220px; color: #1E90FF">取消收藏</a-button>
          <a-button v-if="carVO.status === 0" style="color: #1E90FF" @click="showModal">我要租车</a-button>
          <a-modal v-model:open="open" title="申请领养" :confirm-loading="confirmLoading" @ok="handleOk" ok-text="确认"
                   cancel-text="取消">
            联系方式：
            <a-input v-model:value="formModal.phone" placeholder="请输入您的联系方式" class="a-input"/>
            家庭住址：
            <a-input v-model:value="formModal.address" placeholder="请输入你的家庭住址" class="a-input"/>
            租赁起始日期和结束日期；
            <a-range-picker
                v-model:value="date"
                :placeholder="['租赁起始日期', '租赁结束日期']"
            />
          </a-modal>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="js">
import {onMounted, ref} from "vue";
import myAxios from "../../plugins/myAxios.js";
import {useRoute} from "vue-router";
import {message} from "ant-design-vue";

const open = ref(false);
const confirmLoading = ref(false);
const isStarred = ref(false);
const date = ref();

const route = useRoute();

const id = route.params.id;

const carVO = ref({});

const watermarkContent = ref('');

const formModal = ref({
  phone: '',
  address: '',
});

const loadData = async () => {
  const res = await myAxios.get(`/car/detail/${id}`);
  if (res.data) {
    carVO.value = res.data;
    switch (res.data.status) {
      case 0:
        watermarkContent.value = '可租赁';
        break;
      case 1:
        watermarkContent.value = '已被租赁';
        break;
      case 2:
        watermarkContent.value = '已被预约';
        break;
      default:
        watermarkContent.value = '';
    }
  }
  const result = await myAxios.post('/car_star/is', {
    carId: id
  });
  if (result.code === 0) {
    isStarred.value = result.data;
  }
};

onMounted(async () => {
  loadData()
});

const showModal = () => {
  open.value = true;
};

const handleOk = async () => {
  const res = await myAxios.post('/order/add', {
    phone: formModal.value.phone,
    address: formModal.value.address,
    carId: id,
    rentalStartDate: date.value[0],
    rentalEndDate: date.value[1],
  });
  if (res.code === 0) {
    open.value = false;
    formModal.value.address = '';
    formModal.value.phone = '';
    date.value = null;
    loadData();
  }
};

const deleteCarStar = async () => {
  const res = await myAxios.post('/car_star/delete', {
    carId: id
  });
  if (res.code === 0) {
    message.success('取消收藏成功')
    isStarred.value = false;
  }
}

const addCarStar = async () => {
  const res = await myAxios.post('/car_star/add', {
    carId: id
  });
  if (res.code === 0) {
    message.success(' 收藏成功');
    isStarred.value = true;
  }
};

</script>

<style scoped>
.a-input {
  margin-bottom: 10px;
}

#watermark {
  position: relative;
  padding: 20px;
  border: 1px solid #e8e8e8;
  overflow: hidden; /* 确保内容不会超出盒子 */
  height: 350px;
}

/* 使用 data-content 属性设置动态水印内容 */
#watermark::before {
  content: attr(data-content); /* 动态显示 data-content 属性的值 */
  position: absolute;
  top: 50%;
  left: 65%;
  transform: translate(-50%, -50%) rotate(-30deg); /* 水印倾斜更美观 */
  font-size: 30px;
  color: rgba(0, 0, 0, 0.1);
  pointer-events: none; /* 确保水印不影响用户操作 */
  white-space: nowrap;
  z-index: 0;
}

#watermark > * {
  position: relative; /* 确保内容位于水印上方 */
  z-index: 1;
}
</style>