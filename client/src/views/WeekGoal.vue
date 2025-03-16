<template>
  <div class="container">
    <div class="header">
      <el-button type="primary" @click="showDialog = true">新增周目标</el-button>
    </div>
    
    <el-table :data="tableData" border style="width: 100%">
      
      <el-table-column prop="weekly_goal" label="周目标" width="300" />
      <el-table-column prop="executor" label="执行人" />
      <el-table-column prop="status" label="状态" />

      <el-table-column label="操作" width="220">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
          <el-button size="small" @click="handleException(scope.row)">异常</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="showDialog" title="新增周目标" width="30%">
      <el-form :model="formData" label-width="80px">
        <el-form-item label="执行人">
          <el-select v-model="formData.executor_id" placeholder="请选择">
            <el-option
              v-for="user in departmentUsers"
              :key="user.partner_id"
              :label="user.partner_name"
              :value="user.partner_id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="周目标">
          <el-input v-model="formData.weekly_goal" type="textarea" rows="3" />
        </el-form-item>
        <el-form-item label="起始周一">
          <el-date-picker
            v-model="formData.mondayDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYYMMDD"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import memoryStore from '@/utils/memoryStore'
import request from '@/utils/request'

const departmentId = memoryStore.get('department_id_cache') || 2
const departmentUsers = memoryStore.get(`department_users_cache_${departmentId}`) || []

const tableData = ref([])
const showDialog = ref(false)
const formData = ref({
  executor_id: null,
  weekly_goal: '',
  mondayDate: ''
})

const fetchWeekGoals = async () => {
  try {
    console.log('开始加载周目标数据...');
    let dp_id = localStorage.getItem('department_id_cache',"2")

    const { data } = await request.get('/WeekGoalAPI.php?action=get&department_id='+dp_id)
    console.log('周目标数据加载完成:', data)
    tableData.value = data.map(item => ({
      ...item,
      is_new_goal: String(item.is_new_goal)
    }))
    console.log('表格数据已更新，记录数：', tableData.value.length)
    memoryStore.set('week_goals_cache', data)
  } catch (error) {
    console.error('获取周目标失败:', error)
  }
}


// 编辑处理
const handleEdit = (row) => {
  showDialog.value = true
  formData.value = {
    id: row.id,
    executor_id: row.executor_id,
    weekly_goal: row.weekly_goal,
    mondayDate: row.mondayDate
  }
}

// 删除处理
const handleDelete = async (id) => {
  try {
    const response =  await request.post(`/WeekGoalAPI.php?action=delete&id=${id}`)
    console.log('删除周目标响应:', response)
    await fetchWeekGoals()
  } catch (error) {
    console.error('删除周目标失败:', error)
  }
}

// 异常处理
const handleException = async (row) => {
  try {
    let flag = row.is_new_goal === 1 ? 0 : 1
  
    const { data } = await request.get('/WeekGoalAPI.php?action=update&id='+row.id+'&is_new_goal='+flag)

    console.log('异常处理:', data)

    await fetchWeekGoals()
  } catch (error) {
    console.error('标记异常失败:', error)
  }
}

// 提交表单
const submitForm = async () => {
  try {
    const url = formData.value.id 
      ? '/WeekGoalAPI.php?action=update'
      : '/WeekGoalAPI.php?action=create'

    await request.post(url, formData.value)
    await fetchWeekGoals()
    showDialog.value = false
    formData.value = { executor_id: null, weekly_goal: '', mondayDate: '' }
  } catch (error) {
    console.error('操作失败:', error)
  }
}

// 初始化获取数据
onMounted(() => {
  fetchWeekGoals()
})
</script>

<style scoped>
.container {
  padding: 20px;
  width: 100%;
}
.header {
  margin-bottom: 20px;
}

/* 新增表格样式 */
:deep(.el-table) {
  margin-top: 15px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
}

:deep(.el-table__header th) {
  background-color: #f8f9fa;
  color: #606266;
  font-weight: 600;
}

:deep(.el-table__body tr:hover td) {
  background-color: #f5f7fa!important;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background-color: #fafafa;
}


/* 操作按钮间距 */
.el-button + .el-button {
  margin-left: 8px;
}

.el-button--danger {
  background-color: #ff6b6b;
  border-color: #ff6b6b;
}

/* 弹窗表单样式 */
:deep(.el-dialog) {
  border-radius: 8px;
}

:deep(.el-form-item) {
  margin-bottom: 22px;
}

:deep(.el-select),
:deep(.el-date-editor) {
  width: 100%;
}

:deep(.el-textarea__inner) {
  resize: vertical;
  min-height: 80px;
}
</style>