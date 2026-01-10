<?php
// payment_update.php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("pawpaldbconnection.php");

// 1. Capture the Billplz status
$billId = $_GET['billplz']['id'] ?? '';
$paid   = $_GET['billplz']['paid'] ?? '';

// 2. Capture our custom parameters from the URL
$email  = $_GET['u_email'] ?? '';
$name   = $_GET['u_name'] ?? '';
$phone  = $_GET['u_phone'] ?? '';
$userid = $_GET['u_userid'] ?? '';
$petid  = $_GET['u_petid'] ?? '';
$amount = $_GET['u_amount'] ?? 0;

$status_message = "";

// 3. Logic: If paid is true, save to database
if ($paid === 'true' && !empty($billId)) {
    
    // Create a unique description to prevent duplicate refresh inserts
    $description = "Billplz ID: $billId | Pet: $petid";
    
    // Check if this Bill ID is already in the database
    $check = $conn->prepare("SELECT donation_id FROM tbl_donations WHERE description LIKE ?");
    $search = "%$billId%";
    $check->bind_param("s", $search);
    $check->execute();
    $res = $check->get_result();

    if ($res->num_rows == 0) {
        // Insert into database
        $sql = "INSERT INTO tbl_donations (pet_id, user_id, donation_type, amount, description, donor_name, donor_email, donor_phone, donation_date) 
                VALUES (?, ?, 'Money', ?, ?, ?, ?, ?, NOW())";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssdssss", $petid, $userid, $amount, $description, $name, $email, $phone);
        
        if ($stmt->execute()) {
            $status_message = "Thank you! Your donation has been recorded.";
        } else {
            $status_message = "Error saving donation: " . $conn->error;
        }
        $stmt->close();
    } else {
        $status_message = "Payment confirmed (Already recorded).";
    }
    $check->close();
} else {
    $status_message = "Payment was not successful or was cancelled.";
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Donation Status</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding: 50px; background: #f4f4f4; }
        .card { background: white; padding: 30px; border-radius: 10px; display: inline-block; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="card">
        <h1 class="<?php echo ($paid === 'true') ? 'success' : 'error'; ?>">
            <?php echo ($paid === 'true') ? 'Success!' : 'Payment Failed'; ?>
        </h1>
        <p><?php echo $status_message; ?></p>
        <p>Transaction ID: <?php echo htmlspecialchars($billId); ?></p>
        <br>
        <button onclick="window.close()">Close Window</button>
    </div>
</body>
</html>