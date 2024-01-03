import '../Controller/request_controller.dart';

class qrSpot{
  int qrId;
  int tourismServiceId;

  qrSpot(
      this.qrId,
      this.tourismServiceId
      );

  qrSpot.fromJson(Map<String, dynamic> json)
    : qrId = json['qrId'] as int,
      tourismServiceId = json['tourismServiceId'] as int;

  Map<String, dynamic> toJson() => {
    'qrId':  qrId,
    'tourismServiceId': tourismServiceId,
  };

  Future<String> getServiceId() async {
    RequestController req = RequestController(path: "/api/getServiceId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      String companyName = req.result()['companyName'];
      print(companyName);
      return companyName;
    } else {
      return ''; // or handle error case appropriately
    }
  }

}