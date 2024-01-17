import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:melakago/views/home_view.dart';
//import 'package:melakago_web/views/home/homePageView_Web_BSDC.dart';
import '../../Model/appUser.dart';
import 'SignUp.dart';
import 'forgotpassword.dart';
//import 'home/homePageView_Web_SA.dart';
//import 'home/homePageView_Web_TAC.dart';
//import 'home/home_view.dart';

void main(){
  runApp(const MaterialApp(
    home:signIn(),
  ));
}

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<signIn> {
  late final appUser user;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void _togglePasswordVisibility() {
    // Toggle the visibility of the password
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
  void _checkUser() async{

    final List<appUser> admin= [];

    final String email = emailController.text.trim();
    final String password=passwordController.text.trim();
    int appUserId=0;
    String firstName='';
    String lastName='';
    String nickName='';
    String dateOfBirth='';
    String phoneNumber='';
    String country='';
    String accessStatus='';
    int roleId=4;
    int points=0;

    if ( email.isNotEmpty && password.isNotEmpty) {

      //_AlertMessage("success");

      appUser user = appUser (appUserId, firstName, lastName, nickName, dateOfBirth,
          phoneNumber,email, password, accessStatus,
          country, roleId, points);

      if (await user.checkTouristExistence() && user.roleId == 4){
        setState(() {
          emailController.clear();
          passwordController.clear();
        });

        _showMessage("LogIn Successful");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExplorePage(user:user)));

      }
      else{
        _AlertMessage("EMAIL OR PASSWORD WRONG!");
      }
    }
    else{
      _AlertMessage("Please Insert All The Information Needed");
      setState(() {

        emailController.clear();
        passwordController.clear();
      });

    }
  }


  void _AlertMessage(String msg) {
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

  void _showMessage(String msg){
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  void _forgetPassword() {
    // Navigate to the PasswordResetPage when "Forget Password?" is pressed
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Padding(
          padding: EdgeInsets.only(left: 10.0), // Adjust the left padding as needed
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'MelakaGo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white,),
            ),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome Back, MelakaGoer!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              ClipOval(
                child: Image.asset(
                  'assets/MelakaGo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0, horizontal:16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5), // Add some spacing
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0, horizontal:16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5), // Add some spacing
              TextButton(
                onPressed: _forgetPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 5), // Add some spacing
              ElevatedButton(
                onPressed: _checkUser,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Set your desired background color here
                ),
                child: const Text('Login',
                    style: TextStyle(fontSize: 18.0,
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => signUp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}