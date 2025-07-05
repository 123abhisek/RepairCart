import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final List<Map<String, String>> bookings = [
    {'service': 'Fan Installation', 'date': '22 June 2025'},
    {'service': 'AC Cleaning', 'date': '25 June 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookings'), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final item = bookings[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.build, color: Colors.deepPurple),
              title: Text(item['service']!),
              subtitle: Text("Scheduled on: ${item['date']}"),
            ),
          );
        },
      ),
    );
  }
}
