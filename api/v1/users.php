<?php

	require_once '../HTTPStatus.php';
	require_once '../connect_DB.php';
	
	class Users {
		private $bdd;
		private $httpStatus;
		private $availableMethods = array(
			"GET" => 100,
			"DELETE" => 405
		);
		public function initialize($id){
			$this -> httpStatus = new HTTPStatus();
			$this -> bdd = new DataBase();
			$this -> bdd -> init();
			$status = $this -> availableMethods[$_SERVER['REQUEST_METHOD']];
			
			if($status != 100){
				$this -> httpStatus -> error($status);
				exit();
			}
			
			switch($_SERVER['REQUEST_METHOD']){
				case "GET":
					$this -> get($id);
					break;
				default:
					$this -> httpStatus -> error(501);
			}
		}
		/*** Private functions ***/
		private function get($id){
			if(isset($id)){
				$this -> httpStatus -> error(501);
			} else {
				$this -> count();
			}
		}
		
		/**
		 * Return JSON of number of users or a sepcific user
		 * GET /users/:id
		 */
		 private function count(){
		  $query = "SELECT COUNT(*) FROM users";
		 	$req = $this -> bdd -> bdd_users -> query($query);
			$result = $req -> fetch();
			$users = array("count" => $result["COUNT(*)"]);
			
			// return the JSON
		  echo json_encode($users);
		 }
	}
?>