# API接口文档

## 用户部门查询接口 (UserAPI.php)

### 部门列表查询
- 接口地址：`GET http://localhost/DailyReview/server/UserAPI.php?action=get_departments`
- 响应示例：
  ```json
  {
    "status": "success",
    "data": [
      {
        "id": 1, 
        "department_name": "技术部"
      },
      {
        "id": 2, 
        "department_name": "市场部"
      }
    ]
  }
  ```
- 错误响应：
  ```json
  {
    "status": "error",
    "message": "暂无部门数据"
  }
  ```


- 获取部门用户：`GET http://localhost/DailyReview/server/UserAPI.php?action=get_department_users&department_id=2`
  - 必选参数：`department_id`(部门ID)
  - 响应示例：
    ```json
    {
      "status": "success",
      "data": [
        {
          "partner_name": "张三",
          "position": "工程师",
          "department_name": "研发部"
        }
      ]
    }
    ```
  
### 接口参数说明
- 必填参数：
  - get_department_users: department_id
- 错误响应：
  ```json
  {
    "status": "error",
    "message": "缺少department_id参数"
  }
  ```

## 周目标接口 (WeekGoalAPI.php)
- 获取周目标：`GET/POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=get&department_id=2`
  - 必选参数：`department_id`(部门ID)
  - 响应示例：
    ```json
    [{
      "id": 1,
      "department_id": 2,
      "executor": "张三",
      "executor_id": 5,
      "weekly_goal": "完成用户模块开发",
      "createdate": 20231010,
      "mondayDate": 20231009,
      "partner_name": "张三",
      "department_name": "研发部"
    }]
    ```
- 创建周目标：`POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=create&executor_id=1&weekly_goal=完成项目模块开发&mondayDate=20231002`
- 更新周目标：`POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=update&id=1&weekly_goal=修改后的目标内容`
- 删除周目标：`POST http://localhost/DailyReview/server/WeekGoalAPI.php?action=delete&id=1`

## 每日目标接口 (DayGoalAPI.php)
- 获取目标：`GET/POST http://localhost/DailyReview/server/DayGoalAPI.php?action=get&date=2023-10-01`
- 创建目标：`POST http://localhost/DailyReview/server/DayGoalAPI.php?action=create&date=2023-10-01&executor_id=1&goal_content=完成用户登录模块`
- 更新目标：`POST http://localhost/DailyReview/server/DayGoalAPI.php?action=update&id=1&goal_content=修改后的内容&executor_id=2`
- 标记完成：`POST http://localhost/DailyReview/server/DayGoalAPI.php?action=complete&id=1`

## 每日任务接口 (DayTaskAPI.php)
- 获取任务：`GET/POST http://localhost/DailyReview/server/DayTaskAPI.php?action=get&date=2023-10-01`
- 创建任务：`POST http://localhost/DailyReview/server/DayTaskAPI.php?action=create&date=2023-10-01&executor_id=1&task_content=开发用户注册功能&time_spent=120`
- 更新进度：`POST http://localhost/DailyReview/server/DayTaskAPI.php?action=update&id=1&task_content=更新后的任务内容&progress=50&time_spent=180`
- 删除任务：`POST http://localhost/DailyReview/server/DayTaskAPI.php?action=delete&id=1`

## 接口规范详情

### 周目标接口参数说明
- 必填参数：
  - create: executor_id, weekly_goal, mondayDate
  - update: id, weekly_goal
- 响应格式示例：
  ```json
  {
    "status": "success",
    "data": {
      "id": 1,
      "weekly_goal": "完成项目模块开发",
      "mondayDate": "20231002"
    }
  }
  ```

### 每日目标接口参数说明
- 必填参数：
  - create: date, executor_id, goal_content
  - update: id, goal_content
- 响应格式示例：
  ```json
  {
    "status": "success",
    "data": {
      "id": 1,
      "goal_content": "完成用户登录模块",
      "is_completed": 0
    }
  }
  ```

### 每日任务接口参数说明
- 必填参数：
  - create: date, executor_id, task_content
  - update: id, task_content, progress
- 响应格式示例：
  ```json
  {
    "status": "success",
    "data": {
      "id": 1,
      "task_content": "开发用户注册功能",
      "time_spent": 120,
      "progress": 50
    }
  }
  ```

## 通用说明
1. 所有参数同时支持GET/POST方式传递
2. 数据返回格式为JSON（包含status字段表示操作状态，data字段包含操作结果）
3. 更新/删除操作需要POST方法
4. 日期格式：YYYY-MM-DD（日接口）/YYYYMMDD（周接口）
5. 测试前请确保服务器已配置正确数据库连接

## 错误响应示例
```json
{
  "status": "error",
  "message": "缺少必要参数: executor_id"
}
```