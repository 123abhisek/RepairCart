import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:service_stack/screens/user/PaymentScreen.dart';

import '../../API/API_service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    API_service apiService = API_service();
    final fullUrl = "${apiService.API_URL}cart/get_cart_items";
    final uri = Uri.parse(fullUrl);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cartItems = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void editItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller =
            TextEditingController(text: cartItems[index]['title'] ?? '');
        return AlertDialog(
          title: Text('Edit Service'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cartItems[index]['title'] = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  double calculateTotal() {
    return cartItems.fold(0.0, (sum, item) {
      final price = item['price'];
      final priceValue = double.tryParse(price.toString()) ?? 0.0;
      return sum + priceValue;
    });
  }

  Future<void> placeOrder() async {
    API_service apiService = API_service();
    final fullUrl = "${apiService.API_URL}order/place_order/";
    final uri = Uri.parse(fullUrl);

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(cartItems),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // ✅ Clear cart items in UI
        await clearCartOnServer();
        setState(() {
          cartItems.clear();
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Order"),
            content: Text(
                "Order placed successfully! Order ID: ${responseData['order_id']}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
                child: Text("Proceed to Payment"),
              ),
            ],
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Order Failed"),
            content: Text("Error: ${errorData['error'] ?? 'Unknown error'}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Something went wrong: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> clearCartOnServer() async {
    API_service apiService = API_service();
    final fullUrl = "${apiService.API_URL}cart/clear_cart";
    final uri = Uri.parse(fullUrl);

    try {
      final response = await http.delete(uri);  // or use DELETE if your API is designed that way
      if (response.statusCode == 200) {
        print('Cart cleared successfully on server');
      } else {
        print('Failed to clear cart on server');
      }
    } catch (e) {
      print('Error clearing cart on server: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Your cart is empty.'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(12),
                              title: Text(item['service_name'] ?? 'No title',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "₹${double.tryParse(item['price'].toString()) ?? 0.0}"),
                                  Text("ID: ${item['service_name'] ?? 'N/A'}"),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => editItem(index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => removeItem(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("₹${calculateTotal()}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(

                        onPressed: placeOrder,
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) => AlertDialog(
                        //       title: Text("Confirm Order"),
                        //       content: Text("Order placed successfully!"),
                        //       actions: [
                        //         TextButton(
                        //           onPressed: () => {
                        //             placeOrder(),
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       PaymentScreen()),
                        //             )
                        //           },
                        //           child: Text("OK"),
                        //         ),
                        //       ],
                        //     ),
                        //   );
                        // },
                        icon: Icon(Icons.check_circle),
                        label: Text('Confirm Order'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
