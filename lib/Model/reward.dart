import 'package:melakago/controller/request_controller.dart';
import 'package:http/http.dart' as http;

class Reward {
  final int rewardId;
  final String rewardName;
  final int? rewardPoint;
  final String rewardCode;
  final String tnc;

  Reward(
      this.rewardId,
      this.rewardName,
      this.rewardPoint,
      this.rewardCode,
      this.tnc,
      );

  Reward.fromJson(Map<String, dynamic>json)
      : rewardId = int.tryParse(json['rewardId'] ?? '') ?? 0,
        rewardName = json['rewardName'] as String? ??"",
        rewardPoint = int.tryParse(json['rewardPoint'] ?? '') ?? 0,
        rewardCode = json['rewardCode'] as String? ??"",
        tnc = json['tnc'] as String? ??"";

  Map<String, dynamic> toJson() =>{
    'rewardId': rewardId,
    'rewardName': rewardName,
    'rewardPoint': rewardPoint,
    'rewardCode': rewardCode,
    'tnc': tnc,
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

/*static Future<List<Reward>> fetchRewards(String appUserId) async {
    List<Reward> result = [];

    // Perform HTTP request to get rewards
    final RequestController req = RequestController(path: "/api/reward.php");

    // Adjust the body payload based on your backend requirements
    final Map<String, dynamic> requestBody = {
      'appUserId': appUserId,
      // Add other parameters if needed
    };

    req.setBody(requestBody);

    await req.post();

    if (req.status() == 200 && req.result() != null) {
      // If the server returns an OK response, parse the JSON
      List<dynamic> responseData = req.result();

      if (responseData.isNotEmpty) {
        for (var item in responseData) {
          result.add(Reward.fromJson(item));
          print("Result: $result");
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

  Future<String> fetchRewardName() async {
  try {
    // Assume there's a method to fetch the reward name based on rewardId
    // Replace this with your actual logic to fetch the reward name
    final rewardName = await fetchRewardNameFromServer(rewardId);
    return rewardName;
  } catch (e) {
    print('Error fetching reward name: $e');
    return ''; // Return an empty string or handle the error as needed
  }
}

// Add your actual logic to fetch the reward name
Future<String> fetchRewardNameFromServer(int? rewardId) async {
  // Replace this with your actual logic to fetch the reward name from the server
  // Example: make an HTTP request or query a database
  // Return the fetched reward name
  return 'FetchedRewardName';
}

Future<List<Redemption>> loadReward() async {
  List<Redemption> result = [];

  RequestController req = RequestController(path: "/api/redeem.php");
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
}*/