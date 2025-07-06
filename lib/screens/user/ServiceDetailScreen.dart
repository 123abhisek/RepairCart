import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../API/API_service.dart';
// import 'package:intl/intl.dart'; // For formatting date

class ServiceDetailScreen extends StatelessWidget {
  final String id;
  final String serviceName;
  final String category;
  final String description;
  final String price;

  const ServiceDetailScreen({
    Key? key,
    required this.id,
    required this.serviceName,
    required this.category,
    required this.description,
    required this.price,
  }) : super(key: key);

  Future<bool> postData(String _id, int count) async {
    API_service url = API_service();

    final fullUrl = "${url.API_URL}cart/add_to_cart/";
    print("Hitting URL: $fullUrl"); // Debug print

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _id,
          'qty':count,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Server response: $responseData');
        return true;
      } else {
        print('POST failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[100],
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.build_circle_rounded, size: 80, color: Colors.teal),
                ),
                const SizedBox(height: 16),

                _buildDetail("🧾 Service Name", serviceName),
                const Divider(),
                _buildDetail("📂 Category", category),
                const Divider(),
                _buildDetail("📄 Description", description),
                const Divider(),
                _buildDetail("💰 Price", "₹ $price"),
                const Divider(),

                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 400, // Adjust as needed: e.g., 80%, fixed number, etc.
                    child: ElevatedButton.icon(
                      onPressed: () {
                        postData(id, 1 );
                        Navigator.pop(context);
                        },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            )),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
