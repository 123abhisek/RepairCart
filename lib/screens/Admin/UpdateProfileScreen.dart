import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatelessWidget {
  final TextEditingController nameController =
      TextEditingController(text: "Ramesh Kumar");
  final TextEditingController emailController =
      TextEditingController(text: "ramesh@example.com");
  final TextEditingController phoneController =
      TextEditingController(text: "+91 9988776655");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(nameController, 'Name'),
            SizedBox(height: 10),
            _buildTextField(emailController, 'Email'),
            SizedBox(height: 10),
            _buildTextField(phoneController, 'Phone'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
