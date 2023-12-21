import 'package:flutter/material.dart';

import 'views/loginpage.dart';

void main() {
  runApp(const MaterialApp(
    home: signIn(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'MelakaGo';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.attach_money),
              title:  Text('Groceries - \RM150.00'),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title:  Text('Groceries - \RM39.00'),
            ),
            ListTile(
              leading: Icon(Icons.local_dining),
              title:  Text('Dinner - \RM7.00'),
            ),
          ],
        ),
      ),
    );
  }
}