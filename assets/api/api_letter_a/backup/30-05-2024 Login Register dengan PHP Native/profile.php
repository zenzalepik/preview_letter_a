<?php
session_start();
if(!isset($_SESSION['username'])){
    header("Location: login.php");
    exit();
}

require_once 'config.php';

$username = $_SESSION['username'];
$sql = "SELECT * FROM users WHERE username='$username'";
$result = mysqli_query($koneksi, $sql);

if(mysqli_num_rows($result) == 1){
    $row = mysqli_fetch_assoc($result);

    echo "Selamat datang, " . $row['fullName'] . "!<br>";
    echo "Username: " . $row['username'] . "<br>";
    echo "Tempat Lahir: " . $row['placeOfBirth'] . "<br>";
    echo "Tanggal Lahir: " . $row['dateOfBirth'] . "<br>";
    echo "Email: " . $row['email'] . "<br>";
    echo "WhatsApp: " . $row['whatsapp'] . "<br>";
    echo "Facebook: " . $row['facebook'] . "<br>";
    echo "Instagram: " . $row['instagram'] . "<br>";
    echo "LinkedIn: " . $row['linkedIn'] . "<br>";
    echo "Role: " . $row['role'] . "<br>";
    echo "<img src='" . $row['profileImage'] . "'><br>";

    // Form untuk mengupdate informasi profil
    echo "<form action='update_profile.php' method='post' enctype='multipart/form-data'>";
    echo "Nama Lengkap: <input type='text' name='fullName' value='" . $row['fullName'] . "'><br>";
    echo "Gambar Profil: <input type='file' name='profileImage'><br>";
    // Tambahkan input untuk informasi profil lainnya
    // ...
    echo "<input type='submit' name='submit' value='Update Profil'>";
    echo "</form>";

    echo "<a href='logout.php'>Logout</a>";
} else {
    echo "Gagal memuat informasi pengguna.";
}

mysqli_close($koneksi);
?>
