
import '../Controller/request_controller.dart';

class touristQuizSession {

  int? tqsId;
  DateTime? startTime;
  DateTime? endTime;
  int? totalPoints;
  int? appUserId;

  touristQuizSession({
    required this.tqsId,
    required this.startTime,
    required this.endTime,
    required this.totalPoints,
    required this.appUserId,
  });

  touristQuizSession.getTqsId({
    required this.startTime,
    required this.endTime,
    required this.totalPoints,
    required this.appUserId,
  });

  touristQuizSession.fromJson(Map<String, dynamic> json)
      : tqsId = int.tryParse(json['tqsId'] ?? '') ?? 0,
        startTime = DateTime.parse(json['startTime'] as String? ??""),
        endTime = DateTime.parse(json['endTime'] as String? ??""),
        totalPoints = int.tryParse(json['totalPoints'] ?? '') ?? 0,
        appUserId = int.tryParse(json['appUserId'] ?? '') ?? 0;

  Map<String, dynamic> toJson() =>
      {
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'totalPoints': totalPoints,
        'appUserId': appUserId
      };

  Future<bool> submitQuizSession() async {
    RequestController req = RequestController(
        path: '/api/touristquizsession.php');

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

  Future<bool> getTqsId() async {
    RequestController req = RequestController(path: "/api/getTqsId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      tqsId = int.tryParse(req.result()['tqsId'] ?? '');
      print(tqsId);
      return true;
    }
    else {
      return false;
    }
  }


}