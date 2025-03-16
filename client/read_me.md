# 周日任务校对系统

## 系统级别说明
系统架构
A. 添加路由设置 
B.App.vue改造
1. 顶部导航栏中添加对应的导航按钮，点击的时候能够完成页面切换
2. 帮我搭建基础框架, 我只需要写业务逻辑, 如基础表格、卡片控件、按钮样式、HTTP请求模块(/DailyReview/server/,域名可配置)
3. 主要3个模块，顶部导航栏 - 项目组周目标-WeekGoal.vue、个人日目标&日任务-DailyGoal.vue、部门管理-DepartMgr.vue 分别创建出来





### 应用启动后，先获取当前部门的用户信息
> API 接口:  http://localhost/DailyReview/server/UserAPI.php?action=get_department_users&department_id=2
> department_id 从缓存中获取,缓存的key为 department_id_cache,取不到默认为2


### 模块-系统设置 DepartMgr.vue
### A. 列表
#### 1. const departmentId = memoryStore.get('department_id_cache') || 2 ; memoryStore.get(`department_users_cache_${departmentId}`) 获取缓存数据
#### 2. 如果数据不为空，加入列表数据，数据格式  伙伴名称-partner_name 部门名称-department_name  职位-position 
#### 3. 如果数据为空，API 接口:  http://localhost/DailyReview/server/UserAPI.php?action=get_department_users&department_id=departmentId ，获取数据，并缓存到本地，缓存的key为 department_users_cache_2
#### 4. 加入列表数据，数据格式  伙伴名称-partner_name 部门名称-department_name  职位-position 

### B. 切换部门
### 1. 列表顶部加入一个下拉框，下拉框中加入所有的部门信息
### 2. API参考接口:http://localhost/DailyReview/server/UserAPI.php?action=get_departments 
### 3. 把查询到的部门信息填充进入，用户选择部门后，把部门id缓存到本地，缓存的key为 department_id_cache
### 4. 切换部门后，重新获取当前部门的用户信息,PI 接口:  http://localhost/DailyReview/server/UserAPI.php?action=get_department_users&department_id=departmentId ，获取数据，并缓存到本地，缓存的key为 department_users_cache_departmentId(跟随着变化)
#### 5. 加入列表数据，数据格式  伙伴名称-partner_name 部门名称-department_name  职位-position 

> API 接口:  http://localhost/DailyReview/server/UserAPI.php?action=get_department_users&department_id=2
> department_id 从缓存中获取,缓存的key为 department_id_cache,取不到默认为2
### 3. 在下拉框后面显示当前部门的用户信息，'department_users_cache_'+departmentId, 缓存的key为 department_users_cache_2,获取本地缓存数据，并通过Table模式显示所有的用户信息
> 字段解析 伙伴名称-partner_name 部门名称-department_name  职位-position


## 模块-周目标
### 1. API参考接口
> 获取周目标：`GET/POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=get`
> 创建周目标：`POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=create&executor_id=1&weekly_goal=完成项目模块开发&mondayDate=20231002`
> 更新周目标：`POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=update&id=1&weekly_goal=修改后的目标内容`
> 删除周目标：`POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=delete&id=1`



### 2. 页面设计
> 获取周目标： 返回json数组,单个jsondata对象,{"id":1,"department_id":1,"executor":"张三","executor_id":1,"weekly_goal":"完成用户模块开发","is_new_goal":1,"createdate":20250303,"mondayDate":20250310,"partner_name":"杨杨","position":"队长","department_name":"技术"}
> 表格上方，加入一个新增按钮，点击后弹出新增周目标弹框
> 表格标题和表格内容 周目标-weekly_goal 执行人-executor   操作-(编辑、删除、异常)






