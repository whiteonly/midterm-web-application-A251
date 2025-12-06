<?php
	header("Access-Control-Allow-Origin: *");
	include 'pawpaldbconnection.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}

	$user_id = ($_POST['user_id']);
	$pet_name = addslashes($_POST['pet_name']);
	$pet_type = addslashes($_POST['pet_type']);
	$category = addslashes($_POST['category']);
	$lat = $_POST['lat'];
	$lng = $_POST['lng'];
	$description = addslashes($_POST['description']);
	$image_paths_raw  = $_POST['image_paths'];

	// Split multiple images using your "|||" separator
	$image_list = explode("|||", $image_paths_raw);

	$final_image_paths = []; // filenames to save into ONE column

	foreach ($image_list as $index => $imgBase64) {
		if (strlen($imgBase64) < 5) continue; // skip empty

		$imgData = base64_decode($imgBase64);

		// create unique filename
		$filename = "pet_" . time() . "_" . $index . ".png";
		$filepath = "../../assets/uploads/pet_" . $filename;

		// save image file
		file_put_contents($filepath, $imgData);

		// store filename only
		$final_image_paths[] = $filename;
	}

	$image_paths = implode(",", $final_image_paths);

	// Insert new service into database
	$sqlinsertservice = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`) 
	VALUES ('$user_id','$pet_name','$pet_type','$category','$description','$image_paths','$lat','$lng')";
	try{
		if ($conn->query($sqlinsertservice) === TRUE){
			
			$response = array('status' => 'success', 'message' => 'Pet submitted successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Pet submitted not added');
			sendJsonResponse($response);
		}
	}catch(Exception $e){
		$response = array('status' => 'failed', 'message' => $e->getMessage());
		sendJsonResponse($response);
	}


//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>