
import '../Controller/request_controller.dart';

class touristQuizSession {

  DateTime startTime;
  DateTime endTime;
  int totalPoints;
  int appUserId;

  touristQuizSession({
    required this.startTime,
    required this.endTime,
    required this.totalPoints,
    required this.appUserId,
  });

  touristQuizSession.fromJson(Map<String, dynamic> json)
      : startTime = DateTime.parse(json['startTime'] as String),
        endTime = DateTime.parse(json['endTime'] as String),
        totalPoints = json['totalPoints'] as int,
        appUserId = json['appUserId'] as int;

  Map<String, dynamic> toJson() => {
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'totalPoints': totalPoints,
    'appUserId': appUserId
  };

  Future<bool> submitQuizSession() async {

   RequestController req = RequestController(path: '/api/touristquizsession.php');

    // Set the body of the request
    req.setBody(toJson());

   // Make the HTTP request to submit the quiz session data
    await req.post();

   // Check the response status code
   if (req.status() == 200) {
     return true;
   } else {
     return false;
   }

  }

}
