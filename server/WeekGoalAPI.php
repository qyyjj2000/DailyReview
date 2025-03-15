<?php
require __DIR__ . '/db_connect.php';

$action = $_REQUEST['action'] ?? '';

try {
    switch ($action) {
        case 'get':
            $mondayDate = date('Ymd', strtotime('monday this week'));
            $stmt = $conn->prepare("SELECT wg.*, u.partner_name, d.department_name 
                FROM weekly_goals wg
                INNER JOIN users u ON wg.executor_id = u.id
                INNER JOIN departments d ON wg.department_id = d.id
                WHERE mondayDate = ?");
            $stmt->execute([$mondayDate]);
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
            break;

        case 'create':
            $executor_id = $_POST['executor_id'];
            $weekly_goal = $_POST['weekly_goal'];
            $mondayDate = $_POST['mondayDate'];
            
            // 获取用户信息
            $userStmt = $conn->prepare("SELECT partner_name, department_id FROM users WHERE id = ?");
            $userStmt->execute([$executor_id]);
            $user = $userStmt->fetch(PDO::FETCH_ASSOC);

            $stmt = $conn->prepare("INSERT INTO weekly_goals (department_id, executor, executor_id, weekly_goal, createdate, mondayDate) 
                VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $user['department_id'],
                $user['partner_name'],
                $executor_id,
                $weekly_goal,
                date('Ymd'),
                $mondayDate
            ]);
            echo json_encode(['id' => $conn->lastInsertId()]);
            break;

        default:
            http_response_code(400);
            echo json_encode(['error' => '无效的操作类型']);
    }
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => '数据库操作失败: ' . $e->getMessage()]);
}