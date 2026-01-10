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
  `user_credit` int(11) NOT NULL DEFAULT '0'
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


-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2025 at 08:19 AM
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
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` INT NOT NULL,
  `user_id` INT  NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` TEXT NOT NULL,
  `image_paths` varchar(50) NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng`varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `age` int(2) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `health` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);
ALTER TABLE `tbl_pets` add foreign key (user_id) references tbl_users(user_id);

ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

-- Create adoption requests table
CREATE TABLE `tbl_adoptions` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `pet_id` INT NOT NULL,
  `submission_id` INT NOT NULL,
  `motivation` TEXT NOT NULL,
  `update_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets`(`pet_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
-- Add primary keys to existing tables if not already added
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  MODIFY `pet_id` INT NOT NULL AUTO_INCREMENT;

ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  MODIFY `user_id` INT NOT NULL AUTO_INCREMENT;

-- Add foreign key to tbl_pets
ALTER TABLE `tbl_pets`
  ADD FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`) ON DELETE CASCADE;

CREATE TABLE `tbl_profile` (
  `user_id`     INT(11) NOT NULL,
  `profile_img` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),                       -- one row per user
  FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`)
             ON DELETE CASCADE
             ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;