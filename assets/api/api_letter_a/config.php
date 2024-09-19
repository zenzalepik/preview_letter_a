<?php
// Konfigurasi Database
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'u249363904_lettera');

// Membuat koneksi ke database
$koneksi = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Mengecek koneksi
if($koneksi === false){
    die("ERROR: Tidak bisa terhubung ke database. " . $koneksi->connect_error);
}
?>
