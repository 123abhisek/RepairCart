import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../API/API_service.dart';

class AddElectronicsServiceForm extends StatefulWidget {
  @override
  _AddElectronicsServiceFormState createState() => _AddElectronicsServiceFormState();
}

class _AddElectronicsServiceFormState extends State<AddElectronicsServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  Future<bool> postData(String service_name, String category, String description, String price) async {
    API_service url = API_service();

    final fullUrl = "${url.API_URL}service/add_service/";
    print("Hitting URL: $fullUrl"); // Debug print

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_name': service_name,
          'category': category,
          'description': description,
          'price': price,
          'date_Of_Creation': DateTime.now().toIso8601String(),
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
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _serviceNameController,
            decoration: const InputDecoration(
              labelText: 'Service / Product Name',
              prefixIcon: Icon(Icons.electrical_services),
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter service name' : null,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _categoryController.text.isNotEmpty ? _categoryController.text : null,
            decoration: const InputDecoration(
              labelText: 'Category (e.g., Product, Service)',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            items: ['Product', 'Service'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _categoryController.text = newValue!;
              });
            },
            validator: (value) =>
            value == null || value.isEmpty ? 'Please select a category' : null,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter description' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price (₹)',
              prefixIcon: Icon(Icons.currency_rupee),
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter price' : null,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              minimumSize: const Size(double.infinity, 50),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String service_name = _serviceNameController.text;
                String category = _categoryController.text;
                String description = _descriptionController.text;
                String price = _priceController.text;

                // TODO: Send this data to API or Database
                print("Service Added: $service_name, $category, $description, ₹$price");

                var res = await postData(service_name, category, description, price);
                print('response : $res');
                if (res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service added successfully!')),
                  );
                  Navigator.pop(context); // Return to login page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error occurs ... failed'),
                  ));
                }
              }
            },
            child: const Text('Add Service', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
