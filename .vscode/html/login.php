<?php
require_once 'config.php';

// Mengambil data yang dikirim dari form
$username = $_POST['username'];
$password = $_POST['password'];

// Mencocokkan data dengan database
$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = mysqli_query($koneksi, $sql);

// Mengecek apakah user ditemukan
if(mysqli_num_rows($result) == 1){
    echo "Login berhasil.";
} else{
    echo "Username atau password salah.";
}

// Menutup koneksi
mysqli_close($koneksi);
?>
