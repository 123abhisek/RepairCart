import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:service_stack/screens/user/AllServicesScreen.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final List<String> promoImages = [
    'assets/promo1.jpeg',
    'assets/promo2.jpeg',
    'assets/promo3.jpeg',
    'assets/promo4.jpeg'
  ];

  final List<Map<String, dynamic>> serviceCategories = [
    {'icon': Icons.computer, 'title': 'Computers', 'color': Colors.blue},
    {'icon': Icons.phone_android, 'title': 'Mobiles', 'color': Colors.purple},
    {'icon': Icons.tv, 'title': 'TV & Appliances', 'color': Colors.orange},
    {'icon': Icons.electrical_services, 'title': 'Electronics', 'color': Colors.green},
    {'icon': Icons.home_repair_service, 'title': 'Home Services', 'color': Colors.red},
    {'icon': Icons.plumbing, 'title': 'Plumbing', 'color': Colors.teal},
  ];

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isLoading = true; // Simulate loading state

  @override
  void initState() {
    super.initState();

    // Simulate data loading
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _isLoading = false);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
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
      begin: Colors.deepPurple[300],
      end: Colors.deepPurple[700],
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                backgroundColor: _colorAnimation.value,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Dashboard',
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
                          Colors.deepPurple[900]!,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Center(
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_repair_service,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'All Services at Your Doorstep',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main content
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 16),

                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for services...',
                            prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Promotions Carousel
                  if (!_isLoading)
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 180,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.85,
                              autoPlayInterval: Duration(seconds: 5),
                            ),
                            items: promoImages.map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 30),

                  // Service Categories Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service Categories",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[800],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See All",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Service Categories Grid
                  if (_isLoading)
                    _buildShimmerGrid()
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: serviceCategories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryCard(serviceCategories[index], index);
                      },
                    ),

                  SizedBox(height: 30),
                ]),
              ),
            ],
          );
        },
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.support_agent, color: Colors.white),
        elevation: 4,
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    // Staggered animation delay
    // Fixed staggered animation with clamped values
    final delay = (index * 0.15).clamp(0.0, 0.7); // Max delay = 0.7 (0.7 + 0.3 = 1.0)
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
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // Navigate to category details
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllServicesScreen(),));
            },
            highlightColor: category['color'].withOpacity(0.1),
            splashColor: category['color'].withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'],
                      size: 30,
                      color: category['color'],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    category['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}