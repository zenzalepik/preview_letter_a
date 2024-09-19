-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 30, 2024 at 01:35 PM
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
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `placeOfBirth` varchar(100) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `facebook` varchar(100) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `linkedIn` varchar(100) DEFAULT NULL,
  `role` enum('admin','user','va') NOT NULL,
  `profileImage` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullName`, `placeOfBirth`, `dateOfBirth`, `email`, `whatsapp`, `facebook`, `instagram`, `linkedIn`, `role`, `profileImage`, `created_at`) VALUES
(1, 'mzm', 'm', 'MZM', 'jj', '2024-05-31', 'mzainulmuttaqin@outlook.com', '90909090', 'jkljljkljkl', 'jkljkljkljkl', 'kjljkjkl', 'va', 'uploads/img/profile/Screenshot from 2024-02-27 16-20-58.png', '2024-05-30 12:54:30'),
(2, 'z', 'm', 'MZM', 'jj', '2024-05-31', 'mzainulmuttaqin@outlook.com', '90909090', 'jkljljkljkl', 'jkljkljkljkl', 'kjljkjkl', 'va', 'uploads/img/profile/jk.png', '2024-05-30 12:55:32'),
(3, 'j', 'j', 'j', 'j', '2024-05-31', 'm@k.m', '808080', 'jkl', 'jkl', 'jl', 'va', 'uploads/img/profile/1717075074.png', '2024-05-30 13:17:54');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
