-- Disable foreign key checks for clean setup
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

-- Drop all existing tables in reverse dependency order
DROP TABLE IF EXISTS `cart_product`;
DROP TABLE IF EXISTS `order_product`;
DROP TABLE IF EXISTS `import_product`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `import`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `location_user`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `suppliers`;
DROP TABLE IF EXISTS `users`;

-- Create tables in correct dependency order
CREATE TABLE `categories` (
  `id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL,
  `url_image` varchar(255) NOT NULL,
  `banner` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `suppliers` (
  `id` varchar(36) NOT NULL,
  `name` text NOT NULL,
  `url_image` text NOT NULL,
  `phone` text NOT NULL,
  `address` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `firstName` text NOT NULL,
  `lastName` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'user',
  `isActive` tinyint NOT NULL DEFAULT '0',
  `url_image` text DEFAULT NULL,
  `token` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `location_user` (
  `id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `address` text NOT NULL,
  `name` text NOT NULL,
  `phone` text NOT NULL,
  `default_location` tinyint NOT NULL DEFAULT '0',
  `user_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_2a187ea153b876cca3b5d82190b` (`user_id`),
  CONSTRAINT `FK_2a187ea153b876cca3b5d82190b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `products` (
  `id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `name` text NOT NULL,
  `priceout` int NOT NULL,
  `description` text NOT NULL,
  `stockQuantity` int NOT NULL,
  `weight` int NOT NULL,
  `url_images` text DEFAULT NULL,
  `category_id` varchar(36) NOT NULL,
  `supplier_id` varchar(36) NOT NULL,
  `expire_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_9a5f6868c96e0069e699f33e124` (`category_id`),
  KEY `FK_0ec433c1e1d444962d592d86c86` (`supplier_id`),
  CONSTRAINT `FK_0ec433c1e1d444962d592d86c86` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `FK_9a5f6868c96e0069e699f33e124` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `import` (
  `id` varchar(36) NOT NULL,
  `import_code` varchar(36) DEFAULT NULL,
  `total_amount` int NOT NULL,
  `employee_id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_c9504edee3658a3d621efc168aa` (`employee_id`),
  CONSTRAINT `FK_c9504edee3658a3d621efc168aa` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `orders` (
  `id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `order_code` varchar(255) NOT NULL,
  `total_price` int NOT NULL,
  `orderStatus` varchar(255) NOT NULL,
  `payment_method` varchar(255) NOT NULL,
  `employee_id` varchar(36) DEFAULT NULL,
  `user_id` varchar(36) NOT NULL,
  `location_id` varchar(36) NOT NULL,
  `paymentStatus` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_a922b820eeef29ac1c6800e826a` (`user_id`),
  KEY `FK_f8a7411077c731327ca6e0b93b6` (`employee_id`),
  KEY `FK_90e29013d1252e005e70beb4f46` (`location_id`),
  CONSTRAINT `FK_90e29013d1252e005e70beb4f46` FOREIGN KEY (`location_id`) REFERENCES `location_user` (`id`),
  CONSTRAINT `FK_a922b820eeef29ac1c6800e826a` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_f8a7411077c731327ca6e0b93b6` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `import_product` (
  `id` varchar(36) NOT NULL,
  `quantity` int NOT NULL,
  `price_in` int NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `import_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_3bb593e74b40663a520a8e8bb1b` (`import_id`),
  KEY `FK_7449e6f13fe8844cf087a7e5d3a` (`product_id`),
  CONSTRAINT `FK_3bb593e74b40663a520a8e8bb1b` FOREIGN KEY (`import_id`) REFERENCES `import` (`id`),
  CONSTRAINT `FK_7449e6f13fe8844cf087a7e5d3a` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `order_product` (
  `id` varchar(36) NOT NULL,
  `quantity` int NOT NULL,
  `priceout` int NOT NULL,
  `order_id` varchar(36) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ea143999ecfa6a152f2202895e2` (`order_id`),
  KEY `FK_400f1584bf37c21172da3b15e2d` (`product_id`),
  CONSTRAINT `FK_400f1584bf37c21172da3b15e2d` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FK_ea143999ecfa6a152f2202895e2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `cart_product` (
  `id` varchar(36) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `quantity` int NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_3c4f98802acc2a16e3aae6a1ade` (`user_id`),
  KEY `FK_c6125c699faf07986d79ac16cc7` (`product_id`),
  CONSTRAINT `FK_3c4f98802acc2a16e3aae6a1ade` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK_c6125c699faf07986d79ac16cc7` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert data in proper order to respect dependencies

-- Categories
INSERT INTO `categories` VALUES 
('4ecd0719-0f01-4c0b-ae07-68a3f88f0d25','2024-11-19 01:13:55','2024-12-29 10:54:05','Thức ăn cho heo con','https://res.cloudinary.com/dbqvex29h/image/upload/v1735469642/xf73kj64xdfm7vd4gi8r.jpg','abc','Giúp heo con tăng trưởng nhanh, khỏe mạnh.','Áp dụng'),
('57522e0e-59e3-4224-b9dc-ce898eaa3f75','2024-11-19 01:14:45','2024-12-29 10:55:18','Thức ăn cho gà thịt','https://res.cloudinary.com/dbqvex29h/image/upload/v1735469714/yefxbi2jjtqsqzxcnkty.jpg','def','Tăng trọng nhanh, thịt chất lượng cao.','Áp dụng'),
('66a11f45-a512-4830-9830-c8bf21ee9ca8','2024-12-29 11:02:14','2024-12-29 11:02:14','Thức ăn cho heo nái','https://res.cloudinary.com/dbqvex29h/image/upload/v1735470113/tfpik134wpxw0xjfzt4a.jpg','nan','Duy trì sức khỏe, hỗ trợ sinh sản.','Áp dụng'),
('76bea410-40e6-4912-a26f-df22bf209f80','2024-12-25 07:06:45','2024-12-29 10:57:38','Thức ăn cho cá','https://res.cloudinary.com/dbqvex29h/image/upload/v1735469850/uohd9ai80qnxz1y9pwfu.jpg','nan','Phát triển đồng đều, kháng bệnh tốt.','Áp dụng'),
('87a44731-f294-4159-90b1-6b5cf7e5e3c7','2024-12-29 11:04:08','2024-12-29 11:04:08','Thức ăn cho vịt thịt','https://res.cloudinary.com/dbqvex29h/image/upload/v1735470234/goemhoa0wftyz1mroltj.jpg','nan','Tăng trưởng nhanh, thịt ngon, năng suất cao.','Áp dụng'),
('96dd2ca3-9fca-4474-92f1-e4e1da5a0c60','2024-12-29 11:03:07','2024-12-29 11:03:07','Thức ăn cho gà đẻ','https://res.cloudinary.com/dbqvex29h/image/upload/v1735470182/jcbpya9fqoo0ronpa2la.jpg','nan','Tăng sản lượng, cải thiện vỏ trứng.','Áp dụng'),
('cb2a1967-aac2-43b8-a9c7-c630c5395df5','2024-12-25 07:06:53','2024-12-29 10:58:40','Thức ăn cho vịt đẻ','https://res.cloudinary.com/dbqvex29h/image/upload/v1735469912/h9ozyjtdupmrphhlsarj.jpg','nan','Tăng sản lượng, chất lượng trứng.','Áp dụng'),
('cb499277-0d5c-407d-8b11-c7c89b18faf0','2024-12-25 07:06:38','2025-01-01 08:15:36','Thức ăn cho bò sữa','https://res.cloudinary.com/dbqvex29h/image/upload/v1735469975/s5jisenbnkfktm8sn1jx.jpg','nan','Tăng sản lượng, chất lượng sữa.','Không áp dụng'),
('f1374d50-0ebc-485c-8e98-86848b623d93','2024-12-25 07:05:29','2024-12-29 11:00:52','Thức ăn cho tôm sú','https://res.cloudinary.com/dbqvex29h/image/upload/v1735470018/xzq6nq1zpndjke6anzq6.webp','nan','Tăng trọng nhanh, kháng bệnh tốt.','Áp dụng');

-- Suppliers
INSERT INTO `suppliers` VALUES 
('4a0a5a98-dc32-4059-b422-283f835357a2','Công ty Cổ phần Chăn nuôi CP Việt Nam','https://res.cloudinary.com/dbqvex29h/image/upload/v1735472974/ykp3vymayctufhw6yz2v.jpg','0283 123 4567',' Lô 24, KCN Tân Tạo, Quận Bình Tân, TP. Hồ Chí Minh'),
('94b16fd3-ca09-4bb3-a1e6-915fde52dddf','Công ty TNHH De Heus Việt Nam','https://res.cloudinary.com/dbqvex29h/image/upload/v1735473011/a7ynxfqqwnsjd1subyfk.jpg','0251 234 5678','Số 15, Đường số 3, KCN Biên Hòa 2, TP. Biên Hòa, Đồng Nai'),
('c1267ecf-03c3-440b-a23e-eb09e36b7577','Công ty Cổ phần GreenFeed Việt Nam','https://res.cloudinary.com/dbqvex29h/image/upload/v1735473069/mupfzsw8d1fy3tbb5a58.png','0272 345 6789',' 5A Quốc lộ 1A, Thị trấn Bến Lức, Huyện Bến Lức, Long An'),
('c1267ecf-03c3-440b-a23e-eb09e36b757f','Công ty Cổ phần Việt Pháp Sản xuất Thức ăn Gia súc (Proconco)','https://res.cloudinary.com/dbqvex29h/image/upload/v1735473139/wvmofwejqeq29hpharla.jpg','0274 456 7890','Số 22, Đường Tỉnh 743, KCN Sóng Thần, Dĩ An, Bình Dương'),
('c1267ecf-03c3-440b-a23e-eb09e36b757t','Công ty TNHH Cargill Việt Nam','https://res.cloudinary.com/dbqvex29h/image/upload/v1735473193/itdqi8d14i0bisd1vxmd.png','0251 567 8901','KCN Long Thành, Huyện Long Thành, Đồng Nai');

-- Users
INSERT INTO `users` VALUES 
('383e55ec-3b0e-4f4f-ae9b-b483b2965519','2025-04-24 07:30:21','2025-04-24 07:30:21','bb','bb','b@gmail.com','$2b$10$XjpbMx2qa2Yce.EF1oC8b.Vx/yBkwVRDAIG2t9af66dmVir9oNvHS','customer',1,NULL,NULL),
('7bd3ae5c-7919-4e60-ba7e-41b49ebbc6e6','2025-04-23 06:38:01','2025-05-13 05:35:07','Tuấn','Vũ','tuanvu2102003@gmail.com','$2b$10$lmhLbOAfCZpj3uJumUnLcecmlzfyXjHx/sDpwwRCuK5..mUiTC4NO','user',1,'https://res.cloudinary.com/dbqvex29h/image/upload/v1745390371/r94auffa9obrgqmmfurf.jpg',NULL),
('7ee7793b-0056-4583-9fcd-bf0f31ece992','2025-04-24 07:28:39','2025-04-24 07:28:39','aa','aa','a@gmail.com','$2b$10$KhFqT17lqKNbKRlYGZcWZunCB36uWEvPn4Eoxnzcowt5/tk97bgzS','customer',1,NULL,NULL),
('80660057-8047-42ef-9831-c772ccb4bfd5','2025-04-22 17:39:19','2025-05-13 07:48:42','a','a','a','$2b$10$lqez16C9W4KKlRnm9ft8KuLYbhBRkfUoK/PIPPtpJlu8AqaddCPAC','employee',0,NULL,NULL),
('8a7aeb07-ee57-4bc2-8f62-6ad194aca108','2025-04-21 20:21:17','2025-04-21 20:21:17','a a','a a','9503@gmail.com','$2b$10$oX7BmWPdSYSSdatwXsbG4.oQXl6UApXRjHuE1Kh.GEVL3I4WEV91C','user',0,NULL,NULL),
('9ed7baa2-4913-4655-b55b-287742bbdb4b','2025-04-21 16:29:58','2025-05-23 06:36:36','Trang','1','trang1@gmail.com','$2b$10$gDhw6.5jHQlvAXYoF1nVH.s0.KcsuMoj0Nss5HBC6PUM6.jVF96yO','user',1,'https://res.cloudinary.com/dbqvex29h/image/upload/v1745511348/wmrwreo2ctfujnpambqe.png',NULL),
('c06bd92e-1f05-4758-9aa8-025edcb96f9b','2025-05-13 09:23:42','2025-05-13 09:23:42','test','test','kkieu9503@gmail.com','$2b$10$KQEpMd6VIiVfAyZxHtwuB.0Bo3K5UNhAVfhv29qjdekEu37J8.smS','user',0,NULL,NULL),
('dc937826-2d38-4c53-a035-487e289068c1','2025-04-21 16:19:40','2025-05-23 07:21:43','Kiều','Trang','trangtrang9503@gmail.com','$2b$10$JaMe1YQXQtgDUWBgoT9pxeZh2BYwjT7BQ8igN5SGG8JjYEq9PoJKO','admin',1,NULL,NULL),
('dd6c17d9-a3c6-4e72-8ee8-e6822bfed3e2','2025-04-23 16:57:21','2025-04-23 16:57:21','Kiều','              ','trang12@gmail.com','$2b$10$bnmB8ffmpoRzkvz8bMRIpO.b9hpcvSzyCZiyKxcatkGo7WJVizO1C','user',0,NULL,NULL);

-- Location_user
INSERT INTO `location_user` VALUES 
('1dc5cdae-a043-469f-a65d-5793b0c6dc5f','2025-04-23 06:41:27','2025-05-15 09:13:04','Ha Noi','KieuLinhTrang','aaa',1,'9ed7baa2-4913-4655-b55b-287742bbdb4b'),
('2aec2dee-8f4b-48d4-84c0-5efcb4721666','2025-05-13 09:23:42','2025-05-13 09:23:42','HN','test test','0972160082',1,'c06bd92e-1f05-4758-9aa8-025edcb96f9b'),
('5e5a65f4-2286-4371-b6b5-afe80b096a82','2025-04-23 06:38:01','2025-04-23 06:41:27','Ha Noii','Tuấn Vũ','0942460119',0,'7bd3ae5c-7919-4e60-ba7e-41b49ebbc6e6'),
('6896b820-52cb-4a62-b124-df89e3e4f9e7','2025-04-21 20:21:17','2025-04-21 20:21:17','2 - 2 ','a a a a','0972160081',1,'8a7aeb07-ee57-4bc2-8f62-6ad194aca108'),
('a41faf66-4a26-4a7f-a503-075816fb7a81','2025-04-23 16:57:21','2025-04-23 16:57:21','Ha Noi','Kiều               ','0972160012',1,'dd6c17d9-a3c6-4e72-8ee8-e6822bfed3e2'),
('c995e0ac-ecbb-4ccc-b19c-4e40a077a7a9','2025-04-21 16:19:40','2025-04-21 16:19:40','Ha Noi','Kiều Trang','0972160080',1,'dc937826-2d38-4c53-a035-487e289068c1'),
('de3664c0-1a67-4ce0-8c2e-50201f4958a4','2025-04-21 16:29:58','2025-04-22 16:39:24','Ha Noi','Trang Trang1','0972160080',0,'9ed7baa2-4913-4655-b55b-287742bbdb4b'),
('f6dea4d3-3cca-431b-938d-671f79e9c6d8','2025-04-22 16:39:24','2025-04-22 16:39:24','Ha Noi','Kiều Trang','0972160080',1,'9ed7baa2-4913-4655-b55b-287742bbdb4b');

-- Products with correct image URLs
INSERT INTO `products` VALUES 
('082f887d-3407-4a5f-9f84-1f0b9ea8dda4','2024-12-27 02:42:07','2025-05-15 13:38:14','Cám heo con',180000,'Thức ăn hỗn hợp dành cho heo con từ 7-15 kg, giúp tăng trưởng nhanh và khỏe mạnh.',32,15,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735469642/xf73kj64xdfm7vd4gi8r.jpg\",\"url_images2\":\"\"}','4ecd0719-0f01-4c0b-ae07-68a3f88f0d25','4a0a5a98-dc32-4059-b422-283f835357a2','2024-12-31 17:00:00'),
('1','2024-11-18 18:18:02','2024-12-29 19:28:21','Cám gà thịt Anco',320000,'Thức ăn hỗn hợp cho gà thịt từ 1-21 ngày tuổi, cung cấp đầy đủ dinh dưỡng.',14,25,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735525683/xquukh14oxm1ah8hoboe.jpg\",\"url_images2\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735525697/bt8qdtowugkgytcgihoz.jpg\"}','57522e0e-59e3-4224-b9dc-ce898eaa3f75','c1267ecf-03c3-440b-a23e-eb09e36b757f','2025-01-15 10:00:00'),
('123','2024-12-26 20:11:08','2024-12-29 19:46:29','Cám cá nổi Cargill',400000,'Thức ăn viên nổi dành cho cá tra, basa, giúp cá phát triển tốt và tăng trọng nhanh.',32,20,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526785/qidbh6jzkaqnbbc7qyju.webp\",\"url_images2\":\"\"}','76bea410-40e6-4912-a26f-df22bf209f80','c1267ecf-03c3-440b-a23e-eb09e36b757t','2025-01-01 10:00:00'),
('169ffbf9-c627-4106-8105-c5df8dcc4648','2024-12-27 01:38:22','2024-12-29 22:35:50','Cám vịt đẻ GreenFeed',370000,'Thức ăn hỗn hợp cho vịt đẻ, tăng sản lượng trứng và chất lượng vỏ trứng.',12,25,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735536947/z7ywlctshdniu5sn2sqq.webp\",\"url_images2\":\"\"}','cb2a1967-aac2-43b8-a9c7-c630c5395df5','c1267ecf-03c3-440b-a23e-eb09e36b7577','2025-01-16 10:00:00'),
('17a76110-cff8-4c30-9ee8-523ae8c5e291','2025-01-04 02:45:40','2025-01-04 02:45:40','Cám ta ta',230000,'Cám cung cấp nhiều dinh dưỡng',32,21,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735983932/gqvku9irqidmfzwydas1.png\",\"url_images2\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735983938/ldv0ppayxa02vpukxw9x.jpg\"}','57522e0e-59e3-4224-b9dc-ce898eaa3f75','4a0a5a98-dc32-4059-b422-283f835357a2','2025-01-30 10:00:00'),
('2','2024-11-18 18:18:02','2024-12-29 19:32:50','Cám tôm sú Grobest',500000,'Thức ăn viên dành cho tôm sú, giúp tôm lớn nhanh và kháng bệnh tốt.',15,20,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735525956/nwequi9zslgmtygvds7w.png\",\"url_images2\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735525963/zol8ruhwwjjr91vea8s0.jpg\"}','f1374d50-0ebc-485c-8e98-86848b623d93','c1267ecf-03c3-440b-a23e-eb09e36b757f','2024-11-18 10:00:00'),
('2bddac2b-3e2a-46aa-85a7-c4dc99036aa7','2024-12-21 18:26:53','2024-12-29 19:33:56','Cám heo nái Emivest',360000,'Thức ăn hỗn hợp cho heo nái mang thai và nuôi con, đảm bảo sức khỏe và năng suất.',28,25,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526024/m9cijduxl1aqm6rozk7j.webp\",\"url_images2\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526031/hmcbsicxctifzm6axmqa.jpg\"}','66a11f45-a512-4830-9830-c8bf21ee9ca8','4a0a5a98-dc32-4059-b422-283f835357a2','2024-12-21 10:00:00'),
('3','2024-11-18 18:18:02','2024-12-29 19:34:58','Cám gà đẻ Lái Thiêu',340000,'Thức ăn hỗn hợp cho gà đẻ trứng, tăng sản lượng và chất lượng trứng.',17,25,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526086/grl7dwrougeent4p4tuo.png\",\"url_images2\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526092/c5na9xm8xtu5vxmirqyk.jpg\"}','96dd2ca3-9fca-4474-92f1-e4e1da5a0c60','c1267ecf-03c3-440b-a23e-eb09e36b757f','2024-11-18 10:00:00'),
('4','2024-11-18 18:18:02','2024-12-25 01:53:08','Cám gà công nghiệp',1000,'Thức ăn cho gà',1,20,'{\"url_images1\":\"\",\"url_images2\":\"\"}','4ecd0719-0f01-4c0b-ae07-68a3f88f0d25','c1267ecf-03c3-440b-a23e-eb09e36b757f','2024-11-18 18:15:31'),
('929aab3c-7101-4585-9e4c-a5ba120195fb','2024-12-26 23:38:58','2024-12-26 23:38:58','abcde',12,'122ds',12,12,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735281534/k2mqywkverxpldcwawfa.jpg\",\"url_images2\":\"\"}','57522e0e-59e3-4224-b9dc-ce898eaa3f75','4a0a5a98-dc32-4059-b422-283f835357a2','2025-01-02 10:00:00'),
('391e92b2-62fb-4921-aa35-2a9b751c6a0b','2024-12-27 02:22:34','2024-12-29 19:37:11','Cám vịt thịt Vina',330000,'Thức ăn hỗn hợp cho vịt thịt, giúp tăng trọng nhanh và chất lượng thịt tốt.',122,25,'{\"url_images1\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526210/llz1y7lre0wks0hlsrjh.png\",\"url_images2\":\"https://res.cloudinary.com/dbqvex29h/image/upload/v1735526225/fywfoqgextcx1qxvwip4.jpg\"}','87a44731-f294-4159-90b1-6b5cf7e5e3c7','4a0a5a98-dc32-4059-b422-283f835357a2','2025-01-16 10:00:00');

-- Orders
INSERT INTO `orders` VALUES 
('0345b4df-5d6c-4090-a6c0-63d234c30c70','2025-04-23 16:18:12','2025-05-15 12:49:04','ORD-m9u51947-zutdfjwdnf',900000,'Đã giao hàng','Thanh toán khi nhận hàng','80660057-8047-42ef-9831-c772ccb4bfd5','9ed7baa2-4913-4655-b55b-287742bbdb4b','f6dea4d3-3cca-431b-938d-671f79e9c6d8','Đã thanh toán'),
('05eddfd2-cd25-43e3-8163-f173674d475a','2025-04-22 15:14:49','2025-04-23 07:36:41','ORD-m9snbvip-55ceepuz0a',320000,'Đã giao hàng','Thanh toán khi nhận hàng','80660057-8047-42ef-9831-c772ccb4bfd5','9ed7baa2-4913-4655-b55b-287742bbdb4b','de3664c0-1a67-4ce0-8c2e-50201f4958a4','Đã thanh toán'),
('0aad9cc5-a4ce-4e9e-a8f6-abb3ab83d38a','2025-05-22 21:25:51','2025-05-22 21:25:51','ORD-mazvsl8q-br4snxf2by',640000,'Đang kiểm hàng','Thanh toán khi nhận hàng',NULL,'9ed7baa2-4913-4655-b55b-287742bbdb4b','1dc5cdae-a043-469f-a65d-5793b0c6dc5f','Chưa thanh toán'),
('0d432d68-2b81-4f0a-ac51-24c960c61f6a','2025-04-22 15:00:54','2025-05-15 12:49:19','ORD-m9smtz68-qv3cwb5txx',540000,'Đã giao hàng','Thanh toán khi nhận hàng','80660057-8047-42ef-9831-c772ccb4bfd5','9ed7baa2-4913-4655-b55b-287742bbdb4b','de3664c0-1a67-4ce0-8c2e-50201f4958a4','Đã thanh toán'),
('0eaaf08f-0681-445b-8eed-c7410ef33d7c','2025-05-22 21:51:57','2025-05-22 21:51:57','ORD-mazwq5dr-osldfq96ph',640000,'Đang kiểm hàng','Thanh toán khi nhận hàng',NULL,'9ed7baa2-4913-4655-b55b-287742bbdb4b','1dc5cdae-a043-469f-a65d-5793b0c6dc5f','Chưa thanh toán');

-- Order_product
INSERT INTO `order_product` VALUES 
('04936d4f-d23d-4826-9185-b32ca15a34b4',11,340000,'0345b4df-5d6c-4090-a6c0-63d234c30c70','3'),
('40c63835-5be1-4ea8-bb1e-afd6eab05f08',5,180000,'0345b4df-5d6c-4090-a6c0-63d234c30c70','082f887d-3407-4a5f-9f84-1f0b9ea8dda4'),
('65733d2b-b4e5-4540-9509-717b30bbffd4',1,320000,'05eddfd2-cd25-43e3-8163-f173674d475a','1'),
('bf7544de-70f7-4e07-88df-6c4b2158856d',2,320000,'0aad9cc5-a4ce-4e9e-a8f6-abb3ab83d38a','1'),
('177df94e-ab87-4b43-9e0f-aa7dd525c13c',1,360000,'0d432d68-2b81-4f0a-ac51-24c960c61f6a','2bddac2b-3e2a-46aa-85a7-c4dc99036aa7'),
('ea3731b4-2864-44aa-a913-864f175d6b96',1,180000,'0d432d68-2b81-4f0a-ac51-24c960c61f6a','082f887d-3407-4a5f-9f84-1f0b9ea8dda4'),
('d5703020-75b8-44b0-92b2-f3652dff6d1d',2,320000,'0eaaf08f-0681-445b-8eed-c7410ef33d7c','1');

-- Cart_product
INSERT INTO `cart_product` VALUES 
('3a5301e2-9940-4b27-b7b2-e1f64cef98e5','2025-04-23 06:40:15','2025-04-23 06:44:01',2,'17a76110-cff8-4c30-9ee8-523ae8c5e291','7bd3ae5c-7919-4e60-ba7e-41b49ebbc6e6'),
('7a239a95-5fe3-47ee-96bb-b6e157c0ea0a','2025-04-23 06:44:16','2025-04-23 06:44:16',1,'391e92b2-62fb-4921-aa35-2a9b751c6a0b','7bd3ae5c-7919-4e60-ba7e-41b49ebbc6e6');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;