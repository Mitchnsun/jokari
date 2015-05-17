<?php
	class Router {
		private $routes = array(
			"teams" => "teams.php"
		);
		
		public function getClass ($name){
			switch ($name){
				case "users":
					require_once "users.php";
					return new Teams();
				default :
					return 404;
			}
		}
	}
?>