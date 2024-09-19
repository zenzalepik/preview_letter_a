<?php
$servername = "localhost"; // Ganti dengan alamat server database Anda
$username = "id22257361_lettera";        // Ganti dengan username database Anda
$password = "F@cebookbaru33";            // Ganti dengan password database Anda
$dbname = "id22257361_lettera"; // Ganti dengan nama database Anda

// Membuat koneksi
$koneksi = mysqli_connect($servername, $username, $password, $dbname);

// Mengecek koneksi
if (!$koneksi) {
    die("Koneksi gagal: " . mysqli_connect_error());
}
?>


<!--<?php
// $servername = "localhost";
// $username = "root";
// $password = "";
// $dbname = "u249363904_lettera";


// $koneksi = mysqli_connect($servername, $username, $password, $dbname);


// if (!$koneksi) {
//     die("Koneksi gagal: " . mysqli_connect_error());
// }
?>
-->