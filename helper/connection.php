<?php
    class Connection{
        public $_user = "root";
        public $_pass = "gustana";
        public $_host = "localhost";
        public $_db = "db_resto";
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