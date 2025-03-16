<template>
  <div class="depart-mgr">
    <h2>系统设置</h2>
    <div class="filter-container">
      <el-select 
        v-model="selectedDepartment"
        placeholder="请选择部门"
        @change="handleDepartmentChange"
      >
        <el-option
          v-for="dept in departments"
          :key="dept.id"
          :label="dept.department_name"
          :value="dept.id"
        />
      </el-select>
    </div>
    
    <el-table :data="userList" border style="width: 100%; margin-top: 20px">
      <el-table-column prop="partner_name" label="伙伴名称" width="180" />
      <el-table-column prop="department_name" label="部门名称" />
      <el-table-column prop="position" label="职位" />
    </el-table>
  </div>
</template>

<script>
import memoryStore from '@/utils/memoryStore'
import request from '@/utils/request'

export default {
  name: 'DepartMgr',
  data() {
    return {
      departments: [],
      selectedDepartment: 2,
      userList: []
    }
  },
  created() {
    this.initDepartmentData()
    this.loadUsers()
  },
  methods: {
    async initDepartmentData() {
      try {
        const { data } = await request.get('/UserAPI.php?action=get_departments')
        console.log('部门接口原始数据:', data)
        this.departments = Array.isArray(data) ? data : data.data
        this.departments = this.departments.map(dept => ({
          id: dept.id || Date.now(),
          department_name: dept.department_name || '未命名部门'
        }))
        this.selectedDepartment = localStorage.getItem('department_id_cache',"2")//memoryStore.get('department_id_cache') || 2
      } catch (error) {
        console.error('部门数据加载失败:', error)
      }
    },
    async loadUsers() {

      let dp_id = localStorage.getItem('department_id_cache',"2")
      const cachedData = memoryStore.get(`department_users_cache_${dp_id}`)
      
      if (cachedData) {
        this.userList = Array.isArray(cachedData) ? cachedData : cachedData.data
        console.log('从缓存中加载用户数据:', this.userList)
        return
      }

      try {
        const { data } = await request.get(
          `/UserAPI.php?action=get_department_users&department_id=${dp_id}`
        )
        const safeData = Array.isArray(data) ? data : data.data
        this.userList = safeData
        console.log('从接口加载用户数据:', this.userList)
        memoryStore.set(`department_users_cache_${dp_id}`, safeData)
      } catch (error) {
        console.error('用户数据加载失败:', error)
      }
    },
    handleDepartmentChange(newVal) {
      // memoryStore.set('department_id_cache', newVal)
      localStorage.setItem('department_id_cache',newVal)
      this.loadUsers()
    }
  }
}
</script>

<style scoped>
.depart-mgr {
  padding: 20px;
  background: #f8fafc;
  min-height: 100vh;
  width: 100%;
}

.layout-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 20px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
}
.filter-container {
  margin-bottom: 20px;
}
.el-select {
  width: 300px;
}
</style>