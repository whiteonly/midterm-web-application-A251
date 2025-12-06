-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
-- Host: 127.0.0.1
-- Generation Time: Nov 02, 2025 at 03:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal`
-- Table structure for table `tbl_users`
--
DROP TABLE IF EXISTS `tbl_users`;

CREATE TABLE tbl_users (
  `user_id` int(5) NOT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(225) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6) -- 'YYYY-MM-DD HH:MM:SS.UUUUUU'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
--anding data for table `tbl_users`
INSERT INTO tbl_users (`user_id`, `email`, `name`, `password`, `phone`, `reg_date`) VALUES
(1, 'azri@gmail.com', 'azri', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0194444555', '2025-11-02 09:27:23.965748');

--
-- Indexes for dumped tables
ALTER TABLE tbl_users
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE tbl_users
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT;-- AUTO_INCREMENT=1;
COMMIT;


