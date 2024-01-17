import 'package:flutter/material.dart';
import 'package:melakago/views/home_view.dart';
import 'package:melakago/views/qr_scanner.dart';
import 'package:melakago/views/rewardpage.dart';


import '../../Model/appUser.dart';



class updateProfilePage extends StatefulWidget {
  late appUser user;

  updateProfilePage({Key? key, required appUser user}) : super(key: key) {
    this.user = user;
  }


  @override
  State<updateProfilePage> createState() => _updateProfilePageState();
}

class _updateProfilePageState extends State<updateProfilePage> {
  int appUserId=0;
  int roleId=4;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController nickNameController;
  late TextEditingController dateOfBirthController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late TextEditingController countryController;
  late TextEditingController DOBController;

  DateTime? selectedDate;
  String? selectedCountry;
  String? role;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    nickNameController = TextEditingController();
    dateOfBirthController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    countryController = TextEditingController();


    // Initialize the user field here
    firstNameController.text = widget.user.firstName!;
    lastNameController.text = widget.user.lastName!;
    nickNameController.text = widget.user.nickName!;
    dateOfBirthController.text = widget.user.dateOfBirth!;
    emailController.text = widget.user.email!;
    passwordController.text = widget.user.password!;
    phoneNumberController.text = widget.user.phoneNumber!;
    countryController.text = widget.user.country! ;
    appUserId = widget.user.appUserId!;
    roleId = widget.user.roleId!;


  }


  void _editAdmin() async{

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String nickName = nickNameController.text.trim();
    final String dateOfBirth = dateOfBirthController.text.trim();
    final String email = emailController.text.trim();
    final String password=passwordController.text.trim();
    final String phoneNumber=phoneNumberController.text.trim();
    final String selectedCountry = countryController.text.trim();
    final String accessStatus = 'ACTIVE';
    final int points = 0;

    appUser user = appUser (appUserId,firstName, lastName, nickName,
        dateOfBirth, phoneNumber,email, password, accessStatus,
        selectedCountry, roleId, points);

    if ( await user.updateProfile()) {
      _AlertMessage(context, "NOTE: Profile Successfully Updated");
      Future.delayed(Duration(seconds: 2), () {
        // Navigate to the login screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExplorePage(user: user)),
        );
      });
    }
    else{
      _AlertMessage(context, "NOTE: Profile Unsuccessful Updated");
    }

  }

  void _AlertMessage(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(msg),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Profile Update',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/MelakaGo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),

              buildTextField("First Name", firstNameController),
              buildTextField("Last Name", lastNameController),
              buildTextField("Nick Name", nickNameController),
              buildTextField("Date of Birth", dateOfBirthController),
              buildTextField("Country", countryController),
              buildTextField("Phone Number", phoneNumberController),
              buildTextField("Email", emailController),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _editAdmin,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            // Set showSelectedLabels and showUnselectedLabels to false
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),// Adjust the vertical padding as needed
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, color: Colors.black),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code, color: Colors.black),
                label: 'QrCode',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard, color: Colors.black),
                label: 'Reward',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: 'Account',
              ),
            ],
            onTap: (index) {
              // Handle item tap
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExplorePage(user: widget.user),
                    ),
                  );
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScanner(user: widget.user),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RewardPage(user: widget.user),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => updateProfilePage(user: widget.user),
                    ),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    bool isReadOnly = label == "Date of Birth" || label == "Country"
        || label == "First Name" || label == "Last Name";

    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: controller,
                readOnly: isReadOnly,
                // readOnly: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}