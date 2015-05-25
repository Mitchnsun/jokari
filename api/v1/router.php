<?php
	class Router {
		private $routes = array(
			"users" => "users.php"
		);
		
		public function getClass ($name){
			switch ($name){
				case "users":
					require_once "users.php";
					return new Users();
				default :
					return 404;
			}
		}
	}
?>