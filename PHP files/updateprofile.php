<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Credentials: true");

$hostname = "localhost";
$database = "melakago";
$username = "root";
$password = "wingerssrc1519";

$db = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);

// Initial response code
http_response_code(404);
$response = new stdClass();

$jsonbody = json_decode(file_get_contents('php://input'));

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Existing code for user authentication...
} else if ($_SERVER["REQUEST_METHOD"] == "GET") {
    // Existing code for fetching user data...

    // Add your logic here if needed for GET requests related to updating profile.
    // For example, you might fetch user data for display purposes.
    // $stmt = $db->prepare("SELECT * FROM appuser WHERE appUserId = :appUserId");
    // $stmt->bindParam(':appUserId', $jsonbody->appUserId);
    // $stmt->execute();
    // $response = $stmt->fetch(PDO::FETCH_ASSOC);
} else if ($_SERVER["REQUEST_METHOD"] == "PUT") {
    try {
        if (isset($jsonbody->appUserId) && isset($jsonbody->nickName) && isset($jsonbody->phoneNumber)&& isset($jsonbody->password)) {
            $appUserId = $jsonbody->appUserId;
            $nickName = $jsonbody->nickName;
            $phoneNumber = $jsonbody->phoneNumber;
			$password = $jsonbody->password;

            $stmt = $db->prepare("UPDATE appuser SET nickName = :nickName, phoneNumber = :phoneNumber, password = :password WHERE appUserId = :appUserId");
            $stmt->bindParam(':nickName', $nickName);
            $stmt->bindParam(':phoneNumber', $phoneNumber);
			$stmt->bindParam(':password', $password);
            $stmt->bindParam(':appUserId', $appUserId);
            $stmt->execute();

            if ($stmt->rowCount() == 1) {
                http_response_code(200);
                $response->success = "Profile updated successfully.";
            } else {
                http_response_code(400);  // Bad Request
                $response->error = "Failed to update profile.";
            }
        } else {
            http_response_code(400);  // Bad Request
            $response->error = "Invalid JSON format. appUserId, nickName, and phoneNumber are required.";
        }
    } catch (Exception $e) {
        http_response_code(500);
        $response->error = "Error occurred " . $e->getMessage();
    }
}

echo json_encode($response);
exit();
?>
