<?php
header("Access-Control-Allow-Origin: *"); // running on local host can access from any origin

// $servername = "localhost";
// $username = "root";
// $password = "";
// $dbname = "pawpal_db";

// $conn = new mysqli($servername, $username, $password, $dbname);
// if ($conn->connect_error) {
//     die("Connection failed: " . $conn->connect_error);
// }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {//check request method
    if (!isset($_POST['email']) || !isset($_POST['password'])) {// check email and password are set and not null
        $response = array('status' => 'failed', 'message' => 'Bad Request');
        sendJsonResponse($response);// send response from json function
        exit();
    }
    // get email and password from the interface
    $email = $_POST['email'];
    $password = $_POST['password'];
    $hashedpassword = sha1($password);// hash password using sha1
    include 'pawpaldbconnection.php';
    // sql query to select user with matching email and password
    $sqllogin = "SELECT * FROM `tbl_users` WHERE `email` = '$email' AND `password` = '$hashedpassword'";
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {// check if any row is returned
        $userdata = array();
        while ($row = $result->fetch_assoc()) {// fetch each row when there are return value
            $userdata[] = $row;
        }
        $response = array('status' => 'success', 'message' => 'Login successful', 'data' => $userdata);// prepare response array if seccess
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Invalid email or password','data'=>null);// prepare response array if failed
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed', 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}




function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>