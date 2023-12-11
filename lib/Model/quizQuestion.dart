import '../Controller/request_controller.dart';

class quizQuestion{

  int questionId;
  String questionText;
  String answerOption1;
  String answerOption2;
  String answerOption3;
  String answerOption4;
  String correctAnswer;
  int point;
  int qrId;

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
      : questionId = json['questionId'] as dynamic,
        questionText = json['questionText'] as String,
        answerOption1 = json['answerOption1'] as String,
        answerOption2 = json['answerOption2'] as String,
        answerOption3 = json['answerOption3'] as String,
        answerOption4 = json['answerOption4'] as String,
        correctAnswer = json['correctAnswer'] as String,
        point = json['point'] as dynamic,
        qrId = json['qrId'] as dynamic;

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

  Future<bool> fetchDataUsingQrCode(String qrCode) async {
    RequestController req = RequestController(path: "/api/fetch_question.php");
    req.setBody({'qrCode': qrCode});

    try {
      await req.get();

      if (req.status() == 200) {
        // Update the instance variables with the retrieved data
        Map<String, dynamic> responseData = req.result();
        questionId = responseData['questionId'];
        questionText = responseData['questionText'];
        answerOption1 = responseData['answerOption1'];
        answerOption2 = responseData['answerOption2'];
        answerOption3 = responseData['answerOption3'];
        answerOption4 = responseData['answerOption4'];
        correctAnswer = responseData['correctAnswer'];
        point = responseData['point'];
        qrId = responseData['qrId'];

        print('Data fetched successfully');
        return true;
      } else {
        print('Failed to fetch data using QR code');
        return false;
      }
    } catch (e) {
      print('Exception while fetching data: $e');
      return false;
    }
  }

  Future<List<quizQuestion>> loadQuestion() async{
    List<quizQuestion> result = [];
    RequestController req =
        RequestController(path: "/api/quizquestion.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()['questions']) {
        result.add(quizQuestion.fromJson(item) as quizQuestion);
      }
    }
    return result;
  }



}