-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2025 at 03:16 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `booking_futsal`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPemesanan` (IN `p_user_id` INT, IN `p_lapangan_id` INT, IN `p_tanggal_pesan` DATE, IN `p_jam_mulai` TIME, IN `p_jam_selesai` TIME, IN `p_total_harga` DECIMAL(10,2), OUT `p_status` VARCHAR(255))   BEGIN
    DECLARE pemesanan_count INT;
    
    -- Cek apakah sudah ada pemesanan di waktu yang sama
    SELECT COUNT(*) INTO pemesanan_count 
    FROM transaksi 
    WHERE lapangan_id = p_lapangan_id 
    AND tanggal_pesan = p_tanggal_pesan 
    AND ((jam_mulai BETWEEN p_jam_mulai AND p_jam_selesai) 
        OR (jam_selesai BETWEEN p_jam_mulai AND p_jam_selesai));
    
    IF pemesanan_count > 0 THEN
        SET p_status = 'Duplikasi';
    ELSE
        -- Simpan pemesanan jika tidak ada duplikasi
        INSERT INTO transaksi (user_id, lapangan_id, tanggal_pesan, jam_mulai, jam_selesai, total_harga, status) 
        VALUES (p_user_id, p_lapangan_id, p_tanggal_pesan, p_jam_mulai, p_jam_selesai, p_total_harga, 'Menunggu');
        
        SET p_status = 'Sukses';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `nama`, `email`, `password`, `created_at`) VALUES
(2, 'Admin PTI Futsal', 'admin@ptifutsal.com', 'admin123', '2025-02-09 19:48:28');

-- --------------------------------------------------------

--
-- Table structure for table `lapangan`
--

CREATE TABLE `lapangan` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `lokasi` text NOT NULL,
  `harga_per_jam` decimal(10,2) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lapangan`
--

INSERT INTO `lapangan` (`id`, `nama`, `lokasi`, `harga_per_jam`, `latitude`, `longitude`, `created_at`, `jam_mulai`, `jam_selesai`) VALUES
(1, 'Dewa Futsal', '', 150000.00, -6.92724694, 107.66652659, '2025-02-09 20:45:45', '09:00:00', '10:00:00'),
(2, 'Futsal Atello', '', 150000.00, -6.92900427, 107.67458797, '2025-02-09 22:03:58', '09:00:00', '21:00:00'),
(3, 'Futsal Shakti Taridi', 'Jl. Parakan Saat No. 9 RT 2/11, Kelurahan Saranten Endah Cisaranten Endah Kec. Arcamanik Kota Bandung, Jawa Barat 40291, Indonesia', 150000.00, -6.93107046, 107.66865492, '2025-02-09 22:27:40', '09:00:00', '21:00:00'),
(4, 'Garuda Futsal', 'Jl. Trs Pesantren Raya Sukamiskin Arcamanik Bandung City, West Java 40294, Indonesia', 150000.00, -6.91218720, 107.68051364, '2025-02-09 22:33:10', '10:00:00', '22:00:00'),
(5, 'Star Futsal', 'Jl. Sari Wates Tim. No.12 Antapani Kidul Kec. Antapani Kota Bandung, Jawa Barat 40291, Indonesia', 150000.00, -6.92416893, 107.65752912, '2025-02-09 22:50:41', '08:00:00', '20:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lapangan_id` int(11) NOT NULL,
  `tanggal_pesan` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `total_harga` decimal(10,2) NOT NULL,
  `status` enum('Menunggu','Dikonfirmasi','Ditolak','Selesai') DEFAULT 'Menunggu',
  `bukti_pembayaran` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id`, `user_id`, `lapangan_id`, `tanggal_pesan`, `jam_mulai`, `jam_selesai`, `total_harga`, `status`, `bukti_pembayaran`, `created_at`) VALUES
(1, 2, 1, '2025-02-10', '09:00:00', '10:00:00', 150000.00, '', '1739137384_Screenshot_160.jpg', '2025-02-09 21:05:31'),
(2, 2, 1, '2025-02-11', '11:00:00', '12:00:00', 150000.00, '', NULL, '2025-02-09 21:19:28'),
(3, 2, 4, '2025-02-10', '11:00:00', '12:00:00', 150000.00, '', NULL, '2025-02-09 22:36:46'),
(4, 2, 1, '2025-02-10', '13:00:00', '14:00:00', 150000.00, '', NULL, '2025-02-10 01:30:50'),
(5, 2, 1, '2025-02-10', '15:00:00', '16:00:00', 150000.00, '', '1739153057_2964943.jpeg', '2025-02-10 02:02:59'),
(6, 2, 2, '2025-02-10', '09:00:00', '10:00:00', 150000.00, '', '1739153202_images.jpeg', '2025-02-10 02:06:21'),
(7, 2, 3, '2025-02-10', '09:00:00', '10:00:00', 150000.00, '', '1739153741_futsal taridi.jpeg', '2025-02-10 02:15:18');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `nama`, `email`, `password`, `no_hp`, `created_at`) VALUES
(2, 'Rangga Prasetya', 'rangga@gmail.com', '123', '085555555555', '2025-02-09 20:15:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `lapangan`
--
ALTER TABLE `lapangan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `lapangan_id` (`lapangan_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lapangan`
--
ALTER TABLE `lapangan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`lapangan_id`) REFERENCES `lapangan` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
