import 'dart:async';
import 'package:flutter/material.dart';
import 'package:melakago/Model/appUser.dart';
import 'package:melakago/qr_scanner.dart';

import '../Model/quizQuestion.dart';
import '../Model/touristQuizSession.dart';

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

  void QuizQuestion() async {
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
  }

  void startTimer() {
    startTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          // Handle the timer expiration (e.g., move to the next question)
          moveToNextQuestion();
        }
      });
    });
  }

  void moveToNextQuestion() {
    setState(() {
      if (questionIndex < quiz.length - 1) {
        questionIndex++;
        secondsRemaining = 30; // Reset the timer for the next question
        startTimer(); // Start the timer for the new question
      } else {
        // If all questions are answered, show the score
        endTime = DateTime.now();
        timer.cancel();
        _showScoreDialog();
      }
    });
  }

  int getTimeTakenInSeconds() {
    return endTime.difference(startTime).inSeconds;
  }


  void answerQuestion(String selectedAnswer) {
    setState(() {
      timer.cancel(); // Stop the timer when an answer is selected
      if (selectedAnswer == quiz[questionIndex].correctAnswer) {
        score++;
        totalPointQuiz += quiz[questionIndex].point!;
      }

      moveToNextQuestion();
    });
  }

  void _showScoreDialog() {

    int timeTaken = getTimeTakenInSeconds();
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
              Text('Time Taken: $timeTaken seconds'),
              SizedBox(height: 8),
              Text('Your Total Points: $totalPointQuiz'),
              SizedBox(height: 8),
              Text('Start Time: $WholeStartTime'),
              SizedBox(height: 8),
              Text('End Time: $WholeEndTime'),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Reset the quiz
                Navigator.pop(context);
                setState(() {
                  questionIndex = 0;
                  score = 0;
                  secondsRemaining = 30;
                });

                startTimer(); // Start the timer for the first question

                // Check if all questions have been answered

                  // Calculate endTime or get it from your logic


                  // Get appUserId from your user object or other logic
                  int appUserId = widget.user.appUserId;

                  // Create a touristQuizSession instance and submit data to the database

                 /* await touristQuizSession(
                    startTime: startTime,
                    endTime: endTime,
                    totalPoints: score,
                    appUserId: appUserId,
                  ).submitQuizSession();*/

                  touristQuizSession quizSession = touristQuizSession(startTime: WholeStartTime, endTime: WholeEndTime, totalPoints: totalPointQuiz, appUserId: appUserId);

                  if(await quizSession.submitQuizSession()){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>QrScanner(user: widget.user)));

                  }



              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 1), () {});
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
            const SizedBox(height: 8),
            Text(
              'QR ID: $qrId',
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
                        'Marks for this question: ${quiz[questionIndex].point} ',
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
