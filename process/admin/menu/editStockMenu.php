<?php
    require_once('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $idMasakan = $_POST['idMasakan'];
        $jumlah = $_POST['jumlah'];

        $db = new Database();

        echo $db->sendInsertDataResponse("UPDATE stok_ SET _jumlah = $jumlah WHERE _idMasakan = $idMasakan");

        $db->execute("CALL SP_updateStatusMenu($idMasakan)");

    }
?>