<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan data pembayaran dari data yang diterima
$token = $input['token'];
$contractID = $input['ContractID'];
$amount = $input['Amount'];
$paymentDate = $input['PaymentDate'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token' AND role='admin'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, simpan data pembayaran ke database
    $sql = "INSERT INTO payments (ContractID, Amount, PaymentDate)
            VALUES ('$contractID', '$amount', '$paymentDate')";

    if (mysqli_query($koneksi, $sql)) {
        $response = array(
            'status' => 'success',
            'message' => 'Pembayaran berhasil disimpan.'
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Gagal menyimpan pembayaran.'
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
