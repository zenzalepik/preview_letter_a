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
    $UserID = $input['UserID'];
    $Message = $input['Message'];
    $Tanggal = $input['Tanggal'];
    $Pukul = $input['Pukul'];
    $Judul = $input['Judul'];
    $Thumbnail = $input['Thumbnail'];

    // Insert notifikasi baru ke database
    $sql = "INSERT INTO notifications (UserID, Message, Tanggal, Pukul, Judul, Thumbnail) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("isssss", $UserID, $Message, $Tanggal, $Pukul, $Judul, $Thumbnail);
    
    if ($stmt->execute()) {
        $response = array(
            'status' => 'success',
            'message' => 'Notifikasi berhasil ditambahkan.'
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Gagal menambahkan notifikasi.'
        );
    }

    echo json_encode($response);

    // Menutup koneksi
    $stmt->close();
} else {
    $response = array(
        'status' => 'error',
        'message' => 'Token tidak valid atau akses ditolak.'
    );
    echo json_encode($response);
}

mysqli_close($koneksi);
?>
