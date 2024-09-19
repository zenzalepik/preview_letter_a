<?php
require_once 'config.php';

// Query untuk mendapatkan semua pengguna dengan peran 'va'
$sql = "SELECT fullName, profileImage, rating FROM users WHERE role = 'va'";
$result = mysqli_query($koneksi, $sql);

if(mysqli_num_rows($result) > 0){
    $users = array();
    while($row = mysqli_fetch_assoc($result)){
        $users[] = $row;
    }

    $response = array(
        'status' => 'success',
        'users' => $users
    );
    echo json_encode($response);
} else {
    $response = array(
        'status' => 'error',
        'message' => 'Tidak ada pengguna dengan peran VA ditemukan.'
    );
    echo json_encode($response);
}

// Menutup koneksi
mysqli_close($koneksi);
?>
