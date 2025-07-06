import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_stack/screens/user/ServiceDetailScreen.dart';
import '../../API/API_service.dart';

class AllServicesScreen extends StatefulWidget {
  @override
  _AllServicesScreenState createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _servicesFuture;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _colorAnimation;

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredServices = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _servicesFuture = API_service().fetchAllServices();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.teal[400],
      end: Colors.teal[700],
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices(String query, List<dynamic> services) {
    if (query.isEmpty) {
      setState(() {
        _filteredServices = services;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredServices = services.where((service) {
        final name = service['service_name']?.toString().toLowerCase() ?? '';
        final category = service['category']?.toString().toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return name.contains(queryLower) || category.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  title: AnimatedOpacity(
                    opacity: _opacityAnimation.value,
                    duration: Duration(milliseconds: 300),
                    child: Text("All Services", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1),)]
                    )),
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
                    child: SafeArea(
                      child: Center(
                        child: Icon(
                          Icons.construction,
                          size: 60,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Search Bar
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        prefixIcon: Icon(Icons.search, color: Colors.teal),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _servicesFuture.then((services) => _filterServices(value, services));
                      },
                    ),
                  ),
                ),
              ),

              // Services Grid
              FutureBuilder<List<dynamic>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerGrid();
                  } else if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                            SizedBox(height: 16),
                            Text("Failed to load services", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            Text("Please check your connection", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => setState(() {
                                _servicesFuture = API_service().fetchAllServices();
                              }),
                              icon: Icon(Icons.refresh),
                              label: Text("Try Again"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.handyman, size: 48, color: Colors.teal[300]),
                            SizedBox(height: 16),
                            Text("No services available", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            Text("Check back later for new services", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  }

                  final services = _isSearching ? _filteredServices : snapshot.data!;
                  final itemCount = services.isEmpty && _isSearching ? 1 : services.length;

                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (services.isEmpty && _isSearching) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                                  SizedBox(height: 16),
                                  Text("No matching services", style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          }

                          final service = services[index];
                          return _buildServiceCard(service, index);
                        },
                        childCount: itemCount,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(dynamic service, int index) {
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
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 600),
                  pageBuilder: (_, __, ___) => ServiceDetailScreen(
                    id: service['_id'] ?? '',
                    serviceName: service['service_name'] ?? '',
                    category: service['category'] ?? '',
                    description: service['description'] ?? '',
                    price: service['price']?.toString() ?? '',
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Service Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      color: _getCategoryColor(service['category']).withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          _getCategoryIcon(service['category']),
                          size: 48,
                          color: _getCategoryColor(service['category']),
                        ),
                      ),
                    ),
                  ),
                ),

                // Service Details
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['service_name'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(service['category']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              service['category'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: _getCategoryColor(service['category']),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            '₹${service['price'] ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.teal[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        service['description'] ?? 'No description available',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'computers': return Icons.computer;
      case 'mobiles': return Icons.phone_android;
      case 'tv': return Icons.tv;
      case 'electronics': return Icons.electrical_services;
      case 'home': return Icons.home_repair_service;
      case 'plumbing': return Icons.plumbing;
      default: return Icons.handyman;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'computers': return Colors.blue;
      case 'mobiles': return Colors.purple;
      case 'tv': return Colors.orange;
      case 'electronics': return Colors.green;
      case 'home': return Colors.red;
      case 'plumbing': return Colors.teal;
      default: return Colors.teal;
    }
  }

  Widget _buildShimmerGrid() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 14,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Container(
                                width: 40,
                                height: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 12,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: 6,
        ),
      ),
    );
  }
}