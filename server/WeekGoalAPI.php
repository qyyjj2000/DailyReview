<?php
header("Access-Control-Allow-Origin: http://localhost:5174");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");


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
            echo $executor_id;
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

        case 'update':
            $id = $_REQUEST['id'];
            $updateFields = [];
            $params = [];

            // 收集需要更新的字段
            if(!empty($_REQUEST['weekly_goal'])) {
                $updateFields[] = 'weekly_goal = ?';
                $params[] = $_REQUEST['weekly_goal'];
            }
            if(!empty($_REQUEST['executor_id'])) {
                $updateFields[] = 'executor_id = ?';
                $params[] = $_REQUEST['executor_id'];
            }
            if(!empty($_REQUEST['status'])) {
                $updateFields[] = 'status = ?';
                $params[] = intval($_REQUEST['status']);
            }
            if(!empty($_REQUEST['is_new_goal']) || $_REQUEST['is_new_goal'] === '0' || $_REQUEST['is_new_goal'] === '1') {

                $updateFields[] = 'is_new_goal = ?';
                $params[] = intval($_REQUEST['is_new_goal']);
            }

            // 参数有效性验证
            if(empty($updateFields)) {
                http_response_code(400);
                echo json_encode(['error' => '至少需要提供一个更新字段']);
                break;
            }

            // 构建动态SQL
            $sql = "UPDATE weekly_goals SET " . implode(', ', $updateFields) . " WHERE id = ?";
            $params[] = $id;

            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            echo json_encode(['updated' => $stmt->rowCount()]);
            break;

        case 'delete':
            $id = $_REQUEST['id'];
            $stmt = $conn->prepare("DELETE FROM weekly_goals WHERE id = ?");
            $stmt->execute([$id]);
            echo json_encode(['deleted' => $stmt->rowCount()]);
            break;

        default:
            http_response_code(400);
            echo json_encode(['error' => '无效的操作类型']);
    }
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => '数据库操作失败: ' . $e->getMessage()]);
}