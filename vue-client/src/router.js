import Vue from 'vue'
import VueRouter from 'vue-router'

import createPage from './components/CreatePage.vue'
import joinPage from './components/JoinPage.vue'
import keepList from './components/KeepList.vue'
import keepPage from './components/keepPage.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: joinPage
  },
  {
    path: '/create',
    name: 'create',
    component: createPage
  },
  {
    path: '/join',
    name: 'join',
    component: joinPage
  },
  {
    path: '/keep',
    name: 'keepList',
    component: keepList
  },
  {
    path: '/keep/:address',
    name: 'keepPage',
    component: keepPage,
    props: true
  }
]

export default new VueRouter({
  mode: 'history',
  routes
})