<?php
    require_once('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {

        $jenisMasakan = $_GET['jenis_masakan'];
        $bulan = $_GET['bulan'];
        $tahun = $_GET['tahun'];

        $db = new Database();

        $tanggalAwal = $tahun ."-". $bulan ."-". "01";
        $tanggalAkhir = $tahun ."-". $bulan ."-". "31";

        /**
        *Sp_getReportFiltered(
            jenis_masakan,
            tanngal awal filter, 
            tanggal akhir
        *)
        */

        echo $db->sendGetDataResponse("call SP_getReportFiltered($jenisMasakan, '$tanggalAwal', '$tanggalAkhir')");

    }
?>