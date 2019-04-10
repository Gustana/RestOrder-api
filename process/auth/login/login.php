<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD']) {

        $db = new Database();

        $username = $_POST['username'];
        $password = $_POST['password'];

        $usernameHashed = $db->escapeString($username);
        $passwordHashed = $db->escapeString($password);

        $loginQuery = "SELECT _id, _username, _namaUser, _id_level, _noMeja, _password FROM user_ WHERE _username = '$usernameHashed' AND _status = 1";

        echo $db->sendLoginResponse($passwordHashed, $loginQuery);
    }
?>