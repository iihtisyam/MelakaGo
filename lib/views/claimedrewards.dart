import 'package:flutter/material.dart';
import '../Model/appUser.dart';
import '../Model/redemption.dart';
import '../Model/reward.dart'; // Import your Reward model

class ClaimedRewardsPages extends StatefulWidget {
  final appUser user;

  ClaimedRewardsPages({required this.user});

  @override
  _ClaimedRewardsPagesState createState() => _ClaimedRewardsPagesState();
}

class _ClaimedRewardsPagesState extends State<ClaimedRewardsPages> {
  List<Redemption> rewards = [];

  @override
  void initState() {
    super.initState();
    // Call the asynchronous method here
    _loadClaimedReward();
  }

  Future<void> _loadClaimedReward() async {
    Redemption claimedReward = Redemption.getByAppUser(widget.user.appUserId);

    List<Redemption> loadReward = await claimedReward.claimedRewards();

    print("FFFF: ${loadReward[1].claimCode}");
    print("RewardName: ${loadReward[1].reward?.rewardName}");

    setState(() {
      rewards.clear();
      rewards.addAll(loadReward);
    });
  }

  void showClaimCodeDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${rewards[index].reward?.rewardName ?? ''}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Claim Code: ${rewards[index].claimCode}'),
              Text('Terms and Conditions: \n${rewards[index].reward?.tnc}')
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
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 90,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Claimed Rewards',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,),
          ),
        ),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: ListView.builder(
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Show the claim code when the redeemed reward is tapped
                      showClaimCodeDialog(context, index);
                    },
                    child: Card(
                      // Add a Card widget with Text inside
                      elevation: 3, // Adjust elevation as needed
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          rewards[index].reward?.rewardName ?? '',
                          style: TextStyle(fontSize: 25),
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

    );
  }
}

