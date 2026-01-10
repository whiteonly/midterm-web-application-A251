SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- 1. Create Users Table (The Parent Table)
DROP TABLE IF EXISTS `tbl_users`;
CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(225) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_credit` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. Create Profile Table (1:1 relationship with user)
DROP TABLE IF EXISTS `tbl_profile`;
CREATE TABLE `tbl_profile` (
  `user_id` int(11) NOT NULL,
  `profile_img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Create Pets Table (linked to user)
DROP TABLE IF EXISTS `tbl_pets`;
CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` varchar(50) NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `age` int(2) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `health` varchar(20) NOT NULL,
  PRIMARY KEY (`pet_id`),
  FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL AUTO_INCREMENT,
  `pet_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `donation_type` enum('Money','Food','Medical') NOT NULL,
  `amount` decimal(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `donor_name` varchar(255) NOT NULL,
  `donor_email` varchar(255) NOT NULL,
  `donor_phone` varchar(20) NOT NULL,
  `donation_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`donation_id`),
  KEY `pet_id` (`pet_id`),
  KEY `user_id` (`user_id`),
  KEY `donation_date` (`donation_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. Create Adoption Requests Table
DROP TABLE IF EXISTS `tbl_adoptions`;
CREATE TABLE `tbl_adoptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `motivation` text NOT NULL,
  `update_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets`(`pet_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert sample user
INSERT INTO `tbl_users` (`user_id`, `email`, `name`, `password`, `phone`, `reg_date`) VALUES
(1, 'azri@gmail.com', 'azri', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0194444555', '2025-11-02 09:27:23.965748');

COMMIT;