<template>
  <div>
    <b-form class="search" @submit="onSearch" inline>
      <label class="sr-only" for="address">User Address</label>
      <b-input id="address" v-model="userAddress" class="mr-2" size="sm" placeholder="请输入用户地址"/>
      <b-button type="submit" variant="outline-secondary" size="sm">查询</b-button>
    </b-form>
    <section class="list-view" v-if="show">
      <div v-if="loading" class="loading">loading...</div>
      <div v-else-if="keepList.length === 0" class="no-content">nothing...</div>
      <ol v-else class="list">
        <li v-for="(item, index) in keepList" :key="index" class="list-item">
          <router-link :to="'/keep/' + item" class="item-title">{{ item }}</router-link>
          <br>
        </li>
      </ol>
    </section>
  </div>
</template>

<script>
import { keepitContract } from "../utils/contract.js";
import { time2String } from '../utils/time.js'
import { userInfo } from 'os';

export default {
  name: "KeepList",
  data() {
    return {
      show: false,
      loading: false,
      keepList: [],
      userAddress: ''
    };
  },
  methods: {
    onSearch(evt) {
      evt.preventDefault();
      this.keepList = localStorage.getItem(this.userAddress)
        ? localStorage.getItem(this.userAddress).split(",")
        : [];
      this.show = true;
    }
  }
};
</script>

<style scope>
#address {
  width: 88%;
}
.loading,
.no-content {
  text-align: center;
}
.list-view {
  margin-top: 50px;
}
.list-view ol,
ul {
  padding: 0;
  list-style: none;
}
.list-view li {
  border-bottom: 1px solid #ddd;
}

.list-item {
  position: relative;
  margin-bottom: 30px;
  font-family: Courier, monospace, 'Courier New';
}

.item-title {
  display: inline-block;
  color: #555;
}

.item-title:hover {
  color: #08c;
}
/* 
.item-state {
  font-size: 12px;
  color: #888;
} */
</style>
