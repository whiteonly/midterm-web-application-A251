<?php
// payment.php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// 1. Get parameters from your app
$useremail = $_GET['email'] ?? '';
$phone     = $_GET['phone'] ?? '';
$name      = $_GET['name'] ?? '';
$credit    = $_GET['credits'] ?? 0;
$userid    = $_GET['userid'] ?? '';
$petid     = $_GET['petid'] ?? '';

// 2. Validate
if (empty($useremail) || empty($name) || $credit <= 0) {
    die("Error: Missing required parameters.");
}

// 3. Configuration
$api_key       = '1cbb365c-5ee3-4b69-bb8b-ce048dd20e50';
$collection_id = '2kyakrd6';
$amount        = intval($credit * 100); 

$base_url = 'https://socstudentmusicforlife.com/azri/pawpal/pawpal/api/';

// 4. Build the Redirect URL with ALL parameters
// We pass these so they come back to us in payment_update.php
$params = http_build_query([
    'u_email'  => $useremail,
    'u_phone'  => $phone,
    'u_name'   => $name,
    'u_userid' => $userid,
    'u_petid'  => $petid,
    'u_amount' => $credit
]);

$redirect_url = $base_url . 'payment_update.php?' . $params;

// 5. Create Billplz Bill
$data = [
    'collection_id' => $collection_id,
    'email'         => $useremail,
    'name'          => $name,
    'amount'        => $amount,
    'description'   => 'Donation for Pet ID: ' . $petid,
    'callback_url'  => $redirect_url, // Also used for webhook
    'redirect_url'  => $redirect_url
];

$ch = curl_init('https://billplz-sandbox.com/api/v3/bills');
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST           => true,
    CURLOPT_POSTFIELDS     => http_build_query($data),
    CURLOPT_USERPWD        => $api_key . ':',
    CURLOPT_SSL_VERIFYPEER => false,
]);

$response = curl_exec($ch);
$result   = json_decode($response, true);
curl_close($ch);

if (isset($result['url'])) {
    header("Location: " . $result['url']);
    exit();
} else {
    echo "Gateway Error: " . ($result['error']['message'] ?? 'Connection failed');
}
?>