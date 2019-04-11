-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 11, 2019 at 04:15 AM
-- Server version: 10.1.34-MariaDB
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_resto`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getFinishedOrder` (IN `noMeja` INT(1))  NO SQL
begin
SELECT orders._keterangan AS keteranganOrder,
SUM(detail._jumlah) AS jumlahOrder,
orders._id AS idOrder,
detail._idMasakan AS idMasakan,
detail._keterangan AS keteranganDetail,
detail._status AS statusDetail,
masakan._namaMasakan AS namaMasakan,
masakan._harga AS hargaMasakan,
masakan._jenisMasakan AS jenisMasakan
FROM ((order_ orders INNER JOIN detail_order_ detail 
       ON orders._id = detail._idOrder)
      INNER JOIN masakan_ masakan ON detail._idMasakan = masakan._id) 
      WHERE orders._noMeja = noMeja AND orders._statusOrder = 2 
      GROUP BY masakan._namaMasakan;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getFoodList` (IN `_jenisMasakan` INT)  BEGIN
    SELECT masakan._id, masakan._namaMasakan, masakan._harga, masakan._deskripsi, masakan._jenisMasakan, masakan._statusMasakan FROM masakan_ masakan WHERE masakan._jenisMasakan = _jenisMasakan AND masakan._status =1 ORDER BY masakan._namaMasakan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getMenuOrder` ()  NO SQL
begin
SELECT orders._noMeja AS noMeja, 
orders._tanggal AS tanggalOrder,
orders._keterangan AS keteranganOrder,
orders._statusOrder AS statusOrder,
detail._jumlah AS jumlahOrder,
detail._keterangan AS keteranganDetail,
detail._status AS statusDetail,
masakan._namaMasakan AS namaMasakan,
masakan._harga AS hargaMasakan,
masakan._jenisMasakan AS jenisMasakan,
masakan._statusMasakan AS statusMasakan
FROM ((order_ orders INNER JOIN detail_order_ detail 
       ON orders._id = detail._idOrder)
      INNER JOIN masakan_ masakan ON detail._idMasakan = masakan._id) 
      WHERE orders._statusOrder = 2;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getOrderPerTable` (IN `noMeja` INT)  begin
SELECT orders._noMeja AS noMeja, 
orders._id AS idOrder,
orders._tanggal AS tanggalOrder,
orders._keterangan AS keteranganOrder,
orders._statusOrder AS statusOrder,
detail._jumlah AS jumlahOrder,
detail._keterangan AS keteranganDetail,
detail._status AS statusDetail,
masakan._namaMasakan AS namaMasakan,
masakan._harga AS hargaMasakan,
masakan._jenisMasakan AS jenisMasakan,
masakan._statusMasakan AS statusMasakan
FROM ((order_ orders INNER JOIN detail_order_ detail 
       ON orders._id = detail._idOrder)
      INNER JOIN masakan_ masakan ON detail._idMasakan = masakan._id) 
      WHERE orders._noMeja = noMeja AND orders._statusOrder = 2 
      ORDER BY masakan._namaMasakan;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getReport` (IN `jenisMasakan` INT(1))  SELECT 
 	masakan._id, 
    masakan._namaMasakan, 
    masakan._harga, 
    masakan._deskripsi, 
    masakan._jenisMasakan, 
    masakan._statusMasakan, 
    stok._jumlah, 
    IFNULL(SUM(details._jumlah), 0) AS jumlahPesanan, 
    IFNULL(SUM(transaksi._totalBayar), 0) AS totalBayar
    FROM masakan_ masakan 
    LEFT JOIN stok_ stok ON masakan._id = stok._idMasakan 
    LEFT JOIN detail_order_ details ON masakan._id = details._idMasakan 		LEFT JOIN order_ orders ON details._idOrder = orders._id 
    LEFT JOIN transaksi_ transaksi ON orders._id = transaksi._idOrder
    WHERE masakan._jenisMasakan = jenisMasakan
    GROUP BY masakan._namaMasakan
    ORDER BY masakan._namaMasakan$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_getReportFiltered` (IN `jenisMasakan` INT(1), IN `tanggalAwal` VARCHAR(11), IN `tanggalAkhir` VARCHAR(11))  NO SQL
SELECT 
 	masakan._id, 
    masakan._namaMasakan, 
    masakan._harga, 
    masakan._deskripsi, 
    masakan._jenisMasakan, 
    masakan._statusMasakan, 
    stok._jumlah, 
    IFNULL(SUM(details._jumlah), 0) AS jumlahPesanan, 
    IFNULL(SUM(transaksi._totalBayar), 0) AS totalBayar
    FROM masakan_ masakan 
    LEFT JOIN stok_ stok ON masakan._id = stok._idMasakan 
    LEFT JOIN detail_order_ details ON masakan._id = details._idMasakan 	LEFT JOIN order_ orders ON details._idOrder = orders._id 
    LEFT JOIN transaksi_ transaksi ON orders._id = transaksi._idOrder
    WHERE masakan._jenisMasakan = jenisMasakan AND
    orders._tanggal >= tanggalAwal AND
    orders._tanggal <= tanggalAkhir
    GROUP BY masakan._namaMasakan
    ORDER BY masakan._namaMasakan$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_updateStatusMenu` (IN `idMasakan` INT(3))  NO SQL
UPDATE masakan_ SET _statusMasakan = 1 WHERE _id = idMasakan$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `OrderProcess` (`noMeja` INT(2), `tanggal` VARCHAR(11), `idUser` INT(4), `keteranganOrder` VARCHAR(50)) RETURNS INT(5) BEGIN
DECLARE isOrderExist INT(1);
DECLARE idOrder INT(5);
SELECT COUNT(*) INTO isOrderExist FROM order_ WHERE _noMeja = noMeja AND _idUser = idUser AND _statusOrder = 2;

IF isOrderExist = 1 THEN
SELECT _id into idOrder FROM order_ WHERE _noMeja = noMeja AND _idUser = idUser AND _statusOrder = 2;
return idOrder;
ELSE
INSERT INTO order_(_noMeja, _tanggal, _idUser, _keterangan, _statusOrder) VALUES(noMeja, tanggal, idUser, keteranganOrder, 2);

SELECT _id into idOrder FROM order_ WHERE _noMeja = noMeja AND _idUser = idUser AND _statusOrder = 2;

return idOrder;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_order_`
--

CREATE TABLE `detail_order_` (
  `_id` int(4) NOT NULL,
  `_idOrder` int(4) NOT NULL,
  `_idMasakan` int(3) NOT NULL,
  `_jumlah` int(2) NOT NULL,
  `_keterangan` varchar(40) NOT NULL,
  `_status` int(1) NOT NULL COMMENT '1 = belum diproses, 2 = diproses, 3 = selesai'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_order_`
--

INSERT INTO `detail_order_` (`_id`, `_idOrder`, `_idMasakan`, `_jumlah`, `_keterangan`, `_status`) VALUES
(7, 2, 17, 2, 'bingung ini apa', 1),
(8, 3, 18, 5, 'bingung ini apa', 1),
(9, 4, 15, 1, 'bingung ini apa', 1),
(13, 4, 11, 2, 'pp', 1),
(27, 12, 18, 1, 'kkks', 1),
(28, 13, 14, 2, 'ddd', 1),
(29, 13, 18, 2, 'dd', 1),
(30, 13, 21, 3, 'rd', 1),
(31, 13, 22, 3, 'desq2', 1),
(32, 13, 17, 2, 'dd', 1),
(33, 15, 17, 2, 'sambelnya banyakin hehe', 2),
(34, 15, 15, 3, 'gpl', 1),
(35, 15, 16, 2, 'nudie', 1),
(36, 16, 13, 1, 'user', 1),
(37, 18, 16, 3, 'gpl', 2),
(38, 18, 22, 3, 'hd', 2);

-- --------------------------------------------------------

--
-- Table structure for table `level_`
--

CREATE TABLE `level_` (
  `_id` int(1) NOT NULL,
  `_namaLevel` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `level_`
--

INSERT INTO `level_` (`_id`, `_namaLevel`) VALUES
(1, 'owner'),
(2, 'kasir'),
(3, 'waiter'),
(4, 'admin'),
(5, 'pelanggan');

-- --------------------------------------------------------

--
-- Table structure for table `masakan_`
--

CREATE TABLE `masakan_` (
  `_id` int(3) NOT NULL,
  `_namaMasakan` varchar(30) NOT NULL,
  `_harga` int(7) NOT NULL,
  `_deskripsi` varchar(80) NOT NULL,
  `_jenisMasakan` int(1) NOT NULL COMMENT '1 = makanan, 2 = minuman',
  `_statusMasakan` int(1) NOT NULL COMMENT '1 = ada, 2 = habis',
  `_status` int(1) NOT NULL DEFAULT '1' COMMENT '1 = dipakai, 2 = dihapus',
  `_gambar` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `masakan_`
--

INSERT INTO `masakan_` (`_id`, `_namaMasakan`, `_harga`, `_deskripsi`, `_jenisMasakan`, `_statusMasakan`, `_status`, `_gambar`) VALUES
(11, 'UBI BAKAR', 8000, 'jhfjhbmnbb', 1, 2, 1, ''),
(13, 'NASI GORENG', 15000, 'jhghjyur', 1, 1, 1, ''),
(14, 'AYAM BAKAR', 25000, 'ayam yang dibakar setengah matang dengan telor keju', 1, 2, 2, ''),
(15, 'IKAN GORENG', 25000, 'gyrte', 1, 1, 1, ''),
(16, 'UDANG TEPUNG', 28000, 'jbhvjhv', 1, 1, 1, ''),
(17, 'BABI GULING', 20000, 'nbgyut', 1, 1, 1, ''),
(18, 'ES TEH', 7000, 'jbyurtx yhukguyt j', 2, 2, 1, ''),
(19, 'JUS AVOCADO', 10000, 'hfgcnbv', 2, 1, 1, ''),
(20, 'JUS JERUK', 10000, 'eawerefdf', 2, 1, 1, ''),
(21, 'JUS MANGGA', 12000, 'gjhffffuytyjhh uyuit ghjg', 2, 1, 1, ''),
(22, 'SODA GEMBIRA', 15000, 'xdffdart', 2, 1, 1, ''),
(24, 'WINE', 500000, 'dfgdfsgfdg', 2, 1, 2, NULL),
(25, 'BARBEQUE', 3245435, 'asdfasdf', 1, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `meja_`
--

CREATE TABLE `meja_` (
  `_id` int(2) NOT NULL,
  `_noMeja` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `meja_`
--

INSERT INTO `meja_` (`_id`, `_noMeja`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 10),
(8, 11);

-- --------------------------------------------------------

--
-- Table structure for table `order_`
--

CREATE TABLE `order_` (
  `_id` int(4) NOT NULL,
  `_noMeja` int(2) NOT NULL,
  `_tanggal` date NOT NULL,
  `_idUser` int(3) NOT NULL,
  `_keterangan` varchar(40) DEFAULT NULL,
  `_statusOrder` int(1) NOT NULL COMMENT '1 = dibayar, 2 = belum dibayar'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_`
--

INSERT INTO `order_` (`_id`, `_noMeja`, `_tanggal`, `_idUser`, `_keterangan`, `_statusOrder`) VALUES
(1, 1, '2019-02-01', 3, 'cepetin dong mas', 2),
(2, 2, '2019-02-12', 4, 'pengen banget mas', 1),
(3, 3, '2019-02-03', 10, 'gpl', 2),
(4, 1, '2019-02-28', 12, 'cepet laper nih', 2),
(12, 5, '2019-04-03', 10, 'uuuu', 2),
(13, 1, '2019-04-03', 12, 'shsh', 1),
(14, 1, '2019-04-03', 10, 'shsu', 2),
(15, 1, '2019-04-04', 4, 'cepetin dong', 2),
(16, 1, '2019-04-04', 12, 'user', 2),
(18, 4, '2019-04-05', 10, 'gpl', 1);

-- --------------------------------------------------------

--
-- Table structure for table `stok_`
--

CREATE TABLE `stok_` (
  `_id` int(3) NOT NULL,
  `_idMasakan` int(3) NOT NULL,
  `_jumlah` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stok_`
--

INSERT INTO `stok_` (`_id`, `_idMasakan`, `_jumlah`) VALUES
(1, 11, 0),
(2, 13, 4),
(3, 15, 17),
(4, 14, 30),
(5, 17, 8),
(6, 16, 3),
(7, 18, 50),
(8, 19, 3),
(9, 20, 11),
(10, 21, 4),
(11, 22, 3);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_`
--

CREATE TABLE `transaksi_` (
  `_id` int(4) NOT NULL,
  `_idUser` int(1) NOT NULL,
  `_idOrder` int(4) NOT NULL,
  `_tanggal` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `_totalBayar` int(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaksi_`
--

INSERT INTO `transaksi_` (`_id`, `_idUser`, `_idOrder`, `_tanggal`, `_totalBayar`) VALUES
(12, 3, 1, '2019-02-18 01:19:01', 84000),
(17, 11, 2, '2019-02-18 01:43:10', 40000),
(20, 10, 13, '2019-04-04 14:37:20', 412000),
(21, 11, 18, '2019-04-05 01:38:41', 164000),
(22, 11, 2, '2019-04-05 15:00:50', 40000);

--
-- Triggers `transaksi_`
--
DELIMITER $$
CREATE TRIGGER `AFTER_TRANSAKSI` AFTER INSERT ON `transaksi_` FOR EACH ROW BEGIN
DECLARE levelUser INT(1);
SELECT _id_level INTO levelUser FROM user_ WHERE _id = NEW._idUSer;
UPDATE order_ set _statusOrder = 1 WHERE _id = NEW._idOrder;
IF levelUser = 5 THEN
UPDATE user_ SET _status = 2 WHERE _id = NEW._idUser;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_`
--

CREATE TABLE `user_` (
  `_id` int(3) NOT NULL,
  `_username` varchar(20) NOT NULL,
  `_password` varchar(80) NOT NULL,
  `_namaUser` varchar(30) NOT NULL,
  `_noMeja` int(2) DEFAULT NULL,
  `_id_level` int(1) NOT NULL,
  `_status` int(1) NOT NULL DEFAULT '1' COMMENT '1 = bisa order, 2 = gak bisa order butuh approval dari kasir atau waiter'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_`
--

INSERT INTO `user_` (`_id`, `_username`, `_password`, `_namaUser`, `_noMeja`, `_id_level`, `_status`) VALUES
(3, 'aditya', '$2y$10$q0g7U3sxEB.iLXKWineNV.laXr/IfAhKC1ImmWNYUgKJfsQ2XpbOG', 'aditya', 2, 1, 1),
(4, 'nino', '$2y$10$q0g7U3sxEB.iLXKWineNV.laXr/IfAhKC1ImmWNYUgKJfsQ2XpbOG', 'ninoko', 3, 3, 1),
(10, 'gustanas', '$2y$10$q0g7U3sxEB.iLXKWineNV.laXr/IfAhKC1ImmWNYUgKJfsQ2XpbOG', 'Gustana Satiawan', 4, 4, 1),
(11, 'hahi', '$2y$10$PYSvprLI3sfYnrZE.q1WGuMZ54.bJB4thtglIjmSORoPW0Ej6nIsS', 'hahahi', 5, 2, 1),
(12, 'lulu', '$2y$10$PYSvprLI3sfYnrZE.q1WGuMZ54.bJB4thtglIjmSORoPW0Ej6nIsS', 'LuluLala', 1, 5, 1),
(13, 'popy', '$2y$10$32tyVO7QWJuXP8igxzwK2ukLc5/1y1E3JlWu4TFAdH12wQd1QmIhu', 'popy', NULL, 5, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_order_`
--
ALTER TABLE `detail_order_`
  ADD PRIMARY KEY (`_id`),
  ADD KEY `_idOrder` (`_idOrder`),
  ADD KEY `_idMasakan` (`_idMasakan`);

--
-- Indexes for table `level_`
--
ALTER TABLE `level_`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `masakan_`
--
ALTER TABLE `masakan_`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `meja_`
--
ALTER TABLE `meja_`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `order_`
--
ALTER TABLE `order_`
  ADD PRIMARY KEY (`_id`),
  ADD KEY `_idUser` (`_idUser`),
  ADD KEY `_noMeja` (`_noMeja`);

--
-- Indexes for table `stok_`
--
ALTER TABLE `stok_`
  ADD PRIMARY KEY (`_id`),
  ADD KEY `_idMasakan` (`_idMasakan`);

--
-- Indexes for table `transaksi_`
--
ALTER TABLE `transaksi_`
  ADD PRIMARY KEY (`_id`),
  ADD KEY `_idUser` (`_idUser`),
  ADD KEY `_idOrder` (`_idOrder`);

--
-- Indexes for table `user_`
--
ALTER TABLE `user_`
  ADD PRIMARY KEY (`_id`),
  ADD KEY `_id_level` (`_id_level`),
  ADD KEY `_noMeja` (`_noMeja`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_order_`
--
ALTER TABLE `detail_order_`
  MODIFY `_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `level_`
--
ALTER TABLE `level_`
  MODIFY `_id` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `masakan_`
--
ALTER TABLE `masakan_`
  MODIFY `_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `meja_`
--
ALTER TABLE `meja_`
  MODIFY `_id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `order_`
--
ALTER TABLE `order_`
  MODIFY `_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `stok_`
--
ALTER TABLE `stok_`
  MODIFY `_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `transaksi_`
--
ALTER TABLE `transaksi_`
  MODIFY `_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `user_`
--
ALTER TABLE `user_`
  MODIFY `_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_order_`
--
ALTER TABLE `detail_order_`
  ADD CONSTRAINT `detail_order__ibfk_1` FOREIGN KEY (`_idOrder`) REFERENCES `order_` (`_id`),
  ADD CONSTRAINT `detail_order__ibfk_2` FOREIGN KEY (`_idMasakan`) REFERENCES `masakan_` (`_id`);

--
-- Constraints for table `order_`
--
ALTER TABLE `order_`
  ADD CONSTRAINT `order__ibfk_1` FOREIGN KEY (`_idUser`) REFERENCES `user_` (`_id`),
  ADD CONSTRAINT `order__ibfk_2` FOREIGN KEY (`_noMeja`) REFERENCES `meja_` (`_id`);

--
-- Constraints for table `stok_`
--
ALTER TABLE `stok_`
  ADD CONSTRAINT `stok__ibfk_1` FOREIGN KEY (`_idMasakan`) REFERENCES `masakan_` (`_id`);

--
-- Constraints for table `transaksi_`
--
ALTER TABLE `transaksi_`
  ADD CONSTRAINT `transaksi__ibfk_1` FOREIGN KEY (`_idUser`) REFERENCES `user_` (`_id`),
  ADD CONSTRAINT `transaksi__ibfk_2` FOREIGN KEY (`_idOrder`) REFERENCES `order_` (`_id`);

--
-- Constraints for table `user_`
--
ALTER TABLE `user_`
  ADD CONSTRAINT `user__ibfk_1` FOREIGN KEY (`_id_level`) REFERENCES `level_` (`_id`),
  ADD CONSTRAINT `user__ibfk_2` FOREIGN KEY (`_noMeja`) REFERENCES `meja_` (`_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
