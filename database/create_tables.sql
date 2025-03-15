-- 创建周任务表
CREATE TABLE weekly_goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    executor VARCHAR(50) NOT NULL,
    executor_id INT NOT NULL,
    weekly_goal TEXT NOT NULL,
    is_new_goal BOOLEAN DEFAULT FALSE,
    createdate int NOT NULL,
    mondayDate int NOT NULL comment '周一日期,通过这个判断出是否本周的周任务',
);

-- 创建日目标表
CREATE TABLE daily_goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    executor_id INT NOT NULL,
    goal_content TEXT NOT NULL,
    status TEXT DEFAULT "研发中",
    is_new_goal BOOLEAN DEFAULT FALSE
);

-- 创建当日任务表
CREATE TABLE daily_tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    executor_id INT NOT NULL,
    task_content TEXT NOT NULL,
    progress INT DEFAULT 0,
    time_spent DECIMAL(10, 2) DEFAULT 0,
    is_new_goal BOOLEAN DEFAULT FALSE
);

-- 创建部门表
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- 插入示例部门数据
INSERT INTO departments (department_name) VALUES
('研发部'),
('市场部'),
('人力资源部'),
('财务部'),
('客户服务部');

-- 插入示例数据
INSERT INTO weekly_tasks (month, week_number, project_group, manager, executor, executor_id, weekly_goal, launch_date, is_delayed, delay_reason, is_new_goal) VALUES
('2023-10', 1, 'Project A', '张三', '李四', 1001, '完成用户模块开发', '2023-10-07', FALSE, NULL, TRUE),
('2023-10', 2, 'Project B', '王五', '赵六', 1002, '优化系统性能', '2023-10-14', TRUE, '需求变更', FALSE);

INSERT INTO daily_goals (date, executor_id, goal_content, is_new_goal) VALUES
('2023-10-02', 1001, '完成用户注册功能开发', TRUE),
('2023-10-03', 1001, '修复登录模块bug', FALSE),
('2023-10-04', 1002, '优化数据库查询', TRUE);

INSERT INTO daily_tasks (date, executor_id, task_content, progress, time_spent, is_new_goal) VALUES
('2023-10-02', 1001, '开发用户注册接口', 80, 4, TRUE),
('2023-10-03', 1001, '修复登录验证bug', 100, 2, FALSE),
('2023-10-04', 1002, '优化用户查询SQL', 50, 3, TRUE);


-- 创建用户表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL,
    mode VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    position VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- 插入示例用户数据
INSERT INTO users (partner_name, mode, department_id, position, is_active) VALUES
INSERT INTO `users` (`id`, `partner_name`, `mode`, `department_id`, `position`, `is_active`) VALUES
(1, '杨杨', '拼搏模式', 13, '队长', 1),
(2, '郦一琦', '拼搏模式', 13, '助理', 1),
(3, '梅习勋', '正常模式', 13, '客服', 1),
(4, '杜佳琦', '正常模式', 13, '客服', 1),
(5, '蒋鑫', '正常模式', 13, '客服', 1),
(6, '徐丽琴', '正常模式', 13, '客服', 1),
(7, '刘志珍', '正常模式', 13, '客服', 1),
(8, '翁林涛', '正常模式', 13, '客服', 1),
(9, '赵艺徽', '正常模式', 13, '客服', 1),
(10, '徐缘康', '正常模式', 13, '客服', 1),
(11, '董陈刚', '拼搏模式', 1, '队长', 1),
(12, '郑燕飞', '拼搏模式', 1, '开发', 1),
(13, '王雪斌', '拼搏模式', 1, '测试', 1),
(14, '方旭', '拼搏模式', 1, '运维', 1),
(15, '陈苏熙', '拼搏模式', 2, '队长', 1),
(16, '曹方毅', '拼搏模式', 2, '开发', 1),
(17, '曹远浩', '拼搏模式', 2, '开发', 1),
(18, '李欣', '拼搏模式', 2, '开发', 1),
(19, '帅维城', '拼搏模式', 2, '开发', 1),
(20, '王威', '拼搏模式', 4, '队长', 1),
(21, '王斌', '拼搏模式', 4, '投手', 1),
(22, '张梁', '拼搏模式', 5, '队长', 1),
(23, '张锴楠', '拼搏模式', 5, 5, 1),
(24, '孙晓远', '拼搏模式', 6, '队长', 1),
(25, '章志雄', '拼搏模式', 7, '队长', 1),
(26, '杨秀玲', '正常模式', 8, '队长', 1),
(27, '何流芳', '正常模式', 8, '出纳', 1),
(28, '杨思涵', '正常模式', 8, 8, 1),
(29, '徐艳', '正常模式', 8, 8, 1),
(30, '潘楚涵', '正常模式', 8, 8, 1),
(31, '叶积建', '拼搏模式', 9, '跟进', 1),
(32, '王旭', '拼搏模式', 9, '风控', 1),
(33, '钱贵祥', '拼搏模式', 3, '队长', 1),
(34, '孔祥东', '拼搏模式', 3, '开发', 1),
(35, '王子金', '拼搏模式', 3, '开发', 1),
(36, '周杭民', '拼搏模式', 3, '开发', 1),
(37, '朱军丹', '拼搏模式', 3, '调研', 1),
(38, '王凯祥', '拼搏模式', 3, '调研', 1),
(39, '徐宜邦', '拼搏模式', 3, '调研', 1),
(40, '陶乐欣', '拼搏模式', 3, '调研', 1),
(41, '梁浩风', '拼搏模式', 10, '队长', 1),
(42, '钱星瑞', '正常模式', 1, '测试', 1),
(43, '王然', '正常模式', 1, '测试', 1),
(44, '朱唯冬', '正常模式', 1, '运维', 1),
(45, '谢国良', '正常模式', 2, '开发', 1),
(46, '梁嘉轩', '正常模式', 2, '开发', 1),
(47, '王子腾', '正常模式', 2, '开发', 1),
(48, '陶俊华', '正常模式', 2, '开发', 1),
(49, '刘肖', '正常模式', 4, '投手', 1),
(50, '王奖焱', '正常模式', 4, '投手', 1),
(51, '余佳浩', '正常模式', 4, '投手', 1),
(52, '张文俊', '正常模式', 4, '投手', 1),
(53, '占承帅', '正常模式', 4, '投手', 1),
(54, '朴曙明', '正常模式', 4, '投手', 1),
(55, '施晓虎', '正常模式', 4, '投手', 1),
(56, '杨楠', '正常模式', 5, '设计', 0),
(57, '朱靖恺', '正常模式', 5, '设计', 1),
(58, '解午刚', '正常模式', 5, '设计', 1),
(59, '左鹏', '正常模式', 5, '设计', 1),
(60, '陈凡希', '正常模式', 11, 11, 1),
(61, '童梅君', '正常模式', 6, 6, 1),
(62, '康琪琪', '正常模式', 6, 6, 1),
(63, '邵雨谦', '正常模式', 6, 6, 1),
(64, '王艺凝', '正常模式', 11, 11, 1),
(65, '张祎璇', '正常模式', 7, 7, 1),
(66, '朱清源', '正常模式', 8, 8, 1),
(67, '陈堯朴', '正常模式', 9, 9, 1),
(68, '董展', '正常模式', 3, '开发', 1),
(69, '梁超', '正常模式', 14, '商务', 1),
(70, '徐璠', '正常模式', 14, '数据', 1),
(71, '乃扎提', '正常模式', 4, '投手', 1),
(72, '秦涛', '正常模式', 3, '开发', 1),
(73, '李卓浩', '正常模式', 3, '开发', 1);