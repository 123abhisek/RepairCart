import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_stack/screens/user/ServiceDetailScreen.dart';
import 'package:service_stack/screens/Admin/AddElectronicsServiceForm.dart';
import 'package:http/http.dart' as http;

import '../../API/API_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _slideAnimation;

  late Future<int> futureServiceCount;
  late Future<List<dynamic>> futureRecentServices;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.teal[300],
      end: Colors.teal[700],
    ).animate(_animationController);

    futureServiceCount = countServices();
    futureRecentServices = fetchServices();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 180.0,
                pinned: true,
                backgroundColor: _colorAnimation.value,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(1, 1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _colorAnimation.value!,
                          Colors.teal[900]!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Icon(
                          Icons.dashboard,
                          size: 60,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Metrics Cards
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                            children: [
                              _buildMetricCard('📦 Products', futureServiceCount, Colors.deepOrange),
                              _buildMetricCard('💵 Revenue', Future.value('₹ 1.2 L'), Colors.green),
                              _buildMetricCard('🛒 Orders', Future.value('58'), Colors.blue),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Sales Chart
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sales Overview',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                              SizedBox(height: 16),
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  height: 220,
                                  padding: EdgeInsets.all(16),
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
                                          barWidth: 4,
                                          isStrokeCapRound: true,
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.teal.withOpacity(0.1),
                                          ),
                                          dotData: FlDotData(show: true),
                                        ),
                                      ],
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 2,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                '₹${value.toInt()}k',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  days[value.toInt()],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              );
                                            },
                                            interval: 1,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: true),
                                      gridData: FlGridData(show: true),
                                      minY: 0,
                                      maxY: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Recent Products
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Recent Products',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[800],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'View All',
                                      style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              _buildRecentProducts(),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Add New Service Button
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: OpenContainer(
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            closedColor: Colors.teal,
                            openColor: Colors.white,
                            closedElevation: 4,
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedBuilder: (context, open) {
                              return Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [Colors.teal, Colors.teal[700]!],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.white),
                                      SizedBox(width: 12),
                                      Text(
                                        'Add New Service',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
                        ),
                      ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String label, Future<dynamic> futureValue, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.05),
              color.withOpacity(0.15),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Add this
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14, // Reduced font size
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              FutureBuilder<dynamic>(
                future: futureValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 30,
                        height: 20,
                        color: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Err',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return FittedBox( // Add FittedBox to scale text
                      fit: BoxFit.scaleDown,
                      child: Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                          color: color,
                          fontSize: 20, // Slightly reduced
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProducts() {
    return FutureBuilder<List<dynamic>>(
      future: futureRecentServices,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerList();
        } else if (snapshot.hasError) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    SizedBox(height: 16),
                    Text(
                      "Failed to load services",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.handyman, size: 48, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      "No services found",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        List<dynamic> services = snapshot.data!;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: services.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;
              // Staggered animation
              final delay = (index * 0.15).clamp(0.0, 0.7);
              final end = (delay + 0.3).clamp(0.0, 1.0);

              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(delay, end, curve: Curves.elasticOut),
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(delay, end, curve: Curves.easeIn),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.teal[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.devices, color: Colors.teal),
                    ),
                    title: Text(
                      service['service_name'] ?? 'Unnamed Service',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "₹${service['price'] ?? '0'}",
                      style: TextStyle(color: Colors.teal[700]),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 600),
                          pageBuilder: (_, __, ___) => ServiceDetailScreen(
                            id: service['_id'],
                            serviceName: service['service_name'],
                            category: service['category'],
                            description: service['description'],
                            price: service['price'],
                          ),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.5),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 80,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}