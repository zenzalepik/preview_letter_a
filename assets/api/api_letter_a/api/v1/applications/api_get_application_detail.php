<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mendapatkan token dan ApplicationID dari data yang diterima
$token = $input['token'];
$applicationID = $input['ApplicationID'];

// Mencocokkan token dengan database
$sql = "SELECT * FROM users WHERE token='$token'";
$result = mysqli_query($koneksi, $sql);

if (mysqli_num_rows($result) == 1) {
    // Token valid, melanjutkan untuk mendapatkan detail aplikasi
    $sql = "SELECT * FROM applications WHERE ApplicationID='$applicationID'";
    $result = mysqli_query($koneksi, $sql);

    if (mysqli_num_rows($result) == 1) {
        $row = mysqli_fetch_assoc($result);

        $response = array(
            'status' => 'success',
            'ApplicationID' => $row['ApplicationID'],
            'UserID' => $row['UserID'],
            'Vaid' => $row['Vaid'],
            'ClientID' => $row['ClientID'],
            'Status' => $row['Status'],
            'TanggalPengajuan' => $row['TanggalPengajuan']
            'Title' => $row['Title'],
            'Description' => $row['Description'],
        );
        echo json_encode($response);
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Application not found.'
        );
        echo json_encode($response);
    }
} else {
    $response = array(
        'status' => 'error',
        'message' => 'Token tidak valid atau pengguna tidak ditemukan.'
    );
    echo json_encode($response);
}

// Menutup koneksi
mysqli_close($koneksi);
?>
