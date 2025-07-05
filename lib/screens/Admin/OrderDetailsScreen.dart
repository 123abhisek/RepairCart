import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({required this.order});

  double calculateTotal(List<dynamic> items) {
    return items.fold(0.0, (sum, item) {
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
      final qty = (item['qty'] ?? 1).toDouble();
      return sum + (price * qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> items = order['items'] ?? [];
    final double totalAmount = calculateTotal(items);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['_id']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Created At: ${order['created_at']}'),
            SizedBox(height: 16),
            Text('Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                    child: ListTile(
                      title: Text(item['service_name'] ?? 'Unknown Service'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: ₹${item['price']}'),
                          Text('Quantity: ${item['qty']}'),
                          Text('Service ID: ${item['service_id']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ₹${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
