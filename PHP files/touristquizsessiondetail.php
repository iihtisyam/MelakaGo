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
            isset($jsonbody->tqsId) &&
            isset($jsonbody->questionId) &&
            isset($jsonbody->touristAnswer) 
        ) {
            // Insert the new quiz result
            $stmt = $db->prepare("INSERT INTO touristquizsessiondetail 
                (`tqsId`, `questionId`, `touristAnswer`) 
                VALUES (:tqsId, :questionId, :touristAnswer)");

            $stmt->execute([
                ':tqsId' => $jsonbody->tqsId,
                ':questionId' => $jsonbody->questionId,
                ':touristAnswer' => $jsonbody->touristAnswer,
            ]);

            http_response_code(200);
            $response->error = "Session Detail successfully registered";
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