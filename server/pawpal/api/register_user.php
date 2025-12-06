<?php
	header("Access-Control-Allow-Origin: *"); //running can access the server from any origin
	include 'pawpaldbconnection.php';//database connection

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {// check request method
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	// check if all required fields are present
	if (!isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['name']) || !isset($_POST['phone'])) {
		http_response_code(400);
		echo json_encode(array('error' => 'Bad Request'));
		exit();
	}
	//get the values from the post request
	$email = ($_POST['email']);
	$name = ($_POST['name']);
	$phone = ($_POST['phone']);
	$password = $_POST['password'];
	$hashedpassword = sha1($password);

	// Check if email already exists / duplication
	$sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";
	$result = $conn->query($sqlcheckmail);
	if ($result->num_rows > 0){
		$response = array('status' => 'failed', 'message' => 'Email already registered');
		sendJsonResponse($response);
		exit();
	}

	//Insert new user into database
	$sqlregister = "INSERT INTO tbl_users (email, name, password, phone) 
        VALUES ('$email', '$name', '$hashedpassword', '$phone')";
	try{//check registration success or not
		if ($conn->query($sqlregister) === true){
			$response = array('status' => 'success', 'message' => 'Registration successful');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Registration unsuccessful');
			sendJsonResponse($response);
		}
	}catch(Exception $e){// check sql error statement
		$response = array('status' => 'failed', 'message' => $e->getMessage());
		sendJsonResponse($response);
	}
//	function to send json response
function sendJsonResponse($sentArray)//change function into json format for response to client
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
