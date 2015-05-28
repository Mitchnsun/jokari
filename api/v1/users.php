<?php

	require_once '../HTTPStatus.php';
	require_once '../connect_DB.php';
	
	class Users {
		private $bdd;
		private $httpStatus;
		private $availableMethods = array(
			"GET" => 100,
			"POST" => 100,
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
				case "POST":
					$this -> submit();
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
		
		private function submit(){
			$response['errors'] = array();
			$today = time();
			$regex = '/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/';
			
			// POST Data
			$email = strtolower($_POST['email']);
			$password = $_POST['password'] != "" ? crypt($_POST['password'],$email) : "";
			$pseudo = $_POST['pseudo'];
			$firstname = $_POST['firstname'];
			$lastname = $_POST['lastname'];
			$FB_user = $_POST['FB_user'];
			$accreditation = "Player";
			unset($_POST); // The password no exists in clear anymore
			
			// Check value
			if($email === '' || !preg_match($regex, $email)){
				array_push($response['errors'], 'email');
			}
			if($pseudo == "" && ($firstname == "" || $lastname == "")){
				array_push($response['errors'], 'username');
			}
			
			if(count($response['errors']) > 0){
				echo json_encode($response);
				die();
			}
			
			$checkquery = "SELECT email, pseudo FROM users WHERE email = :email OR (pseudo = :pseudo AND pseudo != '')";
			$req = $this -> bdd -> bdd_users -> prepare($checkquery) or die($this -> httpStatus -> error(500));
			$req -> execute(array("email" => $email,"pseudo" => $pseudo));
			$count = $req -> rowCount();
			
			if($count > 0){
				while($result = $req -> fetch()){
					if($email == $result['email']){
						array_push($response['errors'], 'email_exists');
					}
					if($pseudo == $result['pseudo']){
						array_push($response['errors'], 'username_exists');
					}
				}
			}else { // Account creation
				$query = "INSERT INTO 
									users(FB_id,email,pwd,pseudo,firstname,lastname,gender,FB_Link,FB_ProfilePic,FB_Locale,accreditation,joinAt) 
									VALUES(:FB_id,:email,:pwd,:pseudo,:firstname,:lastname,:gender,:FB_Link,:FB_ProfilePic,:FB_Locale,:accreditation,:joinAt)";
				$req = $this -> bdd -> bdd_users -> prepare($query) or die($this -> httpStatus -> error(500));
				$req -> execute(array(
					'FB_id' => $FB_user['id'],
					'email' => $email,
					'pwd' => $password,
					'pseudo' => utf8_decode($pseudo),
					'firstname' => utf8_decode($firstname),
					'lastname' => utf8_decode($lastname),
					'gender' => $FB_user['gender'],
					'FB_Link' => $FB_user['link'],
					'FB_ProfilePic' => $FB_user['url_profilepic'],
					'FB_Locale' => $FB_user['locale'],
					'accreditation' => $accreditation,
					'joinAt' => $today
				));
			}
			
			// return the JSON
			echo json_encode($response);
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