import 'dart:convert';
import 'dart:typed_data';

import '../Controller/request_controller.dart';

class tourismServiceImage {

  int? imageId;
  String? image;
  int? tourismServiceId;

  tourismServiceImage(
     this.imageId,
     this.image,
     this.tourismServiceId
  );

  tourismServiceImage.forImage(
      this.imageId,
      this.image
      );


  tourismServiceImage.fromJson(Map<String, dynamic> json)
      : imageId = json['imageId'] as dynamic,
        image = json['image'] as String,
        tourismServiceId = json['tourismServiceId'] as dynamic;

  // toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'imageId': imageId,
    'image': image,
    'tourismServiceId': tourismServiceId,
  };


}