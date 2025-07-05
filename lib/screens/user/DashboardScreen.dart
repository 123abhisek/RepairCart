import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:service_stack/screens/Admin/AdminAllServicesScreen.dart';
import 'package:service_stack/screens/user/AllServicesScreen.dart';
import 'package:service_stack/screens/user/ServiceDetailScreen.dart';

class DashboardScreen extends StatelessWidget {
  final List<String> promoImages = [
    'assets/promo1.jpeg',
    'assets/promo2.jpeg',
    'assets/promo3.jpeg',
    'assets/promo4.jpeg'
  ];

  final List<Map<String, dynamic>> serviceCategories = [
    {'icon': Icons.computer, 'title': 'Computers'},
    {'icon': Icons.phone_android, 'title': 'Mobiles'},
    {'icon': Icons.tv, 'title': 'TV & Appliances'},
    {'icon': Icons.electrical_services, 'title': 'Electronics'},
    {'icon': Icons.home_repair_service, 'title': 'Home Services'},
    {'icon': Icons.plumbing, 'title': 'Plumbing'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Promotions Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.85,
              ),
              items: promoImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.deepPurple[100]),
                        child: Image.asset(imagePath, fit: BoxFit.cover),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Service Categories Grid
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Service Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: serviceCategories.map((category) {
                  return Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Navigate to category details
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['icon'], size: 40, color: Colors.deepPurple),
                          const SizedBox(height: 10),
                          Text(
                            category['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      onTapUp: (details) => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllServicesScreen(),)),
                      },
                    ),

                  );

                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
