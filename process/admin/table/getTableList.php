<?php
    require ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        $db = new Database();
        echo $db->sendGetDataResponse("SELECT _id, _noMeja FROM meja_");
    }
?>