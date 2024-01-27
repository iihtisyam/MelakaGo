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
	
		$tourismServiceId = $jsonbody->tourismServiceId;
		

		
		
		$stmt = $db->prepare("SELECT companyName FROM tourismservice WHERE tourismServiceId=:tourismServiceId");
		$stmt->bindParam(':tourismServiceId', $tourismServiceId);

		 //$stmt->execute([':companyName' => $jsonbody->companyName, 
			//':businessContactNumber'=>$jsonbody->businessContactNumber, 
			//':companyAddress'=>$jsonbody->companyAddress]);
		$stmt->execute();
		
		if ($stmt->rowCount() ==1) {
			
			$userData = $stmt->fetch(PDO::FETCH_ASSOC);
			http_response_code(200);
			$response = ['companyName' => $userData['companyName'],];
			
		}
		else 
		{
			http_response_code(401);  // Unauthorized
			$response->error = "CompanyName does not exist.";
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


echo json_encode($response);
exit();
?>