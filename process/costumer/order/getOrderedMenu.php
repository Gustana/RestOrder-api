<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        $noMeja = $_GET['noMeja'];
        
        $db = new Database();

        echo $db->sendGetDataResponse("CALL SP_getFinishedOrder($noMeja)");
    }
?>