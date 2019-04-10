<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        $db = new Database();

        echo $db->sendGetDataResponse("Call SP_getFoodList(2)");
    }
?>