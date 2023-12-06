import 'package:flutter/material.dart';

class NavigationBarsMobile extends StatelessWidget {
  final List<String> destinations;

  const NavigationBarsMobile({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen.shade700,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/MelakaGo.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Text(
              'Welcome to MelakaGo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NavigationButton('About Us'),
              NavigationButton('Sign In'),
              NavigationButton('Sign Up'),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String text;

  NavigationButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () {
          // Add your onPressed logic here
        },
        style: TextButton.styleFrom(
          primary: Colors.black,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
