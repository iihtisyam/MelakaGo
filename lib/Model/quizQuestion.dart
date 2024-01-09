import '../Controller/request_controller.dart';

class quizQuestion{

  int? questionId;
  String? questionText;
  String? answerOption1;
  String? answerOption2;
  String? answerOption3;
  String? answerOption4;
  String? correctAnswer;
  int? point;
  int? qrId;

  quizQuestion(
      this.questionId,
      this.questionText,
      this.answerOption1,
      this.answerOption2,
      this.answerOption3,
      this.answerOption4,
      this.correctAnswer,
      this.point,
      this.qrId
      );

  quizQuestion.fromJson(Map<String, dynamic>json)
      : questionId = int.tryParse(json['questionId'] ?? '') ?? 0,
        //questionId = json['questionId'] is int ?json['questionId'] as int : 0,
        questionText = json['questionText'] as String? ??"",
        answerOption1 = json['answerOption1'] as String? ??"",
        answerOption2 = json['answerOption2'] as String? ??"",
        answerOption3 = json['answerOption3'] as String? ??"",
        answerOption4 = json['answerOption4'] as String? ??"",
        correctAnswer = json['correctAnswer'] as String? ??"",
        point = int.tryParse(json['point'] ?? '') ?? 0,
        qrId = int.tryParse(json['qrId'] ?? '') ?? 0;
        //point = json['point'] is int ? json['point'] as int : 0,
        //qrId = json['qrId'] is int ? json['qrId'] as int : 0;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() =>{
    'questionId': questionId,
    'questionText': questionText,
    'answerOption1': answerOption1,
    'answerOption2': answerOption2,
    'answerOption3': answerOption3,
    'answerOption4': answerOption4,
    'correctAnswer': correctAnswer,
    'point': point,
    'qrId': qrId,
  };



  Future<List<quizQuestion>> loadQuestion() async {
    List<quizQuestion> result = [];

    RequestController req = RequestController(path: "/api/quizquestion.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200 && req.result() != null) {

      List<dynamic> responseData = req.result();

      if (responseData.isNotEmpty) {
        for (var item in responseData) {
          result.add(quizQuestion.fromJson(item));
          print("Result:  ${result}");
        }
      } else {
        print('Response data is empty.');
        // Handle the case when the response data is empty
      }
    } else {
      print('Failed to fetch data.');
      // Handle the case when the request fails
    }

    return result;
  }



}