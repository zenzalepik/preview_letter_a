<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan data aplikasi dari data yang diterima
$token = $input['token'];
$userID = $input['UserID'];
$vaid = $input['Vaid'];
$clientID = $input['ClientID'];
$status = $input['Status'];
$tanggalPengajuan = $input['TanggalPengajuan'];
$title = $input['Title'];
$description = $input['Description'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token' AND role='admin'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, simpan data aplikasi ke database
    $sql = "INSERT INTO applications (UserID, Vaid, ClientID, Status, TanggalPengajuan, Title, Description)
            VALUES ('$userID', '$vaid', '$clientID', '$status', '$tanggalPengajuan', '$title', '$description')";

    if (mysqli_query($koneksi, $sql)) {
        $response = array(
            'status' => 'success',
            'message' => 'Aplikasi berhasil disimpan.'
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Gagal menyimpan aplikasi.'
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
