<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $status = $_POST['status'];
        $orderId = $_POST['orderId'];
        $idMasakan = $_POST['idMasakan'];

        $db = new Database();

        echo $db->sendInsertDataResponse("UPDATE detail_order_ SET _status = $status WHERE _idOrder = $orderId 
        AND _idMasakan = $idMasakan");
    }
?>