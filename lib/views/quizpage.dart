import 'dart:async';
import 'package:flutter/material.dart';
import 'package:melakago/Model/appUser.dart';
import 'package:melakago/Model/tourismService.dart';
import 'package:melakago/Model/tourismService.dart';
import 'package:melakago/views/qr_scanner.dart';
import 'package:melakago/views/home_view.dart';

import '../Model/quizQuestion.dart';
import '../Model/tourismService.dart';
import '../Model/tourismService.dart';
import '../Model/touristQuizSession.dart';
import '../Model/touristQuizSessionDetail.dart';
import '../Model/qrspot.dart';

class quizPage extends StatefulWidget {
  late int qrCode;
  late appUser user;

  quizPage({Key? key, required this.qrCode, required appUser user}) : super(key: key){
    this.qrCode=qrCode;
    this.user=user;
  }

  @override
  State<quizPage> createState() => _quizPageState();
}

class _quizPageState extends State<quizPage> {

  int questionIndex = 0;
  int score = 0;
  int secondsRemaining = 30;
  late Timer timer;
  int currentQuestionPoints = 0;
  int totalPointQuiz=0;
  int tqsId=0;
  int totalTimeTaken = 0;
  List<String> answerQuiz=[];
  List<int> timeEachQuestion=[];

 /* List<DateTime> startTimeList = [];
  List<DateTime> endTimeList = [];*/

  DateTime WholeStartTime=DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  DateTime WholeEndTime = DateTime.now();



  int questionId = 0;
  String questionText = '';
  String answerOption1 = '';
  String answerOption2 = '';
  String answerOption3 = '';
  String answerOption4 = '';
  String correctAnswer = '';
  int point = 0;
  int qrId = 0;

  final List<quizQuestion> quiz = [];


  tourismService _tourismService = tourismService();
  String? companyName = '';



  Future<void> fetchTourismServiceInfo() async {
    qrSpot _qrSpot = qrSpot(widget.qrCode, 0);
    String? getCompany = await _qrSpot.getServiceId();
    companyName=getCompany;
  }


  Future<List<quizQuestion>> QuizQuestion() async {
    qrId = widget.qrCode;
    quizQuestion question = quizQuestion(
      questionId,
      questionText,
      answerOption1,
      answerOption2,
      answerOption3,
      answerOption4,
      correctAnswer,
      point,
      qrId,
    );

    List<quizQuestion> loadedQuestions = await question.loadQuestion();

    setState(() {
      quiz.clear();
      quiz.addAll(loadedQuestions);
      print("QUIZ: ${quiz[1].point}");
      print("QRID: ${quiz[1].qrId}");
      print("4: ${quiz[1].answerOption4}");

      //set the current question's points
      currentQuestionPoints = quiz[questionIndex].point ?? 0;
    });
    return loadedQuestions;
  }

  void startTimer() {
    // startTimeList.add(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          // endTimeList.add(DateTime.now());
          moveToNextQuestion();
        }
      });
    });
  }


  void moveToNextQuestion() {
    setState(() {
      if (questionIndex < quiz.length - 1) {
        questionIndex++;
        secondsRemaining = 30;
        // Update WholeStartTime for the next question
        WholeStartTime = DateTime.now();
        // startTimeList.add(DateTime.now());
        startTimer();
      } else {
        // Update WholeEndTime for the last question
        WholeEndTime = DateTime.now();
        timer.cancel();
        _showScoreDialog();
      }
    });
  }



  int getTimeTakenInSeconds() {
    // Calculate the total time taken from the start to the end of the quiz
    totalTimeTaken = DateTime.now().difference(WholeStartTime).inSeconds;
    return totalTimeTaken;
  }



  /*int getTimeTakenForCurrentQuestion() {
    if (startTimeList.length > questionIndex && endTimeList.length > questionIndex) {
      return endTimeList[questionIndex].difference(startTimeList[questionIndex]).inSeconds;
    } else {
      return 0;
    }
  }
*/


  /*int getTimeTakenForEachQuestion(int questionIndex) {
    if (questionIndex >= 0 && questionIndex < quiz.length) {
      return endTimeQuestion.difference(startTimeQuestion).inSeconds;
    } else {
      return 0;
    }
  }
*/


  void answerQuestion(String selectedAnswer) {
    setState(() {
      timer.cancel();
      answerQuiz.add(selectedAnswer);
      if (selectedAnswer == quiz[questionIndex].correctAnswer) {
        score++;
        totalPointQuiz += quiz[questionIndex].point!;
      }

      moveToNextQuestion();
    });
  }

  void _showScoreDialog() {

    // int timeTaken = getTimeTakenInSeconds();
    WholeEndTime = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your Score: $score out of ${quiz.length}'),
              SizedBox(height: 8),
              Text('Time Taken: $totalTimeTaken seconds'),
              SizedBox(height: 8),
              Text('Your Total Points: $totalPointQuiz'),
              SizedBox(height: 8),
            /*  Text('Start Time: $WholeStartTime'),
              SizedBox(height: 8),
              Text('End Time: $WholeEndTime'),*/

            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Reset the quiz
               /* Navigator.pop(context);
                setState(() {
                  questionIndex = 0;
                  score = 0;
                  secondsRemaining = 30;
                });*/
                startTimer(); // Start the timer for the first question
                // Check if all questions have been answered
                  // Calculate endTime or get it from your logic
                  // Get appUserId from your user object or other logic
                  int appUserId = widget.user.appUserId!;

                  touristQuizSession quizSession = touristQuizSession
                    (tqsId: tqsId, startTime: WholeStartTime, endTime: WholeEndTime,
                      totalPoints: totalPointQuiz, appUserId: appUserId);

                  if(await quizSession.submitQuizSession()){
                    print ("WHOLE TIME : ${WholeEndTime}");
                    DateTime QuizStartTime = DateTime.parse(removeDecimalNumbers
                      (WholeStartTime));
                    DateTime QuizEndTime = DateTime.parse(removeDecimalNumbers
                      (WholeEndTime));

                    touristQuizSession gettqsId = touristQuizSession.getTqsId
                      (startTime: QuizStartTime, endTime: QuizEndTime,
                        totalPoints: totalPointQuiz, appUserId: appUserId);

                    if(await gettqsId.getTqsId()){

                      int sessionDetailId=0;
                      tqsId = gettqsId.tqsId!;

                      print("TQSID GET FROM METHOD: ${tqsId}");

                      List<quizQuestion> loadedQuestions = await QuizQuestion();


                      for (int i = 0; i < loadedQuestions.length; i++) {
                        touristQuizSessionDetail sessionDetail = touristQuizSessionDetail(
                          sessionDetailId: sessionDetailId,
                          tqsId: tqsId,
                          questionId: loadedQuestions[i].questionId!,
                          touristAnswer: answerQuiz[i],
                        );

                        try {
                          bool savedSuccessfully = await sessionDetail.saveSessionDetail();

                          if (savedSuccessfully) {
                            print('Session detail saved successfully');
                          } else {
                            print('Session detail is already registered');
                          }
                        } catch (e) {
                          print('Error saving session detail: $e');
                        }
                      }
                    /*  _AlertMessage("You have done your quiz!");
                      Future.delayed(Duration(seconds: 2), () {
                      });*/
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ExplorePage(user: widget.user)));
                  }
                  },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  String removeDecimalNumbers(DateTime dateTime) {
    // Extract the date and time without milliseconds
    DateTime result = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );

    // Check if the millisecond value is greater than or equal to 500
    if (dateTime.millisecond >= 500) {
      // If so, round up the seconds value
      result = result.add(Duration(seconds: 1));
    }

    // Format the result as a string
    String formattedString = result.toLocal().toIso8601String();

    // Find the index of the decimal point
    int decimalPointIndex = formattedString.indexOf('.');

    // Extract the substring before the decimal point
    String finalResult = formattedString.substring(0, decimalPointIndex);

    return finalResult;
  }

  /*void _AlertMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
*/

  @override
  void initState() {
    super.initState();
    fetchTourismServiceInfo();
    QuizQuestion();
    startTimer(); // Start the timer for the first question
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Questions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
            ),
            Text(
              // Use companyName obtained from fetchData
              'Company: ${companyName ?? ''}',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (quiz.isNotEmpty && questionIndex < quiz.length)
                    ListTile(
                      contentPadding: EdgeInsets.only(bottom: 16.0),
                      title: Text(
                        quiz[questionIndex].questionText!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                      ),
                      subtitle: Text(
                        'Points for this question: ${quiz[questionIndex].point} ',
                      ),
                    ),
                  if (quiz.isNotEmpty && questionIndex < quiz.length)
                    ElevatedButton(
                      onPressed: () {
                        // Pass the selected answer to the function
                        answerQuestion(quiz[questionIndex].answerOption1!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 60.0),
                      ),
                      child: Text(
                        quiz[questionIndex].answerOption1!,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  if (quiz.isNotEmpty && questionIndex < quiz.length)
                    ElevatedButton(
                      onPressed: () {
                        answerQuestion(quiz[questionIndex].answerOption2!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 60.0),
                      ),
                      child: Text(
                        quiz[questionIndex].answerOption2!,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  if (quiz.isNotEmpty && questionIndex < quiz.length)
                    ElevatedButton(
                      onPressed: () {
                        answerQuestion(quiz[questionIndex].answerOption3!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 60.0),
                      ),
                      child: Text(
                        quiz[questionIndex].answerOption3!,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  if (quiz.isNotEmpty && questionIndex < quiz.length)
                    ElevatedButton(
                      onPressed: () {
                        answerQuestion(quiz[questionIndex].answerOption4!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 60.0),
                      ),
                      child: Text(
                        quiz[questionIndex].answerOption4!,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  SizedBox(height: 16.0),
                 Text(  'Time Remaining: $secondsRemaining seconds',
                   style: TextStyle(fontSize: 16.0, color: Colors.black),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
