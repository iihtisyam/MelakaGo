import 'package:flutter/material.dart';

import '../Model/appUser.dart';

/*void main() {
  runApp(ExplorePage(username: ''));
}*/

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
  ExplorePage({required this.user}) : nickName = user.nickName;
  String nickName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightGreen.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Featured Destinations
            _buildSectionTitle('Featured Destinations'),
            _buildFeaturedDestinations(),

            // Categories
            _buildSectionTitle('Categories'),
            _buildCategories(),

            // Nearby Places
            _buildSectionTitle('Nearby Places'),
            _buildNearbyPlaces(),

            // Explore on Map Button
            _buildExploreOnMapButton(),
          ],
        ),
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
          _buildNearbyPlaceCard('Local Park', 'assets/park.jpg'),
          _buildNearbyPlaceCard('Museum', 'assets/museum.jpg'),
          _buildNearbyPlaceCard('Shopping Mall', 'assets/shopping_mall.jpg'),
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
}