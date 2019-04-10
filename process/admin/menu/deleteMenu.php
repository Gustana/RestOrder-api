<?php
    require_once ('../../../helper/database.php');
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $idMasakan = $_POST['idMasakan'];

        $db = new Database();

        echo $db->sendInsertDataResponse("UPDATE masakan_ SET _status = 2 WHERE _id = $idMasakan");
    }
?>