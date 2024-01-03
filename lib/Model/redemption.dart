import '../Controller/request_controller.dart';
import 'package:http/http.dart' as http;
import 'package:melakago/Model/reward.dart';

class Redemption {
  int? redeemId;
  int? rewardId;
  int? appUserId;
  int? pointsRedeemed;
  String? dateRedeemed;
  String? expirationDate;
  String? status;

  Redemption({
    this.redeemId,
    this.rewardId,
    this.appUserId,
    this.pointsRedeemed,
    this.dateRedeemed,
    this.expirationDate,
    this.status,
  });

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
        pointsRedeemed = int.tryParse(json['pointsRedeemed'] ?? '') ?? 0,
        dateRedeemed = json['dateRedeemed'] as String? ?? "",
        expirationDate = json['expirationDate'] as String? ?? "",
        status = json['status'] as String? ?? "";

  Map<String, dynamic> toJson() =>
      {
        'redeemId': redeemId,
        'rewardId': rewardId,
        'appUserId': appUserId,
        'pointsRedeemed': pointsRedeemed,
        'dateRedeemed': dateRedeemed,
        'expirationDate': expirationDate,
        'status': status,
      };

  Future<void> redeemReward(int userId, Reward reward) async {
    // Extract the rewardId from the Reward object
    final int rewardId = reward.rewardId ?? 0;

    // Perform HTTP request to redeem the reward
    final response = await http.post(
      Uri.parse('http://192.168.0.17/redeem.php'),
      body: {
        'userId': userId.toString(),
        'rewardId': rewardId.toString(),
      },
    );

    if (response.statusCode == 200) {
      // If reward redemption is successful
      print('Reward redeemed successfully.');
    } else {
      // If the server returns an error response,
      // throw an exception or handle accordingly.
      print('Failed to redeem reward.');
    }
  }
}

/*static Future<List<Redemption>> fetchRedeemRewards() async {
    final response = await http.get(Uri.parse("/api/redeem.php"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Redemption().fromJson(json)).toList();
    } else {
      throw Exception('Failed to load redeem rewards');
    }
  }

  Future<bool> redeem() async {
    try {
      RequestController req = RequestController(path: "/api/redeem.php");
      req.setBody(toJson());

      await req.post();

      if (req.status() == 200) {
        // Optionally, you can handle any response data here
        print('Reward redemption successful');
        return true;
      } else {
        print('Failed to redeem reward. Status code: ${req.status()}');
        return false;
      }
    } catch (e) {
      print('Exception while redeeming reward: $e');
      return false;
    }
  }

  Future<void> _loadAvailableRewards() async {
    try {
      List<Redemption> rewards = await Redemption.fetchRedeemRewards();
      setState(() {
        availableRewards = rewards;
      });
    } catch (e) {
      // Handle error
      print('Error loading available rewards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your code to display available rewards
    return ListView.builder(
      itemCount: availableRewards.length,
      itemBuilder: (context, index) {
        return RewardItem(
          name: availableRewards[index].name,
          points: availableRewards[index].points,
        );
      },
    );
  }*/


// Add any additional methods as needed