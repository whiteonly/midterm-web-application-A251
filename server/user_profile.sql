CREATE TABLE `tbl_profile` (
  `user_id`     INT(11) NOT NULL,
  `profile_img` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`),                       -- one row per user
  FOREIGN KEY (`user_id`) REFERENCES `tbl_users`(`user_id`)
             ON DELETE CASCADE
             ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;