<?php
	/* Production */
	/* Development */
	$host = 'localhost';
	$db_jokari = 'jokari';
	$db_users = 'users';
	$db_login = 'Jokari';
	$db_pwd = '';
	
	try{
		//$bdd_jokari = new PDO('mysql:host='.$host.';dbname='.$db_jokari,$db_login,$db_pwd);
		$bdd_users = new PDO('mysql:host='.$host.';dbname='.$db_users,$db_login,$db_pwd);
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
?>