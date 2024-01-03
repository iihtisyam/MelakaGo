import 'dart:async';
import 'package:flutter/material.dart';
import '../Model/redemption.dart';
import '../Model/appUser.dart';
import 'package:melakago/Model/reward.dart';

class RewardPage extends StatefulWidget {
  //const RewardPage({super.key});
  late appUser user;

  RewardPage({Key? key, required appUser user}) : super(key: key){
    this.user=user;
  }

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {

  int rewardIndex = 0;
  int rewardId = 0;
  String rewardName = '';
  String rewardCode = '';
  String tnc = '';

  int totalRedeemedPoints = 0;

  final List<Reward> rewards = []; // Use List<Reward> to store rewards


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

  /*void redeemReward(Reward reward) async {
    // Assuming redeeming involves an asynchronous operation
    try {
      if (widget.user.points >= reward.rewardPoint) {
        // Assuming redeeming involves an asynchronous operation
        // You may need to adjust the redeemReward method based on your backend logic
        await Redemption.redeemReward(widget.user.appUserId, reward.rewardId);

        // Perform the redemption operation here, update UI accordingly
      setState(() {
        widget.user.points -= reward.rewardPoint ?? 0;
        totalRedeemedPoints += reward.rewardPoint ?? 0;
      });

      // Display a snackbar or another form of feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Congratulations! You have redeemed the reward.'),
        ),
      );
      } else {
        // Display an error message if the user doesn't have enough points
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient points to redeem this reward.'),
          ),
        );
      }
    } catch (e) {
      print('Error redeeming reward: $e');
      // Handle errors gracefully, e.g., display an error message to the user
    }
  }*/

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
              height: 30,
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
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Total Points: ${widget.user.points}',
                      style: TextStyle(
                        fontSize: 10,
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
                print('Total Redeemed Points: $totalRedeemedPoints');
              },
              child: Text('Redeem Selected Rewards'),
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
  final VoidCallback onRedeem;

  const RewardItem({
    required this.reward,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(reward.rewardName),
        subtitle: Text('${reward.rewardPoint} Points'),
        trailing: ElevatedButton(
          onPressed: onRedeem,
          child: Text('Redeem'),
        ),
      ),
    );
  }
}

/*import 'dart:async';
import 'package:flutter/material.dart';
import '../Model/redemption.dart';
import '../Model/appUser.dart';

class RewardPage extends StatefulWidget {
  late appUser user;

  RewardPage({Key? key, required appUser user}) : super(key: key) {
    this.user = user;
  }

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  late List<Redemption> rewards;
  int totalPoints = 500; // Example total points
  int totalRedeemedPoints = 0;

  @override
  void initState() {
    super.initState();
    rewards = []; // Initialize rewards list
    fetchRewards(); // Fetch rewards data
  }

/*void fetchRewards() async {
    // Assume you have a method to fetch rewards from the server
    // In this example, I'm using a dummy method Reward.fetchRewards
    try {
      List<Redemption> fetchedRewards = await Redemption().loadReward();
      setState(() {
        rewards = fetchedRewards;
      });
    } catch (e) {
      // Handle errors or failed API requests
      print('Error fetching rewards: $e');
    }
  }

  void redeemReward(Redemption reward) async {
    // Logic to redeem the selected reward
    // In this example, I'm just adding the points to totalRedeemedPoints
    setState(() {
      totalRedeemedPoints += reward.pointsRedeemed ?? 0;
    });

    // Optionally, you can add logic to update the redeemed reward status in the database
    // You might need to have a method like reward.redeem() in your Reward class

    // Display a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reward Redeemed'),
          content: Text('Congratulations! You have redeemed the reward.'),
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
              height: 30,
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
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Total Points: $totalPoints',
                      style: TextStyle(
                        fontSize: 10,
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
                  Redemption reward = rewards[index];
                  return RewardItem(
                    reward: reward,
                    onRedeem: () => redeemReward(reward),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Logic to redeem all selected rewards (if any)
                // Replace this with your logic if needed
                print('Total Redeemed Points: $totalRedeemedPoints');
              },
              child: Text('Redeem Selected Rewards'),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardItem extends StatelessWidget {
  final Redemption reward;
  final VoidCallback onRedeem;

  const RewardItem({required this.reward, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(reward.rewardName ?? ''),
        subtitle: Text('${reward.pointsRedeemed} Points'),
        trailing: ElevatedButton(
          onPressed: onRedeem,
          child: Text('Redeem'),
        ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import '../Model/redemption.dart';

void main() => runApp(MyApp());*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: RewardRedemptionScreen(),
      ),
    );
  }
}

class RewardRedemptionScreen extends StatelessWidget {
  // Example total points
  final int totalPoints = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
            children: [
              const SizedBox(height: 8), // Add some spacing
              const Text(
                'My Reward',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        backgroundColor: Colors.lightGreen.shade700,
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.card_giftcard), text: 'Available Rewards'),
            Tab(icon: Icon(Icons.history), text: 'My Reward History'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          // Wrap the Available Rewards Tab with a ListView
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Display the total points earned in a green SizedBox
                    SizedBox(
                      height: 30,
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
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Total Points: $totalPoints',
                              style: TextStyle(
                                fontSize: 10,
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
                    // Display available rewards, you can replace this with your own logic to fetch and display rewards
                    AvailableRewardsScreen(),
                    RewardHistoryScreen(),
                    /*RewardItem(name: 'Discount Coupon', points: 100),
                    RewardItem(name: 'Free Item', points: 200),
                    RewardItem(name: 'Exclusive Access', points: 150),
                    // Additional rewards
                    RewardItem(name: 'Free Parking', points: 100),
                    RewardItem(name: 'Zoo Melaka', points: 500),
                    RewardItem(name: 'Taman Buaya', points: 400),*/
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic to redeem the selected reward
                        // This is a placeholder, replace it with your actual redemption logic
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Reward Redeemed'),
                              content: Text('Congratulations! You have redeemed the reward.'),
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
                      },
                      child: Text('Redeem Reward'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // My Reward History Tab
          RewardHistoryScreen(),
        ],
      ),
    );
  }
}


class RewardItem extends StatelessWidget {
  final String name;
  final int points;

  const RewardItem({required this.name, required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(name),
        subtitle: Text('$points Points'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Add logic to handle reward item selection
          // This is a placeholder, replace it with your actual reward selection logic
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Reward Selected'),
                content: Text('You have selected $name. Are you sure you want to redeem it?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add logic to redeem the selected reward
                      // This is a placeholder, replace it with your actual redemption logic
                      Navigator.of(context).pop();
                    },
                    child: Text('Redeem'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class RewardHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Reward History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Display reward history, you can replace this with your own logic to fetch and display history
          ListTile(
            title: Text('Discount Coupon'),
            subtitle: Text('Redeemed on 2023-01-01'),
          ),
          ListTile(
            title: Text('Free Item'),
            subtitle: Text('Redeemed on 2023-02-15'),
          ),
          ListTile(
            title: Text('Exclusive Access'),
            subtitle: Text('Redeemed on 2023-03-30'),
          ),
        ],
      ),
    );
  }
}*/