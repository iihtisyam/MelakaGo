
import 'package:flutter/material.dart';
import 'package:melakago/views/rewardpage.dart';

import '../Model/appUser.dart';
import 'qr_scanner.dart';

/*void main() {
  runApp(ExplorePage(username: ''));
*/

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExplorePage({required this.user}),
    );
  }
}*/

class ExplorePage extends StatelessWidget {

  late final appUser user;
  ExplorePage({required this.user}) : nickName = user.nickName!;
  String nickName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: ListView(
        children: <Widget>[
          buildSectionTitle(context, 'Explore'),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Attractions'),
              ),
              Expanded(
                child: buildCategoryItem('Lodging'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Foods'),
              ),
              Expanded(
                child: buildCategoryItem('Activities'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildCategoryItem('Shopping'),
              ),
              Expanded(
                child: buildCategoryItem('Transport'),
              ),
            ],
          ),
          buildSectionTitle(context, 'You might like these'),
          Row(
            children: [
              Expanded(
                child: buildPlaceItem('Kopi Chendana'),
              ),
              Expanded(
                child: buildPlaceItem('Taman Botanikal'),
              ),
              // Add more items here
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: Colors.black,),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,  color: Colors.black,),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code,  color: Colors.black,),
            label: 'QrCode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard,  color: Colors.black,),
            label: 'Reward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,  color: Colors.black,),
            label: 'Account',
          ),
        ],
        onTap: (index){
          // Handle item tap
          switch (index) {
            case 2: // Index of the QR code icon
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrScanner(user: user,), // Your QrScanner page
                ),
              );
              break;
          // Add more cases for other items if needed
            case 3: // Index of the QR code icon
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardPage(user: user,), // Your QrScanner page
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeaturedDestinations() {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDestinationCard('Paris', 'assets/paris.jpg'),
          _buildDestinationCard('New York', 'assets/new_york.jpg'),
          _buildDestinationCard('Tokyo', 'assets/tokyo.jpg'),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String destination, String imagePath) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              destination,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryCard('Restaurants', Icons.restaurant),
          _buildCategoryCard('Hotels', Icons.hotel),
          _buildCategoryCard('Attractions', Icons.location_on),
          _buildCategoryCard('Shopping', Icons.shopping_cart),
          // Add more categories as needed
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, IconData icon) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          SizedBox(height: 4),
          Text(category),
        ],
      ),
    );
  }

  Widget _buildNearbyPlaces() {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildNearbyPlaceCard('Local Park', 'assets/MelakaGo.png'),
          _buildNearbyPlaceCard('Museum', 'assets/MelakaGo.png'),
          _buildNearbyPlaceCard('Shopping Mall', 'assets/MelakaGo.png'),
        ],
      ),
    );
  }

  Widget _buildNearbyPlaceCard(String place, String imagePath) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              place,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreOnMapButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Add logic to navigate to the map screen
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
        },
        child: Text('Explore on Map'),
      ),
    );
  }

  Widget _buildScanQr(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Add logic to navigate to the map screen
          Navigator.push(context, MaterialPageRoute(builder: (context) => QrScanner(user: user,)));
        },
        child: Text('Get Your Quiz Here'),
      ),
    );
  }
}

Widget buildCategoryItem(String title) {
  return Card(
    child: ListTile(
      title: Text(title),
    ),
  );
}

Widget buildSectionTitle(BuildContext context, String title) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    ),
  );
}


Widget buildPlaceItem(String title) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Text(title[0]),
      ),
      title: Text(title),
    ),
  );
}
