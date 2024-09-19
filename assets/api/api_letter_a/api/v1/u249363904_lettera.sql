-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 13, 2024 at 12:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u249363904_lettera`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `ApplicationID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Vaid` int(11) DEFAULT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `Status` enum('pending','accepted','rejected') DEFAULT NULL,
  `TanggalPengajuan` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `PushID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Tanggal` date DEFAULT NULL,
  `Pukul` time DEFAULT NULL,
  `Judul` varchar(255) DEFAULT NULL,
  `Thumbnail` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `placeOfBirth` varchar(100) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `facebook` varchar(100) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `linkedIn` varchar(100) DEFAULT NULL,
  `role` enum('admin','user','va','client') NOT NULL,
  `profileImage` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `token` varchar(255) DEFAULT NULL,
  `rating` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullName`, `placeOfBirth`, `city`, `province`, `dateOfBirth`, `email`, `whatsapp`, `facebook`, `instagram`, `linkedIn`, `role`, `profileImage`, `created_at`, `token`, `rating`) VALUES
(1, 'mzm', 'm', 'MZM', 'jj', NULL, NULL, '2024-05-31', 'mzainulmuttaqin@outlook.com', '90909090', 'jkljljkljkl', 'jkljkljkljkl', 'kjljkjkl', 'va', 'uploads/img/profile/Screenshot from 2024-02-27 16-20-58.png', '2024-05-30 12:54:30', '4ec69f4f12794cf92614c0c5c28ec6cbc2a7ae51e80444f1d526d227b9140f7d', NULL),
(2, 'z', 'm', 'MZM', 'jj', NULL, NULL, '2024-05-31', 'mzainulmuttaqin@outlook.com', '90909090', 'jkljljkljkl', 'jkljkljkljkl', 'kjljkjkl', 'va', 'uploads/img/profile/jk.png', '2024-05-30 12:55:32', NULL, NULL),
(3, 'j', 'j', 'j', 'j', NULL, NULL, '2024-05-31', 'm@k.m', '808080', 'jkl', 'jkl', 'jl', 'va', 'uploads/img/profile/1717075074.png', '2024-05-30 13:17:54', '972c2dc84b6b8835774a64f4cd0d0f47c32a3a0893cf697eb75866f6d6c6a6b4', NULL),
(4, 'o', 'o', 'ooo', 'j', NULL, NULL, '2024-05-31', 'jjjj@k.com', 'huyyuy', 'uyyuyu', 'uyuy', 'uyuyyu', 'va', 'uploads/img/profile/1717087099.png', '2024-05-30 16:38:19', NULL, NULL),
(5, 'ii', 'i', 'iii', 'j', NULL, NULL, '2024-05-31', 'jjjj@k.com', 'huyyuy', 'uyyuyu', 'uyuy', 'uyuyyu', 'va', 'uploads/img/profile/1717087156.png', '2024-05-30 16:39:16', 'f26afbb87c2a2506238cb09d714b009ed3c5dc6bb6b21c11fb96b18c40d12f6d', NULL),
(6, 'pp', 'p', 'ytyt', 'uuuiui', NULL, NULL, '2024-05-31', 'g@hj.m', '354354', 'yu', 'ty', 'ty', 'va', 'uploads/img/profile/logo_letter_a.png', '2024-05-31 00:04:11', NULL, NULL),
(7, 'pp', 'p', 'ytyt', 'uuuiui', NULL, NULL, '2024-05-31', 'g@hj.m', '354354', 'yu', 'ty', 'ty', 'va', 'uploads/img/profile/logo_letter_a_1.png', '2024-05-31 00:04:21', NULL, NULL),
(8, 'pp', 'p', 'ytyt', 'uuuiui', NULL, NULL, '2024-05-31', 'g@hj.m', '354354', 'yu', 'ty', 'ty', 'va', 'uploads/img/profile/logo_letter_a_2.png', '2024-05-31 00:04:27', NULL, NULL),
(9, 'fyyr', 'io', 'iuo', 'ui', 'Jombang', 'Jatim', '2024-05-31', 'h@j.k', '789', 'jkhk', 'jjk', 'j', 'va', 'uploads/img/profile/k_9.png', '2024-05-31 01:12:13', NULL, NULL),
(10, 'fyyra', 'io', 'iuo', 'ui', 'Jombang', 'Jatim', '2024-05-31', 'ah@j.k', '789', 'jkhk', 'jjk', 'j', 'user', 'uploads/img/profile/k_11.png', '2024-05-31 01:13:50', NULL, NULL),
(11, 'mm', 'mm', 'm', 'm', 'jhjh', 'fgh', '2024-05-31', 'gh@h.c', '676', 'rgg', 'fhf', 'ghg', 'va', 'uploads/img/profile/k_16.png', '2024-05-31 09:10:45', '73ee847c0cdcec7dff84186b523835c6492b773b9ccceb528815410a84d7d5aa', NULL),
(12, 'nn', 'nn', 'm', 'm', 'jhjh', 'fgh', '2024-05-31', 'ghgh@h.co', '676', 'rgg', 'fhf', 'ghg', 'va', 'uploads/img/profile/k_17.png', '2024-05-31 09:11:42', '7612564160d5ad0702a77409480560746626465e243a084ba84a617dfb1e213a', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`ApplicationID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `Vaid` (`Vaid`),
  ADD KEY `ClientID` (`ClientID`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`PushID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `ApplicationID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `PushID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`Vaid`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `applications_ibfk_3` FOREIGN KEY (`ClientID`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
