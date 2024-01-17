import '../Controller/request_controller.dart';
import 'package:http/http.dart' as http;
import 'package:melakago/Model/reward.dart';

class Redemption {
  int? redeemId;
  int? rewardId;
  int? appUserId;
  String? claimCode;
  int? pointsRedeemed;
  String? dateRedeemed;
  String? expirationDate;
  int? status;
  Reward? reward;

  Redemption({
    this.redeemId,
    this.rewardId,
    this.appUserId,
    this.claimCode,
    this.pointsRedeemed,
    this.dateRedeemed,
    this.expirationDate,
    this.status,
    this.reward
  });

  Redemption.getByAppUser(
      this.appUserId,
      );

  /*factory Redemption.fromJson(Map<String, dynamic> json) {
    return Redemption(
      redeemId: json['redeemId'],
      rewardId: json['rewardId'],
      appUserId: json['appUserId'],
      pointsRedeemed: json['pointsRedeemed'],
      dateRedeemed: json['dateRedeemed'],
      expirationDate: json['expirationDate'],
      status: json['status'],
    );
  }*/

  Redemption.fromJson(Map<String, dynamic>json)
      : redeemId = int.tryParse(json['redeemId'] ?? '') ?? 0,
        rewardId = int.tryParse(json['rewardId'] ?? '') ?? 0,
        appUserId = int.tryParse(json['appUserId'] ?? '') ?? 0,
        claimCode = json['claimCode'] as String? ??"",
        pointsRedeemed = int.tryParse(json['pointsRedeemed'] ?? '') ?? 0,
        dateRedeemed = json['dateRedeemed'] as String? ??"",
        expirationDate = json['expirationDate'] as String? ??"",
        status = int.tryParse(json['status'] ?? '') ?? 0,
        reward = Reward.getRewardName(
            json['rewardName'] as String? ??"",
            json['tnc'] as String? ??"",
        );

  Map<String, dynamic> toJson() =>
      {
        'redeemId': redeemId,
        'rewardId': rewardId,
        'appUserId': appUserId,
        'claimCode':claimCode,
        'pointsRedeemed': pointsRedeemed,
        'dateRedeemed': dateRedeemed,
        'expirationDate': expirationDate,
        'status': status,
      };


  Future<bool> saveRedeem() async {
    RequestController req = RequestController(path: "/api/redeem.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return true;
    } else if (req.status() == 200) {
      String data = req.result().toString();
      if (data == '{error: Redemption failed}') {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }


  Future<List<Redemption>> claimedRewards() async {
    List<Redemption> result = [];

    RequestController req = RequestController(path: "/api/getClaimedReward.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200 && req.result() != null) {

      List<dynamic> responseData = req.result();

      if (responseData.isNotEmpty) {
        for (var item in responseData) {
          result.add(Redemption.fromJson(item));
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

