import 'package:flutter/material.dart';
//import 'dart:html';
import 'dart:typed_data';
import 'dart:convert';

import 'Model/quizQuestion.dart';
import 'qr_scanner.dart';

class quizPage extends StatefulWidget {
  final int qrCode;
  const quizPage({Key? key, required this.qrCode}) : super(key: key);

  @override

  State<quizPage> createState() => _quizPageState(qrCode);
}

class _quizPageState extends State<quizPage> {
  final int qrCode;

  _quizPageState(this.qrCode);

  int questionId=0;
  String questionText='';
  String answerOption1='';
  String answerOption2='';
  String answerOption3='';
  String answerOption4='';
  String correctAnswer='';
  int point=0;
  int qrId = 0;

  final List<quizQuestion> quiz =[];

  void QuizQuestion() async{
    qrId = qrCode;
    quizQuestion question = quizQuestion(questionId, questionText, answerOption1,
        answerOption2, answerOption3, answerOption4, correctAnswer, point, qrId);

    List<quizQuestion> loadedQuestions = await question.loadQuestion();

    setState(() {
      quiz.addAll(loadedQuestions);
    });


  }

  @override
  void initState() {
    super.initState();
    QuizQuestion();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Center(
          child: const Text(
            'Quiz Questions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
          ),
        ),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: quiz.length,
          itemBuilder: (context, index){
            final question = quiz[index];
            return Card(
              child: ListTile(
                title: Text(question.questionText!),
            subtitle: Text('Options: ${question.answerOption1},'
            ' ${question.answerOption2}, ${question.answerOption3},'
                ' ${question.answerOption4}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
