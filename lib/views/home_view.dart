import 'package:flutter/material.dart';
import '../Model/appUser.dart';
import '../NavigationBar.dart';

class HomeView extends StatelessWidget {

  late final appUser user;
  HomeView({required this.user}) : nickName = user.nickName;
  String nickName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            NavigationBarsMobile(destinations: []),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'assets/MelakaGo.png',
                          height: 350,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/MelakaGo.png',
                          height: 350,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/MelakaGo.png',
                          height: 350,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'assets/MelakaGo.png',
                          height: 350,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/MelakaGo.png',
                          height: 350,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/MelakaGo.png',
                          height: 350,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
