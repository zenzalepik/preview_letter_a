<?php
require_once 'config.php';

// Mengambil data yang dikirim dari form
$username = $_POST['username'];
$password = $_POST['password'];

// Mencocokkan data dengan database
$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = mysqli_query($koneksi, $sql);

// Mengecek apakah user ditemukan
// Mengecek apakah user ditemukan
if(mysqli_num_rows($result) == 1){
    // Mendapatkan informasi peran pengguna
    $row = mysqli_fetch_assoc($result);
    $role = $row['role'];
   
   // Start Session
   session_start();

    // Menyimpan data pengguna dalam sesi
   $_SESSION['username'] = $username;



    // Mengarahkan pengguna ke halaman profil
    header("Location: profile.php");
    exit(); // Penting untuk menghentikan eksekusi skrip setelah header("Location: ...")
 } else{
    echo "Username atau password salah.";
 }
 

// Menutup koneksi
mysqli_close($koneksi);
?>
