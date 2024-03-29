import 'dart:async';
import 'dart:convert'; // Add this import for jsonEncode and jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/redemption.dart';
import '../Model/appUser.dart';
import 'package:melakago/Model/reward.dart';
import 'package:intl/intl.dart';
import 'package:melakago/views/home_view.dart';
import 'package:melakago/views/qr_scanner.dart';
import 'package:melakago/views/editProfile.dart';

import 'claimedrewards.dart';

class DateUtils {
  static String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }
}

class RewardPage extends StatefulWidget {
  late appUser user;

  RewardPage({Key? key, required appUser user}) : super(key: key) {
    this.user = user;
  }

  @override
  State<RewardPage> createState() => RewardPageState();
}

class RewardPageState extends State<RewardPage> {
  int rewardIndex = 0;
  int rewardId = 0;
  String rewardName = '';
  String rewardCode = '';
  String tnc = '';

  int redeemId = 0;
  int appUserId = 0;
  int pointsRedeemed = 0;
  int status = 0;
  DateTime now = DateTime.now();
  String dateRedeemed = DateUtils.getCurrentDate();
  String expirationDate = DateUtils.getCurrentDate();

  int totalRedeemedPoints = 0;

  List<Reward> rewards = [];
  List<Reward> claimedRewards = [];

  // SharedPreferences key for storing claimed rewards
  static const String claimedRewardsKey = 'claimed_rewards';

  Future<List<Reward>> reward() async {
    int rewardPoint = widget.user.points!;
    Reward reward = Reward.getReward(
      rewardPoint,
      widget.user.appUserId
    );

    List<Reward> fetchedRewards = await reward.fetchRewards();

    setState(() {
      rewards.clear();
      rewards.addAll(fetchedRewards);
    });
    return fetchedRewards;
  }

  @override
  void initState() {
    super.initState();
    // Load claimed rewards when the page initializes
    loadClaimedRewards().then((loadedClaimedRewards) {
      setState(() {
        claimedRewards = loadedClaimedRewards;
      });
    });

    reward(); // Fetch rewards data when the page initializes
  }

  Future<List<Reward>> loadClaimedRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? claimedRewardsJson = prefs.getStringList(claimedRewardsKey);

    if (claimedRewardsJson != null) {
      List<Reward> loadedClaimedRewards =
      claimedRewardsJson.map((json) => Reward.fromJson(jsonDecode(json))).toList();
      return loadedClaimedRewards;
    } else {
      return [];
    }
  }

  Future<void> saveClaimedRewards(List<Reward> claimedRewards) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> claimedRewardsJson =
    claimedRewards.map((reward) => jsonEncode(reward.toJson())).toList();
    prefs.setStringList(claimedRewardsKey, claimedRewardsJson);
  }

  void claimReward(Reward reward) async {
    try {
      int appUserId = widget.user.appUserId!;
      int totalPoints = widget.user.points ?? 0;

      if (totalPoints >= (reward.rewardPoint ?? 0)) {
        totalPoints -= reward.rewardPoint ?? 0;
        bool pointsDeducted = await widget.user.deductPoints(totalPoints);

        if (pointsDeducted) {
          String claimCode='';
          claimCode = reward.rewardCode! + appUserId.toString();
          Redemption redemption = Redemption(
            rewardId: reward.rewardId,
            appUserId: appUserId,
            claimCode: claimCode,
            pointsRedeemed: totalRedeemedPoints + reward.rewardPoint!,
            dateRedeemed: dateRedeemed,
            expirationDate: expirationDate,
            status: status,
          );

          if (await redemption.saveRedeem()) {
            setState(() {
              totalRedeemedPoints += reward.rewardPoint!;
              rewards.remove(reward);
              claimedRewards.add(reward);
            });

            widget.user.points = totalPoints;

            await saveClaimedRewards(claimedRewards);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Congratulations! You have claimed the reward.'),
              ),
            );
          } else {
            print("Failed to save redemption.");
          }
        } else {
          print("Failed to deduct points.");
        }
      } else {
        print('Insufficient points to redeem this reward.');
      }
    } catch (e) {
      print('Error claiming reward: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Rewards',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 25,
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
                                child: Text('Claim',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                appUser user = widget.user;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClaimedRewardsPages(user: user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Set the background color to black
              ),
              child: Text('My Claimed Rewards',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            // Set showSelectedLabels and showUnselectedLabels to false
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),// Adjust the vertical padding as needed
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, color: Colors.black),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code, color: Colors.black),
                label: 'QrCode',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard, color: Colors.black),
                label: 'Reward',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: 'Account',
              ),
            ],
            onTap: (index) {
              // Handle item tap
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExplorePage(user: widget.user),
                    ),
                  );
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScanner(user: widget.user),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RewardPage(user: widget.user),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => updateProfilePage(user: widget.user),
                    ),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  void onRewardTap(Reward reward) {
    print('Reward tapped: ${reward.rewardName}');
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
        title: Text(reward.rewardName!),
        subtitle: Text('${reward.rewardPoint} Points'),
        onTap: () {
          // Show claim code when tapped
          showClaimCodeDialog(context);
        },
      ),
    );
  }
}