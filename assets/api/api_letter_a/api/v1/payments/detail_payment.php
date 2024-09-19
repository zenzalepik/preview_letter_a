<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan PaymentID dari data yang diterima
$token = $input['token'];
$paymentID = $input['PaymentID'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token' AND role='admin'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, ambil data pembayaran dari database berdasarkan PaymentID
    $sql = "SELECT * FROM payments WHERE PaymentID='$paymentID'";
    $result = mysqli_query($koneksi, $sql);
    
    if (mysqli_num_rows($result) == 1) {
        $payment = mysqli_fetch_assoc($result);
        $response = array(
            'status' => 'success',
            'payment' => $payment
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Pembayaran tidak ditemukan.'
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
