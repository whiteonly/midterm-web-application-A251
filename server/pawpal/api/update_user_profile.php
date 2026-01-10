<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'pawpaldbconnection.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    sendJsonResponse([
        'status' => 'failed',
        'message' => 'Method Not Allowed'
    ]);
    exit();
}

// ---------- Get POST data ----------
$user_id = $_POST['user_id'] ;
$name    = $_POST['name'] ;
$phone   = $_POST['phone'] ;
$image   = $_POST['image'] ?? null;

if (!$user_id || !$name || !$phone) {
    sendJsonResponse(['status' => 'failed', 'message' => 'Missing required fields']);
    exit();
}

try {
    // update user profile of name , phone number and photo only
    $sqlUpdateUser = "
        UPDATE tbl_users
        SET name = '$name',
            phone = '$phone'
        WHERE user_id = '$user_id'
    ";
    if (!$conn->query($sqlUpdateUser)) {
        throw new Exception("Failed to update user profile");
    }
    if (!empty($image)) { //Handle profile image

        $decodedImage = base64_decode($image);
        $path = "../../assets/profile/profile_$user_id.png";
        $imageUrl = "pawpal/assets/profile/profile_$user_id.png";

        if (file_put_contents($path, $decodedImage) === false) {
            throw new Exception("Failed to save profile image");
        }
        //add images based on user id and when duplication happen it will replace when there new profile picture
        $sqlUpdateImage = "
            INSERT INTO tbl_profile (user_id, profile_img)
            VALUES ('$user_id', '$imageUrl')
            ON DUPLICATE KEY UPDATE profile_img = '$imageUrl'
        ";

        if (!$conn->query($sqlUpdateImage)) {
            throw new Exception("Failed to update profile image");
        }
    }
    
    $sqlFetchUser = "
        SELECT u.user_id, u.name, u.email, u.phone, p.profile_img
        FROM tbl_users u
        LEFT JOIN tbl_profile p ON u.user_id = p.user_id
        WHERE u.user_id = '$user_id'
    ";

    $result = $conn->query($sqlFetchUser);
    $user = $result->fetch_assoc();

    sendJsonResponse([
        'status' => 'success',
        'message' => 'Profile updated successfully',
        'user' => $user,
        'image_url' => $imageUrl ?? ''

    ]);

} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => $e->getMessage()
    ]);
}

function sendJsonResponse($array)
{
    echo json_encode($array);
}
?>
