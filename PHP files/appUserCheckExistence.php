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

		$jsonbody = json_decode(file_get_contents('php://input'));

		if ($_SERVER["REQUEST_METHOD"] == "POST") {
			try {

				if (isset($jsonbody->email) && isset($jsonbody->password)) {
					$email = $jsonbody->email;
					$password = $jsonbody->password;
					$accessStatus = $jsonbody->accessStatus;

					// Check if the email already exists
					$stmt = $db->prepare("SELECT * FROM appuser WHERE email=:email AND password=:password");
					$stmt->bindParam(':email', $email);
					$stmt->bindParam(':password', $password);
					$stmt->execute();


					if ($stmt->rowCount() > 0) {
					
						$userData = $stmt->fetch(PDO::FETCH_ASSOC);
						
						 if ($userData['accessStatus'] == 'DEACTIVATE') 
						{
							http_response_code(402);  // Unauthorized
							$response->error = "AccessStatus is DEACTIVATE.";
						} elseif ($userData['accessStatus'] == 'ACTIVE') 
						{
							http_response_code(200);
							$response = [
							'appUserId' => $userData['appUserId'],
							'firstName' => $userData['firstName'],
							'lastName' => $userData['lastName'],
							'nickName' => $userData['nickName'],
							'dateOfBirth' => $userData['dateOfBirth'],
							'phoneNumber' => $userData['phoneNumber'],
							'email' => $userData['email'],
							'password' => $userData['password'],
							'accessStatus' => $userData['accessStatus'],
							'country' => $userData['country'],
							'roleId' => $userData['roleId'],
							'points' => $userData['points'],

						];
						}
						
					} else {
						http_response_code(401);  // Unauthorized
						$response->error = "Invalid username or password.";
					}
				} else {
					http_response_code(400);  // Bad Request
					$response->error = "Invalid JSON format. Username and password are required.";
				}
			} catch (Exception $ee) {
				http_response_code(500);
				$response->error = "Error occurred " . $ee->getMessage();
			}
		} else if ($_SERVER["REQUEST_METHOD"] == "GET") {

			try {
				$stmt = $db->prepare("SELECT * FROM appuser WHERE email=email and password=password");
				$stmt->execute();
				$response = $stmt->fetchAll(PDO::FETCH_ASSOC);
				http_response_code(200);
			} catch (Exception $ee) {
				http_response_code(500);
				//$response['error'] = "Error occurred". $ee->getMessage();
				$response->error = "Error occurred " . $ee->getMessage();
			}
		}
		else if ($_SERVER["REQUEST_METHOD"] == "PUT")
		{
			try 
			{
				if (isset($jsonbody->appUserId) && isset($jsonbody->accessStatus)) {
					 $appUserId = $jsonbody->appUserId;
					 $accessStatus = $jsonbody->accessStatus;
					 
					   error_log("appUserId received: " . $appUserId);

					$stmt = $db->prepare("UPDATE appuser SET accessStatus = :accessStatus WHERE appUserId = :appUserId");
					$stmt->bindParam(':accessStatus', $accessStatus);
					$stmt->bindParam(':appUserId', $appUserId);
					$stmt->execute();

					if ($stmt->rowCount() == 1) {
						http_response_code(200);
						$response->success = "AccessStatus updated successfully.";
					} else {
						http_response_code(400);  // Bad Request
						$response->error = "Failed to update accessStatus.";
					}
				} else {
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