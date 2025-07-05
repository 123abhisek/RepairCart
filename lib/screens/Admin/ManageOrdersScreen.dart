import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../API/API_service.dart';
import 'OrderDetailsScreen.dart';

class ManageOrdersScreen extends StatefulWidget {
  @override
  _ManageOrdersScreenState createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    API_service apiService = API_service();
    final fullUrl = "${apiService.API_URL}order/get_orders";
    final uri = Uri.parse(fullUrl);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(child: Text('No orders found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final items = order['items'] as List<dynamic>;
          final firstItem = items.isNotEmpty ? items[0] : {};
          final serviceName = firstItem['service_name'] ?? 'N/A';

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.teal),
              title: Text('Order ${order['_id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service: $serviceName'),
                  Text('Items: ${items.length}'),
                  Text('Created: ${order['created_at']}'),
                ],
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Handle tap to see order details, etc
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
