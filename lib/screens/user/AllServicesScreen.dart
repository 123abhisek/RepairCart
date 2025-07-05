import 'package:flutter/material.dart';
import 'package:service_stack/screens/user/ServiceDetailScreen.dart';
import '../../API/API_service.dart';

class AllServicesScreen extends StatefulWidget {
  @override
  _AllServicesScreenState createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {

  late Future<List<dynamic>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = API_service().fetchAllServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Services"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No services available"));
          }

          final services = snapshot.data!;

          print('total services : $services');

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.devices, color: Colors.teal),
                  title: Text(service['service_name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${service['category'] ?? ''}'),
                      Text('Price: ₹${service['price'] ?? ''}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(
                          id : service['_id'] ?? '',
                          serviceName: service['service_name'] ?? '',
                          category: service['category'] ?? '',
                          description: service['description'] ?? '',
                          price: service['price']?.toString() ?? '',
                          // dateOfCreation: service['date_Of_Creation'] ?? '',
                        ),
                      ),
                    );

                    print('${service['_id']}, ${service['service_name']}, ${service['category']}, ${service['description']}, ${service['price']}');

                  },
                ),

              );
            },
          );
        },
      ),
    );
  }
}
