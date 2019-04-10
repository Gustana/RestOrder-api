<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {

        $tableNo = $_GET['tableNo'];

        $db = new Database();

        echo $db->sendGetDataResponse("call SP_getOrderPerTable(2, $tableNo)");
    }
?>