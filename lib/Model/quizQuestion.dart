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
}