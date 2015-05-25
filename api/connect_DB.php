<?php
	class DataBase {
		public $bdd_users;
		public $bdd_jokari;
		private $host = 'localhost';
		private $db_jokari = 'jokari';
		private $db_users = 'users';
		private $db_login = 'Jokari';
		private $db_pwd = '';
		
		public function init(){
			try{
				//$this -> bdd_jokari = new PDO('mysql:host='.$this -> host.';dbname='.$this -> db_jokari,$this -> db_login,$this -> db_pwd);
				$this -> bdd_users = new PDO('mysql:host='.$this -> host.';dbname='.$this -> db_users,$this -> db_login,$this -> db_pwd);
			}
			catch(Exception $e){
				$response = array(
					"status" => 500,
					"errorCode" => "BD",
					"files" => "connect_DB.php",
					"message" => $e->getMessage()
				);
				echo json_encode($response);
				die();
			}
		}
	}
?>