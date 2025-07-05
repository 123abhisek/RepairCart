import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:service_stack/screens/user/ServiceDetailScreen.dart';
import 'dart:convert';
import '../../API/API_service.dart';
import 'AddElectronicsServiceForm.dart';


class AdminDashboard extends StatefulWidget  {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<AdminDashboard> {

  late Future<int> futureServiceCount;

  @override
  void initState() {
    super.initState();
    futureServiceCount = countServices();
  }

  Future<List<dynamic>> fetchServices() async {
    API_service url = API_service();
    try {
      final response = await http.get(
          Uri.parse("${url.API_URL}services/recent")
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception("Failed to load services");
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }


  Future<int> countServices() async {
    API_service url = API_service();
    try {
      final response = await http.get(
        Uri.parse("${url.API_URL}service/count_services"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['service_count'];
      } else {
        throw Exception("Failed to load service count");
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Metrics overview row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<int>(
                  future: futureServiceCount,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      // Got the count
                      int count = snapshot.data ?? 0;
                      return Container(
                        child: _buildMetricCard('📦 Products', count.toString(), Colors.deepOrange),
                      );
                    }
                  },
                ),
                _buildMetricCard('💵 Revenue', '₹ 1.2 L', Colors.green),
                _buildMetricCard('🛒 Orders', '58', Colors.blue),
              ],
            ),
            SizedBox(height: 16),

            // Sales chart placeholder
            _buildSectionTitle('Sales Overview'),
            _buildCard(
              child: Container(
                height: 200,
                padding: EdgeInsets.all(8),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: [
                          FlSpot(0, 1),
                          FlSpot(1, 3),
                          FlSpot(2, 4),
                          FlSpot(3, 7),
                          FlSpot(4, 6),
                          FlSpot(5, 10),
                        ],
                        color: Colors.teal,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.teal.withOpacity(0.3),
                        ),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                            return Text(days[value.toInt()], style: TextStyle(fontSize: 12));
                          },
                          interval: 1,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                    minY: 0,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Recent Products List
            // Recent Products List
            _buildSectionTitle('Recent Products'),
            FutureBuilder<List<dynamic>>(
              future: fetchServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No services found'));
                }

                List<dynamic> services = snapshot.data!;

                return _buildCard(
                  child: Column(
                    children: services.map((service) {
                      return ListTile(
                        leading: const Icon(Icons.devices, color: Colors.teal),
                        title: Text(service['service_name'] ?? 'Unnamed Service'),
                        subtitle: Text("₹${service['price'] ?? '0'}"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Optional: Navigate to detail page or show dialog
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailScreen(id : service['_id'],serviceName: service['service_name'], category: service['category'], description: service['description'], price: service['price'])));
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),


            SizedBox(height: 24),
            // Animated add new product button
            OpenContainer(
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              closedColor: Colors.teal,
              openColor: Colors.white,
              closedElevation: 4,
              transitionType: ContainerTransitionType.fade,
              closedBuilder: (context, open) {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Center(
                    child: Text(
                      '➕ Add New Service',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
              openBuilder: (context, close) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Add Electronics Service'),
                    backgroundColor: Colors.teal,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AddElectronicsServiceForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(padding: EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal[800])),
      ),
    );
  }
}