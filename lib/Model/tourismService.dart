import 'dart:convert';

import '../Controller/request_controller.dart';

class tourismService {

  int? tourismServiceId;
  String? companyName;
  String? companyAddress;
  String? businessContactNumber;
  String? email;
  String? businessStartHour;
  String? businessEndHour;
  String? faxNumber;
  String? instagram;
  String? xTwitter;
  String? thread;
  String? facebook;
  String? businessLocation;
  int? starRating;
  String? businessDescription;
  int? tsId;
  int? isDelete;

  tourismService({ this.tourismServiceId,
    this.companyName,
    this.companyAddress,
    this.businessContactNumber,
    this.email,
    this.businessStartHour,
    this.businessEndHour,
    this.faxNumber,
    this.instagram,
    this.xTwitter,
    this.thread,
    this.facebook,
    this.businessLocation,
    this.starRating,
    this.businessDescription,
    this.tsId,
    this.isDelete
  });


  tourismService.getId(
      this.companyName,
      this.companyAddress,
      this.businessContactNumber,
      );

  tourismService.getIdQuiz(
      this.companyName,
      );

  tourismService.fromJson(Map<String, dynamic> json)
      : tourismServiceId = json['tourismServiceId'] as dynamic?,
        companyName = json['companyName'] as String? ?? '',
        companyAddress = json['companyAddress'] as String? ?? '',
        businessContactNumber = json['businessContactNumber'] as String? ?? '',
        email = json['email'] as String? ?? '',
        businessStartHour = json['businessStartHour'] as String? ?? '',
        businessEndHour = json['businessEndHour'] as String? ?? '',
        faxNumber = json['faxNumber'] as String? ?? '',
        instagram = json['instagram'] as String? ?? '',
        xTwitter = json['xTwitter'] as String? ?? '',
        facebook = json['facebook'] as String? ?? '',
        businessLocation = json['businessLocation'] as String? ?? '',
        starRating = json['starRating'] as dynamic?,
        businessDescription = json['businessDescription'] as String? ?? '',
        tsId = json['tsId'] as dynamic?,
        isDelete = json['isDelete'] as dynamic?;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'tourismServiceId': tourismServiceId,
    'companyName': companyName,
    'companyAddress': companyAddress,
    'businessContactNumber': businessContactNumber,
    'email': email,
    'businessStartHour': businessStartHour,
    'businessEndHour': businessEndHour,
    'faxNumber': faxNumber,
    'instagram': instagram,
    'xTwitter': xTwitter,
    'thread': thread,
    'facebook': facebook,
    'businessLocation': businessLocation,
    'starRating': starRating,
    'businessDescription': businessDescription,
    'tsId': tsId,
    'isDelete': isDelete,
  };

  Future<bool> saveService() async {
    RequestController req = RequestController(path: "/api/tourismService.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {

      return true;
    }

    else {
      return false;
    }
  }




  Future<bool> getCompanyName(int tourismServiceId) async {
    RequestController req = RequestController(path: "/api/getCompanyName.php");
    req.setBody({"tourismServiceId": tourismServiceId});
    await req.post();
    if (req.status() == 200) {
      companyName = req.result()['companyName'];
      print(companyName);
      return true;
    } else {
      return false;
    }
  }


}