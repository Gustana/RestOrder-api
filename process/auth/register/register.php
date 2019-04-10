<?php
    require_once ('../../../helper/database.php');

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {

        $db = new Database();

        $serverResponse = [];

        $fullName = $_POST['fullName'];
        $username = $_POST['userName'];
        $password = $_POST['password'];
        $level = $_POST['level'];

        $userNameEscaped = $db->escapeString($username);
        $passwordEscaped = $db->escapeString($password);
        $fullNameEscaped = $db->escapeString($fullName);
        $levelEscaped = $db->escapeString($level);

        $passwordHash = password_hash($passwordEscaped, PASSWORD_DEFAULT);

        $insertDataQuery = "INSERT INTO user_(_username, _password, _namaUser, _id_level) VALUES('$userNameEscaped', 
        '$passwordHash', '$fullNameEscaped', $levelEscaped)";

        $selectDataQuery = "SELECT * FROM user_ WHERE _userName = '$userNameEscaped'";

        echo $db->sendInsertUniqueDataResponse($selectDataQuery, $insertDataQuery);
    
    }

?>