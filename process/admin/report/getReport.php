<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {

        $jenisMasakan = $_GET['jenis_masakan'];

        $db = new Database();

        echo $db->sendGetDataResponse("call SP_getReport($jenisMasakan)");
    }
?>