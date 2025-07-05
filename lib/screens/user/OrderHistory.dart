import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<OrderHistory> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _nameController = TextEditingController(text: "Abhishek R J");
  final TextEditingController _emailController = TextEditingController(text: "abhis@example.com");
  final TextEditingController _phoneController = TextEditingController(text: "+91 9876543210");

  final List<Map<String, dynamic>> orderHistory = [
    {'service': 'Computer Repair', 'date': '12 June 2025', 'status': 'Completed'},
    {'service': 'Mobile Screen Fix', 'date': '10 June 2025', 'status': 'Completed'},
  ];

  final List<Map<String, dynamic>> upcomingBookings = [
    {'service': 'TV Wall Mounting', 'date': '20 June 2025', 'status': 'Scheduled'},
    {'service': 'Fan Installation', 'date': '22 June 2025', 'status': 'Scheduled'},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('My Profile'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Order History'),
            Tab(text: 'Upcoming'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Profile Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.deepPurple[200],
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    _buildTextField("Name", _nameController),
                    _buildTextField("Email", _emailController),
                    _buildTextField("Phone", _phoneController),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: Colors.deepPurple,
                        ));
                      },
                      icon: Icon(Icons.save),
                      label: Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(orderHistory, isHistory: true),
                _buildList(upcomingBookings, isHistory: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data, {required bool isHistory}) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(Icons.build_circle_outlined, color: Colors.deepPurple),
            title: Text(item['service']),
            subtitle: Text("Date: ${item['date']}"),
            trailing: Chip(
              label: Text(item['status']),
              backgroundColor: isHistory ? Colors.green[100] : Colors.orange[100],
              labelStyle: TextStyle(
                color: isHistory ? Colors.green[800] : Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
