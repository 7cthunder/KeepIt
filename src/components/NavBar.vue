<template>
  <div>
    <header class="header">
      <router-link to="/">Keep It</router-link>
    </header>
    <div style="clear: both"/>
    <div class="nav-wrapper">
      <div @click="goCreate" class="nav">
        <i class="iconfont icon-chuangjian"></i>
        创建
      </div>
      <div @click="goJoin" class="nav">
        <i class="iconfont icon-join"></i>
        加入
      </div>
      <div @click="goKeep" class="nav">
        <i class="iconfont icon-meirijianchi"></i>
        打卡
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'navbar',
  methods: {
    goCreate(evt) {
      evt.preventDefault()
      this.$router.push('/create')
    },
    goJoin(evt) {
      evt.preventDefault()
      this.$router.push('/join')
    },
    goKeep(evt) {
      evt.preventDefault()
      this.$router.push('/keep')
    },
  }
};
</script>

<style scope>
.header {
  margin: 40px auto 10px;
  text-align: center;
}
.header a {
  text-decoration: none;
  font-size: 20px;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: #555;
}
.nav-wrapper {
  text-align: center;
  margin: 5px auto 50px;
}
.nav {
  display: inline-block;
  width: 65px;  
  border-radius: 5%;
  background: #fff;
  cursor: pointer;
}
.nav a {
  text-decoration: none;
  color: #555;
}
.nav:hover {
  outline: none;
  background-color: lightgrey;
  text-decoration: none;
  color: #555;
}
</style>