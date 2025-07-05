import 'package:flutter/material.dart';
import 'package:service_stack/screens/Admin/AdminDashboard.dart';

class ViewClientRequirementsScreen extends StatelessWidget {
  final List<Map<String, String>> requirements = [
    {
      'client': 'Abhishek',
      'requirement': 'Wiring for new AC unit',
      'budget': '3000'
    },
    {'client': 'Mounish', 'requirement': 'TV installation', 'budget': '1500'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Requirements'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: requirements.length,
        itemBuilder: (context, index) {
          final req = requirements[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              title: Text(req['client']!),
              subtitle: Text(req['requirement']!),
              trailing: Text('₹${req['budget']}'),
            ),
          );
        },
      ),
    );
  }
}
