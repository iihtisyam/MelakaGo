import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../Model/tourismService.dart';

class detailPage extends StatefulWidget {
  final tourismService service;
  final Uint8List? imageBytes;

  detailPage({required this.service, required this.imageBytes});

  @override
  _detailPage createState() => _detailPage();
}

class _detailPage extends State<detailPage> {

  late final tourismService service;
  late final Uint8List? imageBytes;

  late final TextEditingController _companyNameController;
  late final TextEditingController _companyAddressController;
  late final TextEditingController _businessContactNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _businessStartHourController;
  late final TextEditingController _businessEndHourController;
  late final TextEditingController _faxNumberController;
  late final TextEditingController _instagramController;
  late final TextEditingController _xTwitterController;
  late final TextEditingController _threadController;
  late final TextEditingController _facebookController;
  late final TextEditingController _businessLocationController;
  late final TextEditingController _businessDescriptionController;
  late final TextEditingController _starRatingController;



  @override
  void initState() {
    super.initState();

    // Initialize controllers with respective values
    _companyNameController = TextEditingController(text: widget.service.companyName);
    _companyAddressController = TextEditingController(text: widget.service.companyAddress);
    _businessContactNumberController = TextEditingController(text: widget.service.businessContactNumber);
    _emailController = TextEditingController(text: widget.service.email);
    _businessStartHourController = TextEditingController(text: widget.service.businessStartHour);
    _businessEndHourController = TextEditingController(text: widget.service.businessEndHour);
    _faxNumberController = TextEditingController(text: widget.service.faxNumber);
    _instagramController = TextEditingController(text: widget.service.instagram);
    _xTwitterController = TextEditingController(text: widget.service.xTwitter);
    _threadController = TextEditingController(text: widget.service.thread);
    _facebookController = TextEditingController(text: widget.service.facebook);
    _businessLocationController = TextEditingController(text: widget.service.businessLocation);
    _businessDescriptionController = TextEditingController(text: widget.service.businessDescription);
    _starRatingController = TextEditingController(text: widget.service.starRating.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Center(
          child: Text(
            '${widget.service.companyName ?? ''}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
          ),
        ),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imageBytes != null)
                Image.memory(
                  widget.imageBytes!,
                  height: 250, // Adjusted image height
                  width: 200,
                  fit: BoxFit.cover,
                ),
              buildTextField('Company Name', _companyNameController),
              buildTextField('Company Address', _companyAddressController),
              buildTextField('Business Contact Number', _businessContactNumberController),
              buildTextField('Email', _emailController),
              buildTextField('Start Hour', _businessStartHourController),
              buildTextField('End Hour', _businessEndHourController),
              buildTextField('Fax Number', _faxNumberController),
              buildTextField('Instagram', _instagramController),
              buildTextField('xTwitter', _xTwitterController),
              buildTextField('Thread', _threadController),
              buildTextField('Facebook', _facebookController),
              buildTextField('Business Location', _businessLocationController),
              buildTextField('Business Description', _businessDescriptionController),
              buildTextField('Star Rating', _starRatingController),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: controller.text.isEmpty ? 50.0 : null, // Set a minimum height if text is empty
        child: TextField(
          maxLines: null, // Allows the TextField to expand vertically based on content
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Set border radius here
            ),
          ),
          controller: controller,
          readOnly: true,
        ),
      ),
    );
  }



}



