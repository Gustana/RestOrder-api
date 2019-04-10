<?php
    require_once ('../../../helper/database.php');

    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $noMeja = $_POST['noMeja'];

        $db = new Database();

        $selectTableNo = "SELECT * FROM meja_ WHERE _noMeja = $noMeja";
        $insertTableNo = "INSERT INTO meja_(_noMeja) VALUES($noMeja)";

        echo $db->sendInsertUniqueDataResponse($selectTableNo, $insertTableNo);
    }
?>