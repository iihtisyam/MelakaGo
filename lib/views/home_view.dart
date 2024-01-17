import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:melakago/views/editProfile.dart';
import 'package:melakago/views/loginpage.dart';
import 'package:melakago/views/rewardpage.dart';

import '../Model/tourismService.dart';
import '../Model/tourismServiceImage.dart';
import '../Model/appUser.dart';
import 'categoryPage.dart';
import 'detailPage.dart';
import 'qr_scanner.dart';

class ExplorePage extends StatefulWidget {
  final appUser user;

  ExplorePage({required this.user});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final appUser user;
  int tourismServiceId = 0;
  String companyName = '';
  String companyAddress = '';
  String businessContactNumber = '';
  String email = '';
  String businessStartHour = '';
  String businessEndHour = '';
  String faxNumber = '';
  String instagram = '';
  String xTwitter = '';
  String thread = '';
  String facebook = '';
  String businessLocation = '';
  int starRating = 0;
  String businessDescription = '';
  int tsId = 0;
  int isDelete = 0;
  int imageId = 0;
  String image = '';
  String? getImages = '';
  int selectedTsId = 0;

  final List<tourismService> service = [];

  String nickName = '';

  String _formatTime(String? time) {
    if (time == null) {
      return '';
    }

    // Split the time into hours, minutes, and seconds
    List<String> parts = time.split(':');

    // Extract hours and minutes
    String hours = parts[0];
    String minutes = parts[1];

    // Return the formatted time as HH:mm
    return '$hours:$minutes';
  }


  @override
  void initState() {
    super.initState();
    loadTourism();
  }

  Future<List<tourismService>> loadTourism() async {
    tourismService tourism = tourismService.getService(
      tourismServiceId,
      companyName,
      companyAddress,
      businessContactNumber,
      email,
      businessStartHour,
      businessEndHour,
      faxNumber,
      instagram,
      xTwitter,
      thread,
      facebook,
      businessLocation,
      starRating,
      businessDescription,
      tsId,
      isDelete,
    );

    List<tourismService> loadedTourism = await tourismService.loadImagesStatic();

    setState(() {
      service.clear();
      service.addAll(loadedTourism);
      print("iihihi: ${service[0].TourismServiceImage?.image}");
    });
    return loadedTourism;
  }

  Uint8List? _loadImage(index) {
    getImages = service[index].TourismServiceImage!.image;

    if (getImages == null || getImages!.isEmpty) {
      print('List images is empty');
      return null;
    }

    try {
      // Remove backslashes from the string
      getImages = getImages?.replaceAll(r'\\', '');

      // Trim the string to remove any leading or trailing whitespaces
      getImages = getImages?.trim();
      print("IMAAAAAAA: ${getImages}");

      if (getImages!.startsWith("data:image\/jpeg;base64,")) {
        // Remove the prefix "data:image/jpeg;base64,"
        getImages = getImages?.substring(getImages!.indexOf(',') + 1);
        print("DATA HEREEEEEE: ${getImages}");
      }

      Uint8List decodedImage = base64.decode(getImages!);

      // Verify that the decoded data is not null
      if (decodedImage.isNotEmpty) {
        return decodedImage;
      } else {
        print('Decoded image is empty');
        return null;
      }
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  void updateTsId(int tsId) {
    setState(() {
      selectedTsId = tsId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'MelakaGo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add code to sign out here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => signIn()),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          buildSectionTitle(context, 'Explore'),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Attractions', 6),
              ),
              Expanded(
                child: buildCategoryItem('Lodging', 3),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Foods', 4),
              ),
              Expanded(
                child: buildCategoryItem('Activities', 5),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Shopping', 1),
              ),
              Expanded(
                child: buildCategoryItem('Transport', 2),
              ),
            ],
          ),
          // Additional sections can be added as needed
          buildSectionTitle(context, 'You might like these'),
          _buildGridView(service ?? []), // Ensure service is not null
        ],
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



  Widget buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryItem(String title, int tsId) {
    IconData iconData;

    // Assign icon based on the category title
    switch (title) {
      case 'Attractions':
        iconData = Icons.location_on;
        break;
      case 'Lodging':
        iconData = Icons.hotel;
        break;
      case 'Foods':
        iconData = Icons.restaurant;
        break;
      case 'Activities':
        iconData = Icons.directions_run;
        break;
      case 'Shopping':
        iconData = Icons.shopping_cart;
        break;
      case 'Transport':
        iconData = Icons.directions_car;
        break;
    // Add more cases for other categories if needed
      default:
        iconData = Icons.category;
    }

    return Card(
      child: GestureDetector(
        onTap: () {
          print('Tapped on category: $title with tsId: $tsId');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(
                user: widget.user,
                tsId: tsId,
                services: service,
                imageBytes: _loadImage(tsId),
              ),
            ),
          );
        },
        child: ListTile(
          leading: Icon(iconData), // Icon displayed before the title
          title: Text(title),
        ),
      ),
    );
  }





  Widget _buildGridView(List<tourismService> services) {
    List<tourismService> filteredServices = services.where((service) {
      return selectedTsId == 0 || service.serviceCategory == selectedTsId;
    }).toList();

    return Container(
      height: 400, // Set an appropriate height
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 50.0, // Spacing between rows
        ),
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          tourismService service = filteredServices[index];
          Uint8List? imageBytes = _loadImage(index);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => detailPage(
                    service: service,
                    imageBytes: _loadImage(index),
                  ),
                ),
              );
            },
            child: Card(
              elevation: 40.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: double.infinity,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageBytes != null)
                      Image.memory(
                        imageBytes,
                        height: 90, // Adjusted image height
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.companyName ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text('Start Time: ${_formatTime(service.businessStartHour)}'),
                          SizedBox(height: 3),
                          Text('End Time: ${_formatTime(service.businessEndHour)}'),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}