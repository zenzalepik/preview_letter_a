<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dari data yang diterima
$token = $input['token'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, ambil data aplikasi dari database
    $sql = "SELECT * FROM applications";
    $applicationsResult = mysqli_query($koneksi, $sql);

    $applications = array();
    while ($row = mysqli_fetch_assoc($applicationsResult)) {
        $applications[] = $row;
    }

    $response = array(
        'status' => 'success',
        'applications' => $applications
    );
} else {
    $response = array(
        'status' => 'error',
        'message' => 'Token tidak valid atau pengguna tidak ditemukan.'
    );
}

echo json_encode($response);

// Menutup koneksi
mysqli_close($koneksi);
?>
