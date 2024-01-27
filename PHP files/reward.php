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
        if (isset($jsonbody->userId)) {
            $userId = $jsonbody->userId;

            // Check if the user exists
            $stmtUser = $db->prepare("SELECT * FROM appuser WHERE appUserId = :userId");
            $stmtUser->bindParam(':userId', $userId);
            $stmtUser->execute();

            if ($stmtUser->rowCount() > 0) {
                $userData = $stmtUser->fetch(PDO::FETCH_ASSOC);
                $userPoints = $userData['points'];

                // Fetch rewards based on user points
                $stmtRewards = $db->prepare("SELECT * FROM reward WHERE rewardPoint <= :userPoints");
                $stmtRewards->bindParam(':userPoints', $userPoints);
                $stmtRewards->execute();

                if ($stmtRewards->rowCount() > 0) {
                    $response = $stmtRewards->fetchAll(PDO::FETCH_ASSOC);
                    http_response_code(200);
                } else {
                    http_response_code(204);  // No Content
                    $response->error = "No rewards available for the given user points.";
                }
            } else {
                http_response_code(401);  // Unauthorized
                $response->error = "Invalid user ID.";
            }
        } else {
            http_response_code(400);  // Bad Request
            $response->error = "Invalid JSON format. User ID is required.";
        }
    } catch (Exception $ee) {
        http_response_code(500);
        $response->error = "Error occurred " . $ee->getMessage();
    }
} else {
    http_response_code(405);  // Method Not Allowed
    $response->error = "Invalid request method. Only POST requests are allowed.";
}

echo json_encode($response);
exit();
?>