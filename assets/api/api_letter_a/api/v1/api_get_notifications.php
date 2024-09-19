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
    // Mendapatkan UserID dari data yang diterima
    $UserID = $input['UserID'];

    // Mengambil notifikasi dari database berdasarkan UserID
    $sql = "SELECT * FROM notifications WHERE UserID = ?";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("i", $UserID);
    $stmt->execute();
    $result = $stmt->get_result();

    $notifications = array();
    while ($row = $result->fetch_assoc()) {
        $notifications[] = array(
            'PushID' => $row['PushID'],
            'UserID' => $row['UserID'],
            'Message' => $row['Message'],
            'Tanggal' => $row['Tanggal'],
            'Pukul' => $row['Pukul'],
            'Judul' => $row['Judul'],
            'Thumbnail' => $row['Thumbnail']
        );
    }

    if (count($notifications) > 0) {
        $response = array(
            'status' => 'success',
            'notifications' => $notifications
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Tidak ada notifikasi ditemukan'
        );
    }

    echo json_encode($response);

    // Menutup koneksi
    $stmt->close();
} else {
    $response = array(
        'status' => 'error',
        'message' => 'Token tidak valid'
    );
    echo json_encode($response);
}

mysqli_close($koneksi);
?>
