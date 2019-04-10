<?php
    require_once('../../../helper/database.php');

    if($_SERVER['REQUEST_METHOD'] == 'GET'){

        $noMeja = $_GET['noMeja'];

        $db = new Database();

        echo $db->sendGetDataResponse("call SP_getOrderPerTable($noMeja)");
    }
?>