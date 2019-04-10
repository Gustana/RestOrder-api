<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $namaMasakan = $_POST['namaMasakan'];
        $hargaMasakan = $_POST['hargaMasakan'];
        $jenisMasakan = $_POST['jenisMasakan'];
        $jumlahMasakan = $_POST['jumlahMasakan'];
        $statusMasakan = $_POST['statusMasakan'];
        $deskripsiMasakan = $_POST['deskripsiMasakan'];

        $namaMasakan = strtoupper($namaMasakan);

        $db = new Database();

        echo $db->sendInsertUniqueDataResponse("SELECT _namaMasakan FROM masakan_ WHERE _namaMasakan = '$namaMasakan'", 
                                            "INSERT INTO masakan_(_namaMasakan, _harga, _jenisMasakan, _deskripsi, _statusMasakan)
                                            VALUES ('$namaMasakan', $hargaMasakan, $jenisMasakan, '$deskripsiMasakan', $statusMasakan)");
    }
?>