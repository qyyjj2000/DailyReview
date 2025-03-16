import { createRouter, createWebHashHistory } from 'vue-router'
import WeekGoal from '../views/WeekGoal.vue'
import DailyGoal from '../views/DailyGoal.vue'
import DepartMgr from '../views/DepartMgr.vue'

const routes = [
  { path: '/week-goal', component: WeekGoal },
  { path: '/daily-goal', component: DailyGoal },
  { path: '/depart-mgr', component: DepartMgr },
  { path: '/', redirect: '/week-goal' }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router