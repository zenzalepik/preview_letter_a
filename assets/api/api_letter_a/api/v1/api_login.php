<?php
require_once 'config.php';

// Mendapatkan data yang dikirim dari Flutter
$input = json_decode(file_get_contents('php://input'), true);

// Mengambil username dan password dari data yang diterima
$username = $input['username'];
$password = $input['password'];

// Mencocokkan data dengan database
$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = mysqli_query($koneksi, $sql);

// Mengecek apakah user ditemukan
if(mysqli_num_rows($result) == 1){
    // Mendapatkan informasi peran pengguna
    $row = mysqli_fetch_assoc($result);
    $role = $row['role'];
    
    // Generate token
    $token = bin2hex(random_bytes(32)); // Token unik
    
    // Menyimpan token dalam database
    $update_sql = "UPDATE users SET token='$token' WHERE username='$username'";
    mysqli_query($koneksi, $update_sql);

    // Mencetak respons ke konsol
    $response = array(
        'status' => 'success',
        'role' => $role,
        'token' => $token
    );
    echo json_encode($response);
    error_log("Login successful: " . json_encode($response)); // Cetak respons ke konsol
} else {
    // Jika user tidak ditemukan, mengirim respons ke Flutter
    $response = array(
        'status' => 'error',
        'message' => 'Username atau password salah.'
    );
    echo json_encode($response);
    error_log("Login failed: " . json_encode($response)); // Cetak respons ke konsol
}

// Menutup koneksi
mysqli_close($koneksi);
?>
