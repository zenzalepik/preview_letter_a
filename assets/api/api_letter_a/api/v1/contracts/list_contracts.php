<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dari data yang diterima
$token = $input['token'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token' AND role='admin'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, ambil data kontrak dari database
    $sql = "SELECT * FROM contracts";
    $result = mysqli_query($koneksi, $sql);
    
    $contracts = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $contracts[] = $row;
    }
    
    $response = array(
        'status' => 'success',
        'contracts' => $contracts
    );
} else {
    $response = array(
        'status' => 'error',
        'message' => 'Token tidak valid atau pengguna tidak memiliki hak akses.'
    );
}

echo json_encode($response);

// Menutup koneksi
mysqli_close($koneksi);
?>
