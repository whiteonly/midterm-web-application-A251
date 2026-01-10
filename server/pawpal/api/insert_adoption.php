<?php
header("Access-Control-Allow-Origin: *");
include 'pawpaldbconnection.php';

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

// Retrieve and sanitize POST parameters
$user_id = ($_POST['user_id']);
$pet_id = ($_POST['pet_id']);
$submission_id = ($_POST['submission_id']);
$motivation = addslashes($_POST['motivation']);


// Validation - check if required fields are not empty
if (empty($user_id) || empty($pet_id) || empty($submission_id) || empty($motivation)) {
    $response = array('status' => 'failed', 'message' => 'All fields are required');
    sendJsonResponse($response);
    exit();
}

// Check if user already submitted request for this pet
$check_sql = "SELECT id FROM tbl_adoptions WHERE user_id='$user_id' AND pet_id='$pet_id'";
$check_result = $conn->query($check_sql);

if ($check_result->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'You have already submitted an adoption request for this pet');
    sendJsonResponse($response);
    exit();
}

// Check if ANY USER already submitted request for this pet (prevents duplicate adoptions)
$check_pet_sql = "SELECT id, user_id FROM tbl_adoptions WHERE pet_id='$pet_id'";
$check_pet_result = $conn->query($check_pet_sql);

if ($check_pet_result->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'This pet already has a pending adoption request from another user');
    sendJsonResponse($response);
    exit();
}

// Insert adoption request into database
$sqlinsertadoption = "INSERT INTO `tbl_adoptions`(`user_id`, `pet_id`, `submission_id`, `motivation`) 
VALUES ('$user_id','$pet_id','$submission_id','$motivation') ";

try {
    if ($conn->query($sqlinsertadoption) === TRUE) {
        $adoption_id = $conn->insert_id;
        $response = array('status' => 'success', 'message' => 'Adoption request submitted successfully', 'adoption_id' => $adoption_id);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to submit adoption request');
        sendJsonResponse($response);
    }
} catch(Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
    sendJsonResponse($response);
}

// Function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>