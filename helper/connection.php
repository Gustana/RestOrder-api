<?php
    class Connection{
        private $_user = "root";
        private $_pass = "gustana";
        private $_host = "localhost";
        private $_db = "db_resto";
        protected $conn;

        public function __construct(){
            if (!isset($this->conn)) {
                $this->conn = new mysqli($this->_host, $this->_user, $this->_pass, $this->_db);
                if (!$this->conn) {
                    echo "Can't Connect";
                }
            }
            return $this->conn;
        }
    }
?>