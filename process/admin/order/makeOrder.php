<?php
    require_once ('../../../helper/database.php');

    date_default_timezone_set("Asia/Makassar");

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $noMeja = $_POST['noMeja'];
        $idUser = $_POST['idUser'];
        $keteranganOrder = $_POST['keteranganOrder'];
        $idMasakan = $_POST['idMasakan'];
        $jumlah = $_POST['jumlah'];
        $status = $_POST['status'];
        $keteranganDetail = $_POST['keteranganDetail'];
        
        $db = new Database();

        $tanggal = date('Y-m-d');
        //jalankan prosedur untuk insert data order_ kalau belum ada insert ambil id order, kalau udh ada tinggal ambil id order
        //diambil berdasarkan nomeja dan idUser
        
        $idOrder = $db->executeQuery("SELECT OrderProcess($noMeja, '$tanggal', $idUser, '$keteranganOrder') AS OrderProcess");

        $idOrder =  $idOrder['OrderProcess'];

        //Insert order_detail_ data
        echo $db->sendInsertDataResponse("INSERT INTO detail_order_(_idOrder, _idMasakan, _jumlah, _keterangan, _status)
        VALUES($idOrder, $idMasakan, $jumlah, '$keteranganDetail', $status)");
    }
?>