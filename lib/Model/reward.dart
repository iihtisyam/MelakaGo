import 'package:melakago/controller/request_controller.dart';
import 'package:http/http.dart' as http;

class Reward {
  int? rewardId;
  String? rewardName;
  int? rewardPoint;
  String? rewardCode;
  String? tnc;
  int? appUserId;

  Reward(
      this.rewardId,
      this.rewardName,
      this.rewardPoint,
      this.rewardCode,
      this.tnc,
      );

  Reward.getReward(
      this.rewardPoint,
      this.appUserId,
      );

  Reward.getRewardName(
      this.rewardName,
      this.tnc
      );



  Reward.fromJson(Map<String, dynamic> json)
      : rewardId = int.tryParse(json['rewardId'] ?? '') ?? 0,
        rewardName = json['rewardName'] as String? ?? "",
        rewardPoint = int.tryParse(json['rewardPoint'].toString()) ?? 0,
        rewardCode = json['rewardCode'] as String? ?? "",
        tnc = json['tnc'] as String? ?? "";


  Map<String, dynamic> toJson() =>{
    'rewardId': rewardId,
    'rewardName': rewardName,
    'rewardPoint': rewardPoint,
    'rewardCode': rewardCode,
    'tnc': tnc,
    'appUserId': appUserId,

  };

  Future<List<Reward>> fetchRewards() async {
    List<Reward> result = [];

    RequestController req = RequestController(path: "/api/getReward.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200 && req.result() != null) {

      List<dynamic> responseData = req.result();

      if (responseData.isNotEmpty) {
        for (var item in responseData) {
          result.add(Reward.fromJson(item));
          print("Result:  ${result}");
        }
      } else {
        print('Response data is empty.');
        // Handle the case when the response data is empty
      }
    } else {
      print('Failed to fetch data.');
      // Handle the case when the request fails
    }

    return result;
  }


}

