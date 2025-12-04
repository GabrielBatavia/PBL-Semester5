-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 24, 2025 at 12:13 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jawara`
--

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `pic_name` varchar(150) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `date` date NOT NULL,
  `description` text,
  `image_url` text,
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `name`, `category`, `pic_name`, `location`, `date`, `description`, `image_url`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Kerja Bakti Minggu 1', 'kebersihan', 'Pak RT', 'Lapangan', '2025-01-10', 'Kerja bakti rutin.', NULL, 2, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Kerja Bakti Minggu 2', 'kebersihan', 'Pak RW', 'Lapangan', '2025-01-17', 'Pembersihan lingkungan.', NULL, 3, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Rapat Warga', 'rapat', 'Pak RT', 'Balai RW', '2025-01-20', 'Rapat bulanan.', NULL, 2, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Senam Pagi', 'olahraga', 'Bu RW', 'Lapangan', '2025-01-05', 'Senam warga.', NULL, 3, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Lomba Agustusan', 'kegiatan', 'Panitia RW', 'Balai Desa', '2025-08-17', 'Lomba 17-an.', NULL, 3, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `description` text NOT NULL,
  `actor_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `description`, `actor_id`, `created_at`) VALUES
(1, 'Admin membuat pengumuman', 1, '2025-11-24 11:54:33'),
(2, 'RT memperbarui data warga', 2, '2025-11-24 11:54:33'),
(3, 'RW mengisi jadwal kegiatan', 3, '2025-11-24 11:54:33'),
(4, 'Bendahara mencatat pemasukan', 4, '2025-11-24 11:54:33'),
(5, 'Warga melakukan pembayaran', 5, '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` bigint UNSIGNED NOT NULL,
  `family_id` bigint UNSIGNED DEFAULT NULL,
  `category_id` bigint UNSIGNED DEFAULT NULL,
  `code` varchar(50) NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'belum_lunas',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`id`, `family_id`, `category_id`, `code`, `amount`, `period_start`, `period_end`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'BL001', '50000.00', '2025-01-01', '2025-01-31', 'belum_lunas', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 2, 1, 'BL002', '50000.00', '2025-01-01', '2025-01-31', 'belum_lunas', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 3, 2, 'BL003', '30000.00', '2025-01-01', '2025-01-31', 'belum_lunas', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 4, 3, 'BL004', '100000.00', '2025-01-01', '2025-01-31', 'belum_lunas', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 5, 1, 'BL005', '50000.00', '2025-01-01', '2025-01-31', 'belum_lunas', '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `broadcasts`
--

CREATE TABLE `broadcasts` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `sender_id` bigint UNSIGNED DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `image_url` text,
  `document_name` varchar(200) DEFAULT NULL,
  `document_url` text,
  `target_scope` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `broadcasts`
--

INSERT INTO `broadcasts` (`id`, `title`, `content`, `sender_id`, `published_at`, `image_url`, `document_name`, `document_url`, `target_scope`, `created_at`, `updated_at`) VALUES
(1, 'Pengumuman Kerja Bakti', 'Kerja bakti minggu depan.', 2, '2025-11-24 11:54:33', NULL, NULL, NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Pengumuman Iuran', 'Iuran bulan ini sudah bisa dibayar.', 4, '2025-11-24 11:54:33', NULL, NULL, NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Rapat Rutin', 'Rapat Jumat depan.', 3, '2025-11-24 11:54:33', NULL, NULL, NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Senam Pagi', 'Ayo senam pagi di lapangan!', 2, '2025-11-24 11:54:33', NULL, NULL, NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Lomba 17 Agustus', 'Pendaftaran lomba dibuka.', 2, '2025-11-24 11:54:33', NULL, NULL, NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `citizen_registration_requests`
--

CREATE TABLE `citizen_registration_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `nik` varchar(20) NOT NULL,
  `email` varchar(150) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `identity_image_url` text,
  `status` varchar(20) DEFAULT 'pending',
  `processed_by` bigint UNSIGNED DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `citizen_registration_requests`
--

INSERT INTO `citizen_registration_requests` (`id`, `name`, `nik`, `email`, `gender`, `identity_image_url`, `status`, `processed_by`, `processed_at`, `created_at`, `updated_at`) VALUES
(1, 'Warga Baru 1', '9000000000000001', 'new1@test.com', 'L', NULL, 'pending', NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Warga Baru 2', '9000000000000002', 'new2@test.com', 'P', NULL, 'pending', NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Warga Baru 3', '9000000000000003', 'new3@test.com', 'L', NULL, 'pending', NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Warga Baru 4', '9000000000000004', 'new4@test.com', 'P', NULL, 'pending', NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Warga Baru 5', '9000000000000005', 'new5@test.com', 'L', NULL, 'pending', NULL, NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `expense_transactions`
--

CREATE TABLE `expense_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `date` date NOT NULL,
  `proof_image_url` text,
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `expense_transactions`
--

INSERT INTO `expense_transactions` (`id`, `category`, `name`, `amount`, `date`, `proof_image_url`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'kebersihan', 'Beli sapu', '120000.00', '2025-01-04', NULL, 4, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'kebersihan', 'Beli tempat sampah', '250000.00', '2025-01-05', NULL, 4, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'keamanan', 'Perbaikan pos ronda', '300000.00', '2025-01-06', NULL, 2, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'operasional', 'Cetak formulir', '50000.00', '2025-01-07', NULL, 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'kegiatan', 'Hadiah lomba', '450000.00', '2025-01-08', NULL, 3, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `families`
--

CREATE TABLE `families` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `house_id` bigint UNSIGNED DEFAULT NULL,
  `status` varchar(20) DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `families`
--

INSERT INTO `families` (`id`, `name`, `house_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Keluarga A', 1, 'aktif', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Keluarga B', 2, 'aktif', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Keluarga C', 3, 'aktif', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Keluarga D', 4, 'nonaktif', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Keluarga E', 5, 'aktif', '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `fee_categories`
--

CREATE TABLE `fee_categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `type` varchar(50) NOT NULL,
  `default_amount` decimal(18,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `fee_categories`
--

INSERT INTO `fee_categories` (`id`, `name`, `type`, `default_amount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Iuran Keamanan', 'bulanan', '50000.00', 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Iuran Kebersihan', 'bulanan', '30000.00', 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Kas Sosial', 'insidental', '100000.00', 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Dana Kegiatan', 'insidental', '150000.00', 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Donasi', 'sukarela', '0.00', 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` bigint UNSIGNED NOT NULL,
  `address` text NOT NULL,
  `area` varchar(50) DEFAULT NULL,
  `status` varchar(30) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `address`, `area`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Jl. Kenanga No. 1', 'A1', 'terisi', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Jl. Kenanga No. 2', 'A1', 'terisi', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Jl. Kenanga No. 3', 'A1', 'terisi', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Jl. Kenanga No. 4', 'A1', 'kosong', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Jl. Kenanga No. 5', 'A1', 'terisi', '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `income_transactions`
--

CREATE TABLE `income_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED DEFAULT NULL,
  `family_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `amount` decimal(18,2) NOT NULL,
  `date` date NOT NULL,
  `proof_image_url` text,
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `income_transactions`
--

INSERT INTO `income_transactions` (`id`, `category_id`, `family_id`, `name`, `type`, `amount`, `date`, `proof_image_url`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'Iuran Keamanan', 'iuran', '50000.00', '2025-01-02', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 1, 2, 'Iuran Keamanan', 'iuran', '50000.00', '2025-01-02', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 2, 3, 'Iuran Kebersihan', 'iuran', '30000.00', '2025-01-03', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 3, 4, 'Kas Sosial', 'donasi', '100000.00', '2025-01-04', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 1, 5, 'Iuran Keamanan', 'iuran', '50000.00', '2025-01-05', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `marketplace_items`
--

CREATE TABLE `marketplace_items` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(18,2) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `image_url` text,
  `owner_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `marketplace_items`
--

INSERT INTO `marketplace_items` (`id`, `title`, `description`, `price`, `unit`, `image_url`, `owner_id`, `created_at`, `updated_at`) VALUES
(1, 'Jual Beras 5kg', 'Beras premium', '70000.00', 'kg', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Jual Kompor Gas', 'Kompor gas 2 tungku', '150000.00', 'unit', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Jual Meja Belajar', 'Meja kayu', '200000.00', 'unit', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Jual Ayam Kampung', 'Ayam hidup', '90000.00', 'ekor', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Jual Sepeda Anak', 'Sepeda kecil', '300000.00', 'unit', NULL, 5, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `payment_channels`
--

CREATE TABLE `payment_channels` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `type` varchar(30) NOT NULL,
  `account_name` varchar(150) DEFAULT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `qris_image_url` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `payment_channels`
--

INSERT INTO `payment_channels` (`id`, `name`, `type`, `account_name`, `account_number`, `bank_name`, `qris_image_url`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Bank BCA', 'transfer', 'RT 01', '1234567890', 'BCA', NULL, 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Bank Mandiri', 'transfer', 'RT 01', '9876543210', 'Mandiri', NULL, 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'QRIS RT 01', 'qris', NULL, NULL, NULL, NULL, 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'OVO RT', 'ewallet', 'RT 01', '081234567890', NULL, NULL, 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Gopay RT', 'ewallet', 'RT 01', '081233221122', NULL, NULL, 1, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `residents`
--

CREATE TABLE `residents` (
  `id` bigint UNSIGNED NOT NULL,
  `family_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `nik` varchar(20) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `job` varchar(100) DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `residents`
--

INSERT INTO `residents` (`id`, `family_id`, `name`, `nik`, `birth_date`, `job`, `gender`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'Agus Santoso', '1111111111110001', '1980-01-10', 'Guru', 'L', NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 1, 'Rina Wati', '1111111111110002', '1983-03-03', 'IRT', 'P', NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 2, 'Bambang Prasetyo', '2222222222220001', '1979-07-20', 'Karyawan', 'L', NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 3, 'Citra Dewi', '3333333333330001', '1995-12-01', 'Wiraswasta', 'P', NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 5, 'Eko Saputro', '5555555555550001', '2000-09-14', 'Mahasiswa', 'L', NULL, '2025-11-24 11:54:33', '2025-11-24 11:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `display_name`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Administrator', '2025-11-24 11:49:24', '2025-11-24 11:49:24'),
(2, 'rt', 'Ketua RT', '2025-11-24 11:49:24', '2025-11-24 11:49:24'),
(3, 'rw', 'Ketua RW', '2025-11-24 11:49:24', '2025-11-24 11:49:24'),
(4, 'bendahara', 'Bendahara', '2025-11-24 11:49:24', '2025-11-24 11:49:24'),
(5, 'warga', 'Warga', '2025-11-24 11:49:24', '2025-11-24 11:49:24');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `nik` varchar(20) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `address` text,
  `role_id` bigint UNSIGNED DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `nik`, `phone`, `address`, `role_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Admin Sistem', 'admin@jawara.com', '123456', '1111111111111111', '0811111111', 'Jl. Mawar No. 1', 1, 'active', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(2, 'Ketua RT', 'rt@jawara.com', '123456', '2222222222222222', '0822222222', 'Jl. Melati No. 10', 2, 'active', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(3, 'Ketua RW', 'rw@jawara.com', '123456', '3333333333333333', '0833333333', 'Jl. Anggrek No. 20', 3, 'active', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(4, 'Bendahara', 'bendahara@jawara.com', '123456', '4444444444444444', '0844444444', 'Jl. Kenanga No. 17', 4, 'active', '2025-11-24 11:54:33', '2025-11-24 11:54:33'),
(5, 'Warga Satu', 'warga1@jawara.com', '123456', '5555555555555555', '0855555555', 'Jl. Kemuning No. 5', 5, 'active', '2025-11-24 11:54:33', '2025-11-24 11:54:33');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_activities_date` (`date`),
  ADD KEY `idx_activities_category` (`category`),
  ADD KEY `fk_activities_created_by` (`created_by`);

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_activity_logs_actor_id` (`actor_id`),
  ADD KEY `idx_activity_logs_created_at` (`created_at`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_bills_family_id` (`family_id`),
  ADD KEY `idx_bills_category_id` (`category_id`),
  ADD KEY `idx_bills_status` (`status`);

--
-- Indexes for table `broadcasts`
--
ALTER TABLE `broadcasts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_broadcasts_published_at` (`published_at`),
  ADD KEY `fk_broadcasts_sender` (`sender_id`);

--
-- Indexes for table `citizen_registration_requests`
--
ALTER TABLE `citizen_registration_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_citizen_requests_status` (`status`),
  ADD KEY `fk_citizen_requests_processed_by` (`processed_by`);

--
-- Indexes for table `expense_transactions`
--
ALTER TABLE `expense_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_expense_date` (`date`),
  ADD KEY `fk_expense_created_by` (`created_by`);

--
-- Indexes for table `families`
--
ALTER TABLE `families`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_families_house_id` (`house_id`),
  ADD KEY `idx_families_status` (`status`);

--
-- Indexes for table `fee_categories`
--
ALTER TABLE `fee_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_fee_categories_active` (`is_active`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `income_transactions`
--
ALTER TABLE `income_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_income_category_id` (`category_id`),
  ADD KEY `idx_income_family_id` (`family_id`),
  ADD KEY `idx_income_date` (`date`),
  ADD KEY `fk_income_created_by` (`created_by`);

--
-- Indexes for table `marketplace_items`
--
ALTER TABLE `marketplace_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_marketplace_owner_id` (`owner_id`);

--
-- Indexes for table `payment_channels`
--
ALTER TABLE `payment_channels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_payment_channels_type` (`type`),
  ADD KEY `idx_payment_channels_active` (`is_active`);

--
-- Indexes for table `residents`
--
ALTER TABLE `residents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `idx_residents_family_id` (`family_id`),
  ADD KEY `idx_residents_user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_role_id` (`role_id`),
  ADD KEY `idx_users_status` (`status`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `broadcasts`
--
ALTER TABLE `broadcasts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `citizen_registration_requests`
--
ALTER TABLE `citizen_registration_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `expense_transactions`
--
ALTER TABLE `expense_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `families`
--
ALTER TABLE `families`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `fee_categories`
--
ALTER TABLE `fee_categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `income_transactions`
--
ALTER TABLE `income_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `marketplace_items`
--
ALTER TABLE `marketplace_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payment_channels`
--
ALTER TABLE `payment_channels`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `residents`
--
ALTER TABLE `residents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `fk_activities_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_logs_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `fk_bills_category` FOREIGN KEY (`category_id`) REFERENCES `fee_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bills_family` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `broadcasts`
--
ALTER TABLE `broadcasts`
  ADD CONSTRAINT `fk_broadcasts_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `citizen_registration_requests`
--
ALTER TABLE `citizen_registration_requests`
  ADD CONSTRAINT `fk_citizen_requests_processed_by` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `expense_transactions`
--
ALTER TABLE `expense_transactions`
  ADD CONSTRAINT `fk_expense_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `families`
--
ALTER TABLE `families`
  ADD CONSTRAINT `fk_families_house` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `income_transactions`
--
ALTER TABLE `income_transactions`
  ADD CONSTRAINT `fk_income_category` FOREIGN KEY (`category_id`) REFERENCES `fee_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_income_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_income_family` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `marketplace_items`
--
ALTER TABLE `marketplace_items`
  ADD CONSTRAINT `fk_marketplace_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `residents`
--
ALTER TABLE `residents`
  ADD CONSTRAINT `fk_residents_family` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_residents_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
