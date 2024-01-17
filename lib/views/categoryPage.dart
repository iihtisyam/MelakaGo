import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../Model/appUser.dart';
import '../Model/tourismService.dart';
import 'detailPage.dart';

class CategoryPage extends StatefulWidget {
  final appUser user;
  final int tsId;
  final List<tourismService> services;
  final Uint8List? imageBytes;

  CategoryPage({
    required this.user,
    required this.tsId,
    required this.services,
    required this.imageBytes,
  });

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  late List<tourismService> filteredServices;
  String getImages='';
  String title='';

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


  int count=0;
  @override
  void initState() {
    super.initState();

    filteredServices = [];
    print("SERVICE LIST: ${widget.tsId}");
    print("SERVICE LIST: ${widget.services[2].businessDescription}");
    print("SERVICE Category: ${widget.services[2].serviceCategory}");
    // Filter the services based on tsId

    //filteredServices.addAll(widget.services);

    filteredServices.addAll(widget.services
        .where((services) => services.tsId == widget.tsId));

    // Debugging: Print filtered services
    print("Filtered services: $filteredServices");

    for (int i = 0; i < filteredServices.length; i++) {
      print("DATA ISISIS: ${filteredServices[i].companyName}");
      count++;
    }

    if(widget.tsId==1){
      title = "SHOPPING";
    }
    else if(widget.tsId==2){
      title = "TRANSPORTATIONS";
    }
    else if(widget.tsId==3){
      title = "HOTELS";
    }
    else if(widget.tsId==4){
      title = "RESTAURANTS";
    }
    else if(widget.tsId==5){
      title = "ACTIVITIES";
    }
    else if(widget.tsId==6){
      title = "TOURIST SPOT ATTRACTIONS";
    }


  }

  Uint8List? _loadImage(index) {
    getImages = filteredServices[index].TourismServiceImage!.image!;

    if (getImages == null || getImages!.isEmpty) {
      print('List images is empty');
      return null;
    }

    try {
      // Remove backslashes from the string
      getImages = getImages!.replaceAll(r'\\', '');

      // Trim the string to remove any leading or trailing whitespaces
      getImages = getImages!.trim();
      print("IMAAAAAAA: ${getImages}");

      if (getImages!.startsWith("data:image\/jpeg;base64,")) {
        // Remove the prefix "data:image/jpeg;base64,"
        getImages = getImages!.substring(getImages!.indexOf(',') + 1);
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
      ),

      body: Padding(
        // Add padding to create space between AppBar and GridView
        padding: EdgeInsets.only(top: 20.0),
        child: _buildGridView(filteredServices),
      ),
    );
  }

  Widget _buildGridView(List<tourismService> filteredServices) {

    return Container(

      height: 800, // Set an appropriate height
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
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: double.infinity,
                height: 200,
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

