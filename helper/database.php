<?php
    require_once ('../../../helper/connection.php');

    class Database extends Connection{

        private $serverResponse = [];

        /**
        *invoke parent's construct method
        */
        public function __construct(){
            parent::__construct();
        }

        public function __destruct(){
            $this->conn->close();
        }

        /**
        *@param query
        *@return boolean
        */
        public function isDataExist($result){
            $row_count = $result->num_rows;
            if ($row_count == 0) {
                return false;
            }
            return true;
        }

        /**
        *@param query
        *@return boolean
        *facing problem of how to check stock avaliablility
        *we'll use this method
        *considering that make query use ckeck_stock strored function
        */
        public function isStockAvaliable($query){
            return $this->conn->query($query);
        }

        /**
        *@param query
        *@return json_encode
        */
        public function sendLoginResponse($password, $query){
            $result = $this->conn->query($query);
            $isDataExist = $this->isDataExist($result);
            
            $data = $this->fetchData($result);

            $arrayData = $data['0'];
            $passwordHashed = $arrayData['_password'];

            if (password_verify($password, $passwordHashed)) {
                if ($isDataExist) {
                    //Unset array element 'password' so it won't send to server
                    unset($arrayData['_password']);

                    $serverResponse = [
                        "isError" => false,
                        "message" => "Success",
                        "data" => $arrayData
                    ];
                }else{
                    $serverResponse = [
                        "isError" => true,
                        "message" => "Username Or Password Might Be Wrong",
                        "data" => null
                    ];
                }   
            }else{
                $serverResponse = [
                    "isError" => true,
                    "message" => "Username Or Password Might Be Wrong",
                    "data" => null
                ];
            }
            return $this->encodeResponse($serverResponse);
        }

        /** 
        *@param query
        *
        */
        public function sendGetDataResponse($query){
            $result = $this->conn->query($query);
            $isDataExist = $this->isDataExist($result);

            if ($isDataExist) {
                $data = $this->fetchData($result);

                $serverResponse = [
                    "isError" => false,
                    "message" => "Success",
                    "data" => $data
                ];
            }else{
                $serverResponse = [
                    "isError" => true,
                    "message" => "Data Empty"
                ];
            }

            return $this->encodeResponse($serverResponse);
        }

        /** 
        *@param result of query
        *@return array
        */
        public function fetchData($result){
            while($row = $result->fetch_assoc()){
                $data[] = $row;
            }

            return $data;
        }

        /** 
        *@param query
        *@return json_encode
        */
        public function sendInsertResponse($query){
            $result = $this->conn->query($query);
            if ($result) {
                $serverResponse = [
                    "isError" => false,
                    "message" => "Success"
                ];
            }else{
                $serverResponse = [
                    "isError" => true,
                    "message" => "Failed"
                ];
            }
            return $this->encodeResponse($serverResponse);
        }

        /** 
        *@param selectDataQuery
        *@param insertDataQuery
        *@return json_encode
        */
        public function sendInsertUniqueDataResponse($selectDataQuery, $insertDataQuery){
            $result = $this->conn->query($selectDataQuery);
            $isDataExist = $this->isDataExist($result);
            if ($isDataExist) {
                $serverResponse = [
                    "isError" => true,
                    "message" => "The data has been registered"
                ];
            }else{
                $result = $this->conn->query($insertDataQuery);
                if ($result) {
                    $serverResponse = [
                        "isError" => false,
                        "message" => "Success"
                    ];
                }else{
                    $serverResponse = [
                        "isError" => true,
                        "message" => "Failed"
                    ];
                }
            }
            return $this->encodeResponse($serverResponse);
        }

        /**
        *@param query
        *@return json_encode
        */
        public function sendInsertDataResponse($query){
            $result = $this->conn->query($query);
            if ($result) {
                $serverResponse = [
                    "isError" => false,
                    "message" => "Success"
                ];
            }else{
                $serverResponse = [
                    "isError" => true,
                    "message" => "Failed"
                ];
            }
            return $this->encodeResponse($serverResponse);
        }

        /**
        *@param serverResponse
        *@return json_encode
        */
        public function encodeResponse($serverResponse){
            return json_encode(array("serverResponse" => $serverResponse));
        }


        /**
        *@param string
        *@return hashedString
         */
        public function escapeString($string){
            return mysqli_real_escape_string($this->conn, $string);
        }

        public function executeQuery($query){
            $result = $this->conn->query($query);
            $data = $result->fetch_assoc();
            return $data;
        }

        public function execute($query){
            $this->conn->query($query);
        }

        public function __autoload($className){
            if (file_exists($className . '.php')) {
                require_once $className . '.php';
                return true;
            }
            return false;
        }

    }
?>
