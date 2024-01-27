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
        if (isset($jsonbody->qrId)) {
			
            $qrId = $jsonbody->qrId;

            // Check if the qrId exists
            $stmt = $db->prepare("SELECT * FROM quizquestion WHERE qrId=:qrId ORDER BY RAND() LIMIT 5 ");
            $stmt->bindParam(':qrId', $qrId);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
               
               $response = $stmt->fetchAll(PDO::FETCH_ASSOC);
                http_response_code(200);
               
            } else {
                http_response_code(401);  // Unauthorized
                $response->error = "Invalid QR Id.";
            }
        } else {
            http_response_code(400);  // Bad Request
            $response->error = "Invalid JSON format. QR Id is required.";
        }
    } catch (Exception $ee) {
        http_response_code(500);
        $response->error = "Error occurred " . $ee->getMessage();
    }
} else if ($_SERVER["REQUEST_METHOD"] == "GET") {
    // Check if qrId is provided in the URL
    if (isset($_GET['qrId'])) {
        try {
            // Get the provided qrId
            $providedQrId = $_GET['qrId'];

            // Using a prepared statement to prevent SQL injection
            $stmt = $db->prepare("SELECT * FROM quizquestion WHERE qrId = :providedQrId ORDER BY RAND() LIMIT 5");
            $stmt->bindParam(':providedQrId', $providedQrId);
            $stmt->execute();

            // Fetch all rows as an associative array
            $response = $stmt->fetchAll(PDO::FETCH_ASSOC);
            http_response_code(200);
        } catch (Exception $ee) {
            http_response_code(500);
            $response->error = "Error occurred " . $ee->getMessage();
        }
    } else {
        http_response_code(400);  // Bad Request
        $response->error = "Missing qrId parameter in the URL.";
    }
}

echo json_encode($response);
exit();
?>
