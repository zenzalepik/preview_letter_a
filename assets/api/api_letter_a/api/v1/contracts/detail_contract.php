<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan ContractID dari data yang diterima
$token = $input['token'];
$contractID = $input['ContractID'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token' AND role='admin'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, ambil data kontrak dari database berdasarkan ContractID
    $sql = "SELECT * FROM contracts WHERE ContractID='$contractID'";
    $result = mysqli_query($koneksi, $sql);
    
    if (mysqli_num_rows($result) == 1) {
        $contract = mysqli_fetch_assoc($result);
        $response = array(
            'status' => 'success',
            'contract' => $contract
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Kontrak tidak ditemukan.'
        );
    }
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
