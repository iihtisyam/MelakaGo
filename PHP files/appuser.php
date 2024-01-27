<?php
//header("Access-Control-Allow-Origin: *");
//header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
//header("Access-Control-Allow-Headers: *");
//header("Access-Control-Allow-Credentials: true");

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
        if (isset($jsonbody->firstName) &&
			isset($jsonbody->lastName) &&
			isset($jsonbody->nickName) &&
			isset($jsonbody->dateOfBirth) &&
			isset($jsonbody->phoneNumber) &&
			isset($jsonbody->email) &&
			isset($jsonbody->password) &&
			isset($jsonbody->accessStatus) &&
			isset($jsonbody->country) &&
			isset($jsonbody->roleId)) && 
			isset($jsonbody->points)){
			
            // Check if the email already exists
            $stmt = $db->prepare("SELECT email FROM appuser WHERE email=:email");
            $stmt->execute([':email' => $jsonbody->email]);
			
			
            if ($stmt->rowCount() > 0) {
//$response = $stmt->fetchAll(PDO::FETCH_ASSOC);
                http_response_code(200);
               // Bad Request
                $response->error = "Email is already registered";
            } else {
                // Insert the new user
                $stmt = $db->prepare("INSERT INTO appuser 
				(`firstName`,`lastName`,`nickName`,`dateOfBirth`,`phoneNumber`,`email`,`password`,`country`,`accessStatus`,`roleId`, `points`) 
                    VALUES (:firstName, :lastName, :nickName, :dateOfBirth, :phoneNumber, :email, :password, :country, :accessStatus, :roleId, :points)");

                $stmt->execute([
                    ':firstName' => $jsonbody->firstName,
                    ':lastName' => $jsonbody->lastName,
                    ':nickName' => $jsonbody->nickName,
                    ':dateOfBirth' => $jsonbody->dateOfBirth,
                    ':phoneNumber' => $jsonbody->phoneNumber,
                    ':email' => $jsonbody->email,
                    ':password' => $jsonbody->password,
					':country' => $jsonbody->country,
                    ':accessStatus' => $jsonbody->accessStatus,
                    ':roleId' => $jsonbody->roleId
					':points' => $jsonbody->points
                ]);

                http_response_code(200);
				$response->error = "Successfully registered";
            }
        } else {
            http_response_code(400); // Bad Request
            $response->error = "Missing required parameters";
        }
    } catch (Exception $ee) {
        http_response_code(500);
        $response->error = "Error occurred " . $ee->getMessage();
    }
}
else if($_SERVER["REQUEST_METHOD"]== "GET"){
	
	try{
		$stmt = $db->prepare("SELECT * FROM appuser WHERE email=email and password=password");
		$stmt->execute();
		$response = $stmt->fetchAll(PDO::FETCH_ASSOC);
		http_response_code(200);
	
	}catch(Exception $ee){
		http_response_code(500);
		//$response['error'] = "Error occured". $ee->getMessage();
		$response->error = "Error occured ". $ee->getMessage();
	}
}

echo json_encode($response);
exit();
?>