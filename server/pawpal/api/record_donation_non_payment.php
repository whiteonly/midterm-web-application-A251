<?php
include_once("pawpaldbconnection.php");
//get data from user input
$pet_id = $_POST['pet_id'];
$user_id = $_POST['user_id'];
$donation_type = $_POST['donation_type'];
$description = $_POST['description'];
$donor_name = $_POST['donor_name'];
$donor_email = $_POST['donor_email'];
$donor_phone = $_POST['donor_phone'];

// Insert non-money donation (Food/Medical) - only description, no amount
$sqlinsert = "INSERT INTO `tbl_donations`(`pet_id`, `user_id`, `donation_type`, `description`, `donor_name`, `donor_email`, `donor_phone`) 
              VALUES ('$pet_id', '$user_id', '$donation_type', '$description', '$donor_name', '$donor_email', '$donor_phone')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Donation recorded successfully');
    echo json_encode($response);
} else {
    $response = array('status' => 'failed', 'message' => $conn->error);
    echo json_encode($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>