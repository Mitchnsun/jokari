<?php
	
	try { /* DB */
    require_once ('../connect_DB.php');
  } catch (Exception $e) {
    $response = array("status" => 500, "errorCode" => "BD", "message" => $e -> getMessage());
    echo json_encode($response);
    die();
  }
	
	class Teams {
		private $bdd;
		private $httpStatus;
		private $availableMethods = array(
			"GET" => 100,
			"DELETE" => 405
		);
		public function initialize($httpStatus, $id){
			$this -> httpStatus = $httpStatus;
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
			echo "It works!";
		}
		
		/**
		 * Return JSON a list of object or one object if id defined
		 * GET /users/:id
		 */
	}
?>