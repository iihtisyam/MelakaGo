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

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    try {
			$stmt = $db->prepare("SELECT 
                    a.*, 
                    b.imageId, 
                    b.image
                FROM 
                    tourismservice a
                JOIN 
                    (
                        SELECT 
                            tourismServiceId,
                            MAX(imageId) AS imageId  -- Assuming you want to get the maximum imageId
                        FROM 
                            tourismserviceimage
                        GROUP BY 
                            tourismServiceId
                    ) max_image
                    ON a.tourismServiceId = max_image.tourismServiceId
                JOIN 
                    tourismserviceimage b 
                    ON max_image.tourismServiceId = b.tourismServiceId AND max_image.imageId = b.imageId
					where a.isDelete=0
                ORDER BY 
                    RAND();");
			$stmt->execute();
		
		
		if ($stmt->rowCount() >0) {
            $response= [];
			
            while ($imageData = $stmt->fetch(PDO::FETCH_ASSOC)) {

                $response[] = [
                    'tourismServiceId' => $imageData['tourismServiceId'],
                    'companyName' => $imageData['companyName'],
                    'companyAddress' => $imageData['companyAddress'],
                    'businessContactNumber' => $imageData['businessContactNumber'],
                    'email' => $imageData['email'],
                    'businessStartHour' => $imageData['businessStartHour'],
                    'businessEndHour' => $imageData['businessEndHour'],
                    'faxNumber' => $imageData['faxNumber'],
                    'instagramURL' => $imageData['instagramURL'],
                    'xTwitterURL' => $imageData['xTwitterURL'],
                    'threadURL' => $imageData['threadURL'],
                    'facebookURL' => $imageData['facebookURL'],
                    'starRating' => $imageData['starRating'],
                    'businessLocation' => $imageData['businessLocation'],
                    'businessDescription' => $imageData['businessDescription'],
                    'tsId' => $imageData['tsId'],
                    'isDelete' => $imageData['isDelete'],
                    'imageId' => $imageData['imageId'],
                    'image' => $imageData['image'],
                    
                    
                ];
    

            }
			
			
			http_response_code(200);
	
							
		}
		else 
		{
			http_response_code(401);  // Unauthorized
			$response->error = "Tourism Service not exist.";
		}
		
	
	}catch(Exception $ee){
		http_response_code(500);
		//$response['error'] = "Error occured". $ee->getMessage();
		$response->error = "Error occured ". $ee->getMessage();
	}
   
}
else if ($_SERVER["REQUEST_METHOD"] == "GET") {
  
}
else if ($_SERVER["REQUEST_METHOD"] == "PUT")
{
	
}

echo json_encode($response);
exit();
?>