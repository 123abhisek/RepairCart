import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatelessWidget {
  final List<Map<String, String>> orders = [
    {'user': 'Abhishek', 'service': 'Fan Installation', 'status': 'Pending'},
    {'user': 'Mounish', 'service': 'Mobile Repair', 'status': 'Confirmed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final item = orders[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.teal),
              title: Text('${item['user']} - ${item['service']}'),
              subtitle: Text('Status: ${item['status']}'),
              trailing: Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
