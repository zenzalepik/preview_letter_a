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
    $row = mysqli_fetch_assoc($result);

    // Base URL for the images
    $base_url = 'http://localhost/zalepik/letter_a/uploads/img/profile/';

    $response = array(
        'status' => 'success',
        'fullName' => $row['fullName'],
        'username' => $row['username'],
        'placeOfBirth' => $row['placeOfBirth'],
        'dateOfBirth' => $row['dateOfBirth'],
        'email' => $row['email'],
        'whatsapp' => $row['whatsapp'],
        'facebook' => $row['facebook'],
        'instagram' => $row['instagram'],
        'linkedIn' => $row['linkedIn'],
        'role' => $row['role'],
        // Adding the base URL to the profile image path
        'profileImage' => $base_url . $row['profileImage']
    );
    echo json_encode($response);
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
