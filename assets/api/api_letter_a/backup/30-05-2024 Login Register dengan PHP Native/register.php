<?php
require_once 'config.php';

// Mengambil data yang dikirim dari form
$username = $_POST['username'];
$password = $_POST['password'];
$fullName = $_POST['fullName'];
$placeOfBirth = $_POST['placeOfBirth'];
$dateOfBirth = $_POST['dateOfBirth'];
$email = $_POST['email'];
$whatsapp = $_POST['whatsapp'];
$facebook = $_POST['facebook'];
$instagram = $_POST['instagram'];
$linkedIn = $_POST['linkedIn'];
$role = $_POST['role'];

// Mengelola file gambar
$targetDir = "uploads/img/profile/"; // Direktori untuk menyimpan gambar
$targetFile = $targetDir . basename($_FILES["profileImage"]["name"]);
$uploadOk = 1;
$imageFileType = strtolower(pathinfo($targetFile,PATHINFO_EXTENSION));

// Cek apakah file gambar valid
if(isset($_POST["submit"])) {
    $check = getimagesize($_FILES["profileImage"]["tmp_name"]);
    if($check !== false) {
        echo "File adalah gambar - " . $check["mime"] . ".";
        $uploadOk = 1;
    } else {
        echo "File bukan gambar.";
        $uploadOk = 0;
    }
}

// Cek apakah file sudah ada
if (file_exists($targetFile)) {
    echo "Maaf, file sudah ada.";
    $uploadOk = 0;
}

// Cek ukuran file
if ($_FILES["profileImage"]["size"] > 500000) {
    echo "Maaf, ukuran file terlalu besar.";
    $uploadOk = 0;
}

// Izinkan hanya beberapa format file tertentu
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
&& $imageFileType != "gif" ) {
    echo "Maaf, hanya format JPG, JPEG, PNG & GIF yang diperbolehkan.";
    $uploadOk = 0;
}

// Cek apakah $uploadOk bernilai 0 karena terjadi kesalahan
if ($uploadOk == 0) {
    echo "Maaf, file tidak terunggah.";
// Jika semuanya baik, coba unggah file
} else {
    // Proses kompres dan ubah ukuran gambar
    $image = $_FILES["profileImage"]["tmp_name"];
    list($width_orig, $height_orig) = getimagesize($image);
    $ratio_orig = $width_orig / $height_orig;

    $new_width = 720;
    $new_height = 720 / $ratio_orig;

    // Buat gambar baru sesuai ukuran yang diinginkan
    $new_image = imagecreatetruecolor($new_width, $new_height);

    // Periksa jenis file gambar dan buat gambar sumber
    if ($imageFileType == "jpg" || $imageFileType == "jpeg") {
        $source = imagecreatefromjpeg($image);
    } elseif ($imageFileType == "png") {
        $source = imagecreatefrompng($image);
    } elseif ($imageFileType == "gif") {
        $source = imagecreatefromgif($image);
    } else {
        echo "Maaf, hanya format JPG, JPEG, PNG & GIF yang diperbolehkan.";
        $uploadOk = 0;
    }

    // Resample gambar ke ukuran baru
    imagecopyresampled($new_image, $source, 0, 0, 0, 0, $new_width, $new_height, $width_orig, $height_orig);

    // Simpan gambar ke direktori target
    $targetFile = $targetDir . time() . '.' . $imageFileType;
    if ($imageFileType == "jpg" || $imageFileType == "jpeg") {
        imagejpeg($new_image, $targetFile, 75); // Kompresi JPEG dengan kualitas 75%
    } elseif ($imageFileType == "png") {
        imagepng($new_image, $targetFile, 5); // Kompresi PNG dengan kompresi level 5
    } elseif ($imageFileType == "gif") {
        imagegif($new_image, $targetFile);
    }

    // Hapus gambar sumber
    imagedestroy($new_image);
    imagedestroy($source);

    if ($uploadOk) {
        echo "File berhasil diunggah.";

        // Menyimpan data ke database
        $sql = "INSERT INTO users (username, password, fullName, placeOfBirth, dateOfBirth, email, whatsapp, facebook, instagram, linkedIn, role, profileImage) 
        VALUES ('$username', '$password', '$fullName', '$placeOfBirth', '$dateOfBirth', '$email', '$whatsapp', '$facebook', '$instagram', '$linkedIn', '$role', '$targetFile')";
        if(mysqli_query($koneksi, $sql)){
            echo "Registrasi berhasil.";
        } else{
            echo "ERROR: Tidak bisa mengeksekusi perintah $sql. " . mysqli_error($koneksi);
        }
    } else {
        echo "Maaf, terjadi kesalahan saat mengunggah file.";
    }
}

// Menutup koneksi
mysqli_close($koneksi);
?>
