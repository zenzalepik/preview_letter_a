<?php
require_once 'config.php';

// Atur header CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Tangani permintaan OPTIONS
    http_response_code(200);
    exit();
}

function verifyToken($token) {
    // Implementasi verifikasi token Anda di sini
    // Misalnya, Anda bisa mendekode token JWT atau mengecek token di database
    return true; // Asumsikan token valid untuk contoh ini
}

$headers = apache_request_headers();
$authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : null;

if ($authHeader && preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
    $token = $matches[1];
    if (verifyToken($token)) {
        // Token valid, lanjutkan dengan mengambil data
        $sql = "SELECT placeOfBirth AS city, province, COUNT(*) AS user_count 
                FROM users 
                WHERE role='VA' 
                GROUP BY placeOfBirth, province";
        $result = mysqli_query($koneksi, $sql);
        $data = [];

        while ($row = mysqli_fetch_assoc($result)) {
            $data[] = $row;
        }

        echo json_encode($data);
    } else {
        http_response_code(401);
        echo json_encode(['message' => 'Invalid token']);
    }
} else {
    http_response_code(401);
    echo json_encode(['message' => 'Unauthorized']);
}

mysqli_close($koneksi);
?>
