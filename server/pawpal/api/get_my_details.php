<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {// request method from UI
    if (!isset($_GET['userid'])) {// check parameters
        $response = array('status' => 'failed', 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
    $userid = $_GET['userid'];// get userid
    include 'pawpaldbconnection.php';
    $sqlgetuser = "SELECT * FROM `tbl_pets` WHERE `user_id` = '$userid'";// get pets of user
    $result = $conn->query($sqlgetuser);
    if ($result->num_rows > 0) {// store in the array
        $userdata = array();
        while ($row = $result->fetch_assoc()) {
            $userdata[] = $row;
        }
        $response = array('status' => 'success', 'message' => 'Success', 'data' => $userdata);
        sendJsonResponse($response);//send json response
    } else {
        $response = array('status' => 'failed', 'message' => 'Invalid request','data'=>null);
        sendJsonResponse($response);//send json response
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