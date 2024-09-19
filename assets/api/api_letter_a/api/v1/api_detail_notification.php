<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan ID notifikasi dari data yang diterima
$token = $input['token'];
$notificationId = $input['notificationId'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, ambil detail notifikasi berdasarkan ID notifikasi
    $sql = "SELECT * FROM notifications WHERE PushID='$notificationId'";
    $notificationResult = mysqli_query($koneksi, $sql);

    if (mysqli_num_rows($notificationResult) == 1) {
        $notification = mysqli_fetch_assoc($notificationResult);

        $response = array(
            'status' => 'success',
            'notification' => array(
                'PushID' => $notification['PushID'],
                'UserID' => $notification['UserID'],
                'Message' => $notification['Message'],
                'Tanggal' => $notification['Tanggal'],
                'Pukul' => $notification['Pukul'],
                'Judul' => $notification['Judul'],
                'Thumbnail' => $notification['Thumbnail']
            )
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Notifikasi tidak ditemukan.'
        );
    }
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
