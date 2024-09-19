<?php
// Konfigurasi Database
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'username_database');
define('DB_PASSWORD', 'password_database');
define('DB_NAME', 'nama_database');

// Membuat koneksi ke database
$koneksi = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Mengecek koneksi
if($koneksi === false){
    die("ERROR: Tidak bisa terhubung ke database. " . $koneksi->connect_error);
}
?>
