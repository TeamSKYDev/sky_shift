<template>
  
    <div>
      <router-view></router-view>
    </div>
  
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'

import CalendarIndex from 'CalendarIndex.vue'
import CalendarNew from 'CalendarNew.vue'

const router = new VueRouter({
  routes: [
    { path: '/',
      component: CalendarIndex  },
    { path: '/private_schedules/new',
      name: 'CalendarNew',
      component: CalendarNew },
  ]
})


Vue.use(VueRouter)

export default {
  router
}
</script>

<style>
</style>