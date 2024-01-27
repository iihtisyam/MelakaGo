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
// response code will be changed if the request goes into any of the process

http_response_code(404);
$response = new stdClass();

{
    $jsonbody = json_decode(file_get_contents('php://input'));
}

if ($_SERVER["REQUEST_METHOD"] == "PUT") {
    try {
        if (isset($jsonbody->appUserId) && isset($jsonbody->points)) {
            $appUserId = $jsonbody->appUserId;
            $points = $jsonbody->points;

            $stmt = $db->prepare("UPDATE appuser SET points=:points WHERE appUserId = :appUserId");
            $stmt->bindParam(':points', $points);
            $stmt->bindParam(':appUserId', $appUserId);
            $stmt->execute();

            if ($stmt->rowCount() == 1) {
                http_response_code(200);
                $response->success = "Points successfully updated.";
            } else {
                http_response_code(400); // Bad Request
                $response->error = "Failed to update points.";
            }
        } else {
            http_response_code(400); // Bad Request
            $response->error = "Invalid JSON format. appUserId and points are required.";
        }
    } catch (Exception $e) {
        http_response_code(500);
        $response->error = "Error occurred " . $e->getMessage();
    }
}

echo json_encode($response);
exit();
?>
               