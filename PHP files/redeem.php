<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Credentials: true");

$hostname = "localhost";
$database = "melakago";
$username = "root";
$password = "wingerssrc1519";


$db = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
// initial response code
// response code will be changed if the request goes into any of the processes

http_response_code(404);
$response = new stdClass();

$jsonbody = json_decode(file_get_contents('php://input'));

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try {
        if (isset($jsonbody->rewardId, $jsonbody->appUserId, $jsonbody->pointsRedeemed, $jsonbody->dateRedeemed, $jsonbody->expirationDate, $jsonbody->status)) {
            
            $rewardId = $jsonbody->rewardId;
            $appUserId = $jsonbody->appUserId;
			$claimCode = $jsonbody->claimCode;
            $pointsRedeemed = $jsonbody->pointsRedeemed;
            $dateRedeemed = $jsonbody->dateRedeemed;
            $expirationDate = $jsonbody->expirationDate;
            $status = $jsonbody->status;

            // Assuming the table name is 'redeem' (you can adjust it as needed)
            $stmt = $db->prepare("INSERT INTO redeemreward (rewardId, appUserId, claimCode, pointsRedeemed, dateRedeemed, expirationDate, status)
			VALUES (:rewardId, :appUserId, :claimCode, :pointsRedeemed, :dateRedeemed, :expirationDate, :status)");
            $stmt->bindParam(':rewardId', $rewardId);
            $stmt->bindParam(':appUserId', $appUserId);
			$stmt->bindParam(':claimCode', $claimCode);
            $stmt->bindParam(':pointsRedeemed', $pointsRedeemed);
            $stmt->bindParam(':dateRedeemed', $dateRedeemed);
            $stmt->bindParam(':expirationDate', $expirationDate);
            $stmt->bindParam(':status', $status);

            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                http_response_code(200);
                $response->message = "Reward redeemed successfully.";
            } else {
                http_response_code(401);  // Unauthorized
                $response->error = "Failed to redeem reward.";
            }
        } else {
            http_response_code(400);  // Bad Request
            $response->error = "Invalid JSON format. All fields (rewardId, appUserId, pointsRedeemed, dateRedeemed, expirationDate, status) are required.";
        }
    } catch (Exception $ee) {
        http_response_code(500);
        $response->error = "Error occurred " . $ee->getMessage();
    }
} else {
    http_response_code(405);  // Method Not Allowed
    $response->error = "Method Not Allowed. Only POST requests are allowed for redemption.";
}

echo json_encode($response);
exit();
?>
