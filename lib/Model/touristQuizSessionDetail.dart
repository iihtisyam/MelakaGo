import '../Controller/request_controller.dart';

class touristQuizSessionDetail{

  int sessionDetailId;
  int tqsId;
  int questionId;
  String touristAnswer;


  touristQuizSessionDetail({

   required this.sessionDetailId,
   required this.tqsId,
   required this.questionId,
   required this.touristAnswer,


  });

  touristQuizSessionDetail.fromJson(Map<String, dynamic> json)
      : sessionDetailId = json['sessionDetailId'] as int,
        tqsId = json['tqsId'] as int,
        questionId = json['questionId'] as int,
        touristAnswer = json['touristAnswer'] as String;


  Map<String, dynamic> toJson() => {

      'sessionDetailId':sessionDetailId,
      'tqsId': tqsId,
      'questionId': questionId,
      'touristAnswer': touristAnswer,

  };

  Future<bool> saveSessionDetail() async {
    RequestController req = RequestController(path: "/api/touristquizsessiondetail.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return true;
    } else if (req.status() == 200) {
      String data = req.result().toString();
      if (data == '{error: Session Detail is already registered}') {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }


}