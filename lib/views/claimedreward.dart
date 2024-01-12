import 'package:flutter/material.dart';
import '../Model/reward.dart'; // Import your Reward model

class ClaimedRewardsPage extends StatelessWidget {
  final List<Reward> claimedRewards;
  final int appUserId;

  const ClaimedRewardsPage({Key? key, required this.claimedRewards, required this.appUserId}) : super(key: key);

  void showClaimCodeDialog(BuildContext context, Reward reward) {
    // Generate claimCode by concatenating rewardCode and appUserId
    String claimCode = '${reward.rewardCode}$appUserId';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${reward.rewardName}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Claim Code: $claimCode'),
              Text('Terms & Condition : ${reward.tnc}'),
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
        title: const Text('Claimed Rewards'),
      ),
      body: ListView.builder(
        itemCount: claimedRewards.length,
        itemBuilder: (context, index) {
          Reward reward = claimedRewards[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Show the claim code when the redeemed reward is tapped
                      showClaimCodeDialog(context, reward);
                    },
                    child: RewardItem(reward: reward),
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

class RewardItem extends StatelessWidget {
  final Reward reward;

  const RewardItem({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reward.rewardName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${reward.rewardPoint} Points',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            // Add more information or customize as needed
          ],
        ),
      ),
    );
  }
}
