<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'pawpaldbconnection.php';
    
    $results_per_page = 10; // number of results per page
    if ( isset( $_GET[ 'curpage' ] ) ) {
        $curpage = ( int )$_GET[ 'curpage' ];
    } else {
        $curpage = 1;
    }
    // Determine the sql LIMIT starting number for the results on the displaying page
    $page_first_result = ( $curpage - 1 ) * $results_per_page;

    // Base JOIN query to get pet and user details and profile image
    $baseQuery = "
    SELECT 
        s.pet_id,
        s.user_id,
        s.pet_name,
        s.pet_type,
        s.category,
        s.description,
        s.image_paths,
        s.lat,
        s.lng,
        s.created_at,
        s.age,
        s.gender,
        s.health,
        u.name,
        u.email,
        u.phone,
        u.reg_date,
        prof.profile_img 
    FROM tbl_pets s
    JOIN tbl_users u ON s.user_id = u.user_id
    LEFT JOIN tbl_profile prof ON prof.user_id = u.user_id
    ";

    // Search logic
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlloadservices = $baseQuery . "
            WHERE s.pet_name LIKE '%$search%' 
            ORDER BY s.pet_id DESC";
    } else {
        $sqlloadservices = $baseQuery . " ORDER BY s.pet_id DESC";
    }


    // Execute query
    $result = $conn->query($sqlloadservices);
    $number_of_result = $result->num_rows;//total number of results
    $number_of_page = ceil( $number_of_result / $results_per_page );//total number of pages
    $sqlloadservices .= " LIMIT $page_first_result, $results_per_page";//limit the number of rows returned
    $result = $conn->query($sqlloadservices);
    // Prepare and send response
    if ($result && $result->num_rows > 0) {
        $Petdata = array();
        while ($row = $result->fetch_assoc()) {
            $Petdata[] = $row;
        }
        $response = array('status' => 'success', 'data' => $Petdata,'numofpage'=>$number_of_page, 'numberofresult'=>$number_of_result);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null,'numofpage'=>$number_of_page, 'numberofresult'=>$number_of_result);
        sendJsonResponse($response);
    }

} else {
    $response = array('status' => 'failed');
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
