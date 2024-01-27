<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Credentials: true");

$hostname = "localhost";
$database = "melakago";
$username = "root";
$password = "wingerssrc1519";

$db = new PDO ("mysql:host=$hostname;dbname=$database",$username,$password);
// initial response code
// response code will be changed if the request goes into any of the process

http_response_code(404);
$response = new stdClass();

{
	$jsonbody = json_decode(file_get_contents('php://input'));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try {
        try{ 
	
		$email = $jsonbody->email;
		$password = $jsonbody->password;
		
		
		$stmt = $db->prepare("SELECT appUserId FROM appuser WHERE email=:email");
		$stmt->bindParam(':email', $email);
		

		$stmt->execute();
		
		if ($stmt->rowCount() ==1) {
			
			$userData = $stmt->fetch(PDO::FETCH_ASSOC);
			http_response_code(200);
			$response = ['appUserId' => $userData['appUserId'],];
			
		}
		else 
		{
			http_response_code(401);  // Unauthorized
			$response->error = "User not exist.";
		}
		
	
	}catch(Exception $ee){
		http_response_code(500);
		//$response['error'] = "Error occured". $ee->getMessage();
		$response->error = "Error occured ". $ee->getMessage();
	}
    } catch (Exception $ee) {
        http_response_code(500);
        $response->error = "Error occurred " . $ee->getMessage();
    }
}
else if ($_SERVER["REQUEST_METHOD"] == "PUT")
{
			try 
			{
				if (isset($jsonbody->appUserId) && isset($jsonbody->password)) {
					 $appUserId = $jsonbody->appUserId;
					 $password = $jsonbody->password;
				
					$stmt = $db->prepare("UPDATE appuser SET password=:password WHERE appUserId = :appUserId");
					$stmt->bindParam(':appUserId', $appUserId);
					$stmt->bindParam(':password', $password);
					$stmt->execute();

					if ($stmt->rowCount() == 1) {
						http_response_code(200);
						$response->success = "Password updated successfully.";
					} else {
						http_response_code(400);  // Bad Request
						$response->error = "Failed to update profile.";
					}
				} 
				else {
					http_response_code(400);  // Bad Request
					$response->error = "Invalid JSON format. appUserId and accessStatus are required.";
				}
			} catch (Exception $e) {
				http_response_code(500);
				$response->error = "Error occurred " . $e->getMessage();
			}
   
}


echo json_encode($response);
exit();
?>