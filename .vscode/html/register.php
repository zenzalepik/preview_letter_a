<?php
require_once 'config.php';

// Mengambil data yang dikirim dari form
$username = $_POST['username'];
$password = $_POST['password'];

// Menyimpan data ke database
$sql = "INSERT INTO users (username, password) VALUES ('$username', '$password')";
if(mysqli_query($koneksi, $sql)){
    echo "Registrasi berhasil.";
} else{
    echo "ERROR: Tidak bisa mengeksekusi perintah $sql. " . mysqli_error($koneksi);
}

// Menutup koneksi
mysqli_close($koneksi);
?>
