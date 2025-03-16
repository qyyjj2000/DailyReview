<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

require_once 'db_connect.php';

$action = $_REQUEST['action'] ?? '';

switch ($action) {
    case 'get_departments':
        try {
            $stmt = $conn->query("SELECT id, department_name FROM departments ORDER BY id");
            $departments = $stmt->fetchAll(PDO::FETCH_ASSOC);

            if (count($departments) > 0) {
                echo json_encode([
                    'status' => 'success',
                    'data' => $departments
                ]);
            } else {
                http_response_code(404);
                echo json_encode(['status' => 'error', 'message' => '暂无部门数据']);
            }
        } catch(PDOException $e) {
            error_log('['.date('Y-m-d H:i:s').'] UserAPI错误: '.$e->getMessage()."\n", 3, 'error.log');
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => '部门数据获取失败']);
            exit;
        }
        break;

    case 'get_department_users':
        $departmentId = $_GET['department_id'] ?? '';
        
        if (empty($departmentId)) {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => '缺少department_id参数']);
            exit;
        }

        try {
            $stmt = $conn->prepare("SELECT 
                    u.partner_name, 
                    u.position, 
                    d.department_name
                FROM users u
                INNER JOIN departments d ON u.department_id = d.id
                WHERE d.id = :department_id AND u.is_active = 1");
            $stmt->bindParam(':department_id', $departmentId, PDO::PARAM_INT);
            $stmt->execute();
            $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch(PDOException $e) {
            error_log('['.date('Y-m-d H:i:s').'] UserAPI错误: '.$e->getMessage()."\n", 3, 'error.log');
            http_response_code(500);
            echo json_encode(['status' => 'error', 'message' => '数据库查询失败']);
            exit;
        }

        if (count($users) > 0) {
            echo json_encode([
                'status' => 'success',
                'data' => $users
            ]);
        } else {
            http_response_code(404);
            echo json_encode(['status' => 'error', 'message' => '未找到相关用户']);
        }
        break;

    default:
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => '无效的action参数']);
        break;
}

$conn = null;
?>