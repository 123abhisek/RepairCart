import 'package:flutter/material.dart';
import 'package:service_stack/screens/user/LoginPage.dart';
import 'package:service_stack/screens/user/SignupPage.dart';

class OwnerProfileView extends StatelessWidget {
  final String ownerName = "Ramesh Kumar";
  final String shopName = "RK Electronics & Services";
  final String experience =
      "12 years of experience in electronics and home services.";
  final String gstNumber = "29ABCDE1234F1Z5";
  final String phone = "+91 9876543210";
  final String email = "ramesh.rkservices@example.com";
  final List<String> achievements = [
    "Top Rated",
    "Certified Technician",
    "500+ Orders Completed"
  ];
  final String qrImagePath = 'assets/qr_code.png'; // Your QR code image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Owner Profile"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.deepPurple[100],
                    child:
                        Icon(Icons.person, size: 50, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text(ownerName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(shopName,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Experience
            _sectionTitle("Experience"),
            _infoCard(experience),

            // Achievements
            _sectionTitle("Achievements"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: achievements.map((ach) {
                return Chip(
                  label: Text(ach),
                  backgroundColor: Colors.deepPurple.shade50,
                  labelStyle: TextStyle(color: Colors.teal),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // GST Number
            _sectionTitle("GST Number"),
            _infoCard(gstNumber),

            // Contact Details
            _sectionTitle("Contact"),
            _infoCard("📞 $phone\n📧 $email"),

            // Payment QR Code
            _sectionTitle("Payment QR Code"),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(qrImagePath, height: 200),
              ),
            ),
            SizedBox(height: 30),

            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 600), // Set desired width
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal),
      ),
    );
  }

  Widget _infoCard(String content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(content, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
