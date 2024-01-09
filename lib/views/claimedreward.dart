import 'package:flutter/material.dart';
import '../Model/reward.dart'; // Import your Reward model

class ClaimedRewardsPage extends StatelessWidget {
  final List<Reward> claimedRewards;

  const ClaimedRewardsPage({Key? key, required this.claimedRewards}) : super(key: key);

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
          return RewardItem(reward: reward);
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
      child: ListTile(
        title: Text(reward.rewardName),
        subtitle: Text('${reward.rewardPoint} Points'),
        // Customize the content based on your Reward model properties
      ),
    );
  }
}