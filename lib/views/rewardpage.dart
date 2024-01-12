import 'dart:async';
import 'package:flutter/material.dart';
import 'package:melakago/views/claimedreward.dart';
import '../Model/redemption.dart';
import '../Model/appUser.dart';
import 'package:melakago/Model/reward.dart';
import 'package:intl/intl.dart';

class RewardPage extends StatefulWidget {
  //const RewardPage({super.key});
  late appUser user;

  RewardPage({Key? key, required appUser user}) : super(key: key){
    this.user=user;
  }

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class DateUtils {
  static String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }
}

class _RewardPageState extends State<RewardPage> {

  int rewardIndex = 0;
  int rewardId = 0;
  String rewardName = '';
  String rewardCode = '';
  String tnc = '';

  int redeemId = 0;
  int appUserId = 0;
  int pointsRedeemed = 0;
  //DateTime dateRedeemed=DateTime.now();
  //DateTime expirationDate=DateTime.now();
  int status = 0;
  DateTime now = DateTime.now();
  String dateRedeemed = DateUtils.getCurrentDate();
  String expirationDate = DateUtils.getCurrentDate();

  int totalRedeemedPoints = 0;

  List<Reward> rewards = []; // Use List<Reward> to store rewards
  List<Reward> claimedRewards = [];

  Future<List<Reward>> reward() async {
    int rewardPoint = widget.user.points!;

    Reward reward = Reward(
      rewardId,
      rewardName,
      rewardPoint,
      rewardCode,
      tnc,
    );

    List<Reward> fetchedRewards = await reward.fetchRewards();

    setState(() {
      rewards.clear();
      rewards.addAll(fetchedRewards);
      print("rewardId: ${rewards[1].rewardId}");
    });
    return fetchedRewards;


  }

  @override
  void initState() {
    super.initState();
    reward(); // Fetch rewards data when the page initializes
  }

  void claimReward(Reward reward) async {
    try {
      int appUserId = widget.user.appUserId!;
      int totalPoints = widget.user.points ?? 0;

      if (totalPoints >= (reward.rewardPoint ?? 0)) {
        // Deduct points and update totalRedeemedPoints
        totalPoints -= reward.rewardPoint ?? 0;
        //totalRedeemedPoints += reward.rewardPoint!;
        bool pointsDeducted = await widget.user.deductPoints(totalPoints);
        //getDateRedeemed = "${dateRedeemed.day}-${dateRedeemed.month}-${dateRedeemed.year}";

        if (pointsDeducted) {
          // Points deducted successfully, proceed with redemption
          Redemption redemption = Redemption(
            rewardId: reward.rewardId,
            appUserId: appUserId,
            pointsRedeemed: totalRedeemedPoints + reward.rewardPoint!,
            dateRedeemed: dateRedeemed,
            expirationDate: expirationDate,
            status: status,
          );

        if (await redemption.saveRedeem()){
          print("Redemption Successful");

          // Update local state after successful redemption
          setState(() {
            totalRedeemedPoints += reward.rewardPoint!;
            rewards.remove(reward);
            claimedRewards.add(reward);
          });

          // Update user points after successful redemption
          widget.user.points = totalPoints;

          // Display a snackbar or another form of feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Congratulations! You have claimed the reward.'),
            ),
          );
        }else {
          // Handle redemption save failure
          print("Failed to save redemption.");
        }
      } else {
          // Handle points deduction failure
          print("Failed to deduct points.");
        }
      } else {
        // Handle the case where the user doesn't have enough points
        print('Insufficient points to redeem this reward.');
      }
    } catch (e) {
      print('Error claiming reward: $e');
      // Handle errors gracefully, e.g., display an error message to the user
    }
  }

  //@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              'My Rewards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 45,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 35,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Total Points: ${widget.user.points}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Available Rewards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  Reward reward = rewards[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (rewards.isNotEmpty && rewardIndex < rewards.length)
                            ListTile(
                              contentPadding: EdgeInsets.only(bottom: 16.0),
                              title: Text(
                                reward.rewardName ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                              ),
                              subtitle: Text('${reward.rewardPoint} Points'),
                              trailing: ElevatedButton(
                                onPressed: () => claimReward(reward),
                                child: Text('Claim'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            /*Expanded(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  Reward reward = result[index];
                  return GestureDetector(
                    onTap: () => onRewardTap(reward),
                    child: Container(
                      // Your Reward UI goes here
                      // Replace this Container with your actual Reward widget
                      child: Text(reward.rewardName),
                    ),
                  );
                },
              ),
            ),*/
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Store the user before navigating
                appUser user = widget.user;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClaimedRewardsPage(appUserId: user.appUserId!, claimedRewards: claimedRewards),
                  ),
                );
              },
              child: Text('My Claimed Rewards'),
            ),
          ],
        ),
      ),
    );
  }

  void onRewardTap(Reward reward) {
    // Perform actions when a reward is tapped
    print('Reward tapped: ${reward.rewardName}');
    // Add your logic here, such as redeeming the reward or navigating to a detailed view
    // fetchRewards(); // If you want to fetch rewards again after tapping
  }

}

class RewardItem extends StatelessWidget {
  final Reward reward;
  final int appUserId;

  const RewardItem({Key? key, required this.reward, required this.appUserId})
      : super(key: key);



  void showClaimCodeDialog(BuildContext context) {
    // Generate claimCode by concatenating rewardCode and appUserId
    String claimCode = '${reward.rewardCode}$appUserId';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Claim Code'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reward: ${reward.rewardName}'),
              Text('Claim Code: $claimCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(reward.rewardName),
        subtitle: Text('${reward.rewardPoint} Points'),
        onTap: () {
          // Show claim code when tapped
          showClaimCodeDialog(context);
        },
      ),
    );
  }
}

