<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'pawpaldbconnection.php';

    if ($conn->connect_error) {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Database connection failed: ' . $conn->connect_error
        ]);
        exit();
    }

    if (isset($_GET['user_id']) && !empty($_GET['user_id'])) {// Check if user_id is provided
        $user_id = $conn->real_escape_string($_GET['user_id']);// Sanitize input
        // Query matches your exact table structure
        $sqlloadDonations = "SELECT 
            donation_id,
            pet_id,
            user_id,
            donation_type,
            amount,
            description,
            donor_name,
            donor_email,
            donor_phone,
            donation_date
        FROM tbl_donations 
        WHERE user_id = '$user_id' 
        ORDER BY donation_date DESC";
        $result = $conn->query($sqlloadDonations);// Execute query
        if ($result === false) {
            error_log("ERROR: Query failed: " . $conn->error);
            sendJsonResponse([
                'status' => 'failed',
                'message' => 'Query error: ' . $conn->error
            ]);
            exit();
        }
        $number_of_result = $result->num_rows;// Get number of results
        error_log("DEBUG: Number of results: $number_of_result");

        if ($number_of_result > 0) {
            $Donationdata = array();
            while ($row = $result->fetch_assoc()) {
                // Ensure amount is formatted as string with 2 decimal places
                if (isset($row['amount'])) {
                    $row['amount'] = number_format((float)$row['amount'], 2, '.', '');
                }
                
                // Ensure all IDs are strings
                $row['donation_id'] = strval($row['donation_id']);
                $row['pet_id'] = strval($row['pet_id']);
                $row['user_id'] = strval($row['user_id']);
                
                $Donationdata[] = $row;// Append each row to the data array
                error_log("DEBUG: Row data: " . json_encode($row));
            }
            
            $response = array(
                'status' => 'success', 
                'data' => $Donationdata, 
                'numberofresult' => $number_of_result
            );
            sendJsonResponse($response);
        } 
    } else {
        error_log("ERROR: No user_id provided");
        $response = array(
            'status' => 'failed', 
            'message' => 'No user_id provided'
        );
        sendJsonResponse($response);
    }

} else {
    $response = array(
        'status' => 'failed', 
        'message' => 'Invalid request method. Only GET is allowed.'
    );
    sendJsonResponse($response);
}

$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>