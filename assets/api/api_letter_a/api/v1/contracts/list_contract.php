<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan data kontrak dari data yang diterima
$token = $input['token'];
$userID = $input['UserID'];
$vaid = $input['Vaid'];
$title = $input['Title'];
$tanggalMulai = $input['TanggalMulai'];
$tanggalBerakhir = $input['TanggalBerakhir'];
$gaji = $input['Gaji'];
$deskripsiPekerjaan = $input['DeskripsiPekerjaan'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token' AND role='admin'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Jika token valid, simpan data kontrak ke database
    $sql = "INSERT INTO contracts (UserID, Vaid, Title, TanggalMulai, TanggalBerakhir, Gaji, DeskripsiPekerjaan)
            VALUES ('$userID', '$vaid', '$title', '$tanggalMulai', '$tanggalBerakhir', '$gaji', '$deskripsiPekerjaan')";

    if (mysqli_query($koneksi, $sql)) {
        $response = array(
            'status' => 'success',
            'message' => 'Kontrak berhasil disimpan.'
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Gagal menyimpan kontrak.'
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
