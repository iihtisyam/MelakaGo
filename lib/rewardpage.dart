import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
                    RewardItem(name: 'Discount Coupon', points: 100),
                    RewardItem(name: 'Free Item', points: 200),
                    RewardItem(name: 'Exclusive Access', points: 150),
                    // Additional rewards
                    RewardItem(name: 'Free Parking', points: 100),
                    RewardItem(name: 'Zoo Melaka', points: 500),
                    RewardItem(name: 'Taman Buaya', points: 400),
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
}