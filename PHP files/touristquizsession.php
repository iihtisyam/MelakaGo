<?php
// Uncomment the following lines if CORS headers are needed
// header("Access-Control-Allow-Origin: *");
// header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
// header("Access-Control-Allow-Headers: *");
// header("Access-Control-Allow-Credentials: true");

$hostname = "localhost";
$database = "melakago";
$username = "root";
$password = "wingerssrc1519";

// Create a PDO instance for database connection
$db = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);

// Set initial response code
http_response_code(404);
$response = new stdClass();

// Initialize $jsonbody variable using POST data
$jsonbody = json_decode(file_get_contents('php://input'));

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try {
        // Check if all required parameters are set
        if (
            isset($jsonbody->startTime) &&
            isset($jsonbody->endTime) &&
            isset($jsonbody->totalPoints) &&
            isset($jsonbody->appUserId)
        ) {
            // Insert the new quiz result
            $stmt = $db->prepare("INSERT INTO touristquizsession 
                (`startTime`, `endTime`, `totalPoints`, `appUserId`) 
                VALUES (:startTime, :endTime, :totalPoints, :appUserId)");

            $stmt->execute([
                ':startTime' => $jsonbody->startTime,
                ':endTime' => $jsonbody->endTime,
                ':totalPoints' => $jsonbody->totalPoints,
                ':appUserId' => $jsonbody->appUserId
            ]);

            http_response_code(200);
            $response->error = "Quiz result successfully registered";
        } else {
            http_response_code(400); // Bad Request
            $response->error = "Missing required parameters";
        }
    } catch (Exception $ee) {
        http_response_code(500);
        $response->error = "Error occurred " . $ee->getMessage();
    }
}

// Send the response as JSON
echo json_encode($response);
exit();
?>
