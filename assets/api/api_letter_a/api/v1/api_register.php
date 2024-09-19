<?php
require_once 'config.php';

$input = json_decode(file_get_contents('php://input'), true);

$username = $input['username'];
$password = $input['password'];
$fullName = $input['fullName'];
$placeOfBirth = $input['placeOfBirth'];
$dateOfBirth = $input['dateOfBirth'];
$email = $input['email'];
$whatsapp = $input['whatsapp'];
$facebook = $input['facebook'];
$instagram = $input['instagram'];
$linkedIn = $input['linkedIn'];
$role = $input['role'];
$profileImage = $input['profileImage'];
$city = $input['city'];
$province = $input['province'];

// Cek apakah username atau email sudah ada
$check_sql = "SELECT * FROM users WHERE username='$username' OR email='$email'";
$check_result = mysqli_query($koneksi, $check_sql);
if (mysqli_num_rows($check_result) > 0) {
    // Jika username atau email sudah ada
    $response = array(
        'status' => 'error',
        'message' => 'Username atau email sudah terdaftar.'
    );
} else{
    // Proses upload gambar
    $targetDir = "uploads/img/profile/";
    $imageFileName = basename($profileImage['name']);
    $imageFileType = strtolower(pathinfo($imageFileName, PATHINFO_EXTENSION));
    $targetFile = $targetDir . $imageFileName;

    // Jika file sudah ada, tambahkan prefix '_xx'
    $counter = 1;
    while (file_exists($targetFile)) {
        $targetFile = $targetDir . pathinfo($imageFileName, PATHINFO_FILENAME) . '_' . $counter . '.' . $imageFileType;
        $counter++;
    }

    $imageData = base64_decode($profileImage['data']);

    // Simpan gambar ke server
    file_put_contents($targetFile, $imageData);

    // Menyimpan data ke database
    $sql = "INSERT INTO users (username, password, fullName, placeOfBirth, dateOfBirth, email, whatsapp, facebook, instagram, linkedIn, role, profileImage,  city, province) 
            VALUES ('$username', '$password', '$fullName', '$placeOfBirth', '$dateOfBirth', '$email', '$whatsapp', '$facebook', '$instagram', '$linkedIn', '$role', '$targetFile', '$city', '$province')";

    if(mysqli_query($koneksi, $sql)){
        $response = array(
            'status' => 'success',
            'message' => 'Registrasi berhasil.'
        );
    } else {
        $response = array(
            'status' => 'error',
            'message' => 'Registrasi gagal: ' . mysqli_error($koneksi)
        );
    }
}

echo json_encode($response);

// Menutup koneksi
mysqli_close($koneksi);
?>
