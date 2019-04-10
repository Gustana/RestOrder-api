<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $idUser = $_POST['idUser'];
        $idOrder = $_POST['idOrder'];
        $payAmount = $_POST['payAmount'];

        $db = new Database();

        echo $db->sendInsertDataResponse("INSERT INTO transaksi_(_idUser, _idOrder, _totalBayar) 
                                        VALUES($idUser, $idOrder, $payAmount)");
    }

?>