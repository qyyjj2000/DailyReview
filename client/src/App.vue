<template>
  <div id="app">
    <nav class="nav-container">
      <router-link 
        v-for="(nav, index) in navList" 
        :key="index" 
        :to="nav.path"
        class="nav-btn"
        active-class="active-link"
      >
        {{ nav.title }}
      </router-link>
    </nav>
    <router-view class="main-content"/>
  </div>
</template>

<script>
import memoryStore from '@/utils/memoryStore'
import request from '@/utils/request'

export default {
  created() {
    // 获取当前部门ID
    const departmentId = localStorage.getItem('department_id_cache',"2")
    // const departmentId = memoryStore.get('department_id_cache') || 2
    

    // 获取部门用户数据
    request.get(`/UserAPI.php?action=get_department_users&department_id=${departmentId}`)
      .then(response => {
        memoryStore.set(`department_users_cache_${departmentId}`, response.data)
      })
      .catch(error => {
        console.error('部门用户数据获取失败:', error)
      })
  },
  data() {
    return {
      navList: [
        { title: '项目组周目标', path: '/week-goal' },
        { title: '个人日目标', path: '/daily-goal' },
        { title: '部门管理', path: '/depart-mgr' }
      ]
    }
  }
}
</script>

<style>
.nav-container {
  display: flex;
  padding: 15px;
  align-self: center;
  background: #f5f5f5;
  width: auto;
  margin-bottom: 20px;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}

.nav-btn {
  padding: 10px 20px;
  margin-right: 15px;
  border-radius: 4px;
  background: #409eff;
  color: white;
  text-decoration: none;
  transition: all 0.3s;
}

.active-link {
  background: #337ecc;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.main-content {
  margin: 0 auto;
  padding: 0 20px;
}
</style>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
