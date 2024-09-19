<?php
// Konfigurasi Database
define('DB_SERVER', 'srv1163.hstgr.io');
define('DB_USERNAME', 'u249363904_lettera');
define('DB_PASSWORD', 'Passwordlettera@33');
define('DB_NAME', 'u249363904_lettera');

// Membuat koneksi ke database
$koneksi = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Mengecek koneksi
if($koneksi === false){
    die("ERROR: Tidak bisa terhubung ke database. " . $koneksi->connect_error);
}
?>
