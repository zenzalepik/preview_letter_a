<?php
require_once 'config.php';

// Mendapatkan parameter pencarian dari request
$search = isset($_GET['search']) ? $_GET['search'] : '';

// Query untuk mencari pengguna dengan peran 'va' berdasarkan nama
$sql = "SELECT fullName, profileImage, rating FROM users WHERE role = 'va' AND fullName LIKE '%$search%'";
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
