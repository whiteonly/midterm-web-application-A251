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
	$pet_name = addslashes($_POST['pet_name']);
	$pet_type = addslashes($_POST['pet_type']);
	$category = addslashes($_POST['category']);
	$lat = $_POST['lat'];
	$lng = $_POST['lng'];
	$description = addslashes($_POST['description']);
	$age = $_POST['age'];
	$gender = $_POST['gender'];
	$health = $_POST['health'];

	$images = []; 
	for ($i = 1; $i <= 3; $i++) {
		if (isset($_POST['image'.$i]) && !empty($_POST['image'.$i])) {
			$images[] = base64_decode($_POST['image'.$i]);
		}
	}

	// Insert new service into database
	$sqlinsertservice = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `age`, `gender`, `health`) 
	VALUES ('$user_id','$pet_name','$pet_type','$category','$description','$lat','$lng','$age','$gender','$health')";
		try{
		if ($conn->query($sqlinsertservice) === TRUE){
			$last_id = $conn->insert_id;
			$imagePaths = [];

			// Save each image file
			foreach ($images as $index => $img) {
				$imgIndex = $index + 1;
				$path = "../../assets/uploads/pet_{$last_id}_{$imgIndex}.png";
				file_put_contents($path, $img);
				$imagePaths[] = "pawpal/assets/uploads/pet_{$last_id}_{$imgIndex}.png";
			}

			// Save image paths in DB as JSON (so you can have multiple images)
			$imagePathsJson = json_encode($imagePaths);
			$sqlupdateimage = "UPDATE tbl_pets SET image_paths='$imagePathsJson' WHERE pet_id='$last_id'";
			$conn->query($sqlupdateimage);

			$response = array('status' => 'success', 'message' => 'Pet Submission added successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Pet submisson not added');
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