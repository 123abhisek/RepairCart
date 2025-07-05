
import 'package:flutter/material.dart';
import 'package:service_stack/screens/user/BookingScreen.dart';
import 'package:service_stack/screens/user/PaymentScreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {'title': 'Computer Repair', 'price': 499},
    {'title': 'TV Installation', 'price': 299},
    {'title': 'Mobile Screen Replacement', 'price': 799},
    {'title': 'charges', 'price': 3},
  ];

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
        TextEditingController(text: cartItems[index]['title']);
        return AlertDialog(
          title: Text('Edit Service'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
    return cartItems.fold(0.0, (sum, item) => sum + (item['price'] as num).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    title: Text(cartItems[index]['title'],
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text("₹${cartItems[index]['price']}"),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("₹${calculateTotal()}",
                    style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Confirm order logic
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirm Order"),
                    content: Text("Order placed successfully!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentScreen()),
                        ),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.check_circle),
              label: Text('Confirm Order'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
