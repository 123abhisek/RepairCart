

import 'package:flutter/material.dart';
import 'package:service_stack/API/API_service.dart';
import 'package:service_stack/screens/Admin/AdminDashboard.dart';
import 'package:service_stack/screens/Admin/AdminAllServicesScreen.dart';
import '../user/DashboardScreen.dart';
import 'ManageOrdersScreen.dart';
import 'OwnerProfileView.dart';


class AdminMainScreen extends StatefulWidget {
  @override
  State<AdminMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;
  late Future<List<dynamic>> _services;
  AdminAllServicesScreen servicesScreen = AdminAllServicesScreen();
  final _navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // The actual pages for each tab, wrapped in Navigators
  List<Widget> get _tabs => [
    _buildOffstageTab(0, AdminDashboard()),
    _buildOffstageTab(1, ManageOrdersScreen()),
    _buildOffstageTab(2, AdminAllServicesScreen()),
    _buildOffstageTab(3, OwnerProfileView()),
  ];

  Widget _buildOffstageTab(int idx, Widget screen) {
    return Offstage(
      offstage: _currentIndex != idx,
      child: Navigator(
        key: _navKeys[idx],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => screen,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final NavigatorState currentNavigator = _navKeys[_currentIndex].currentState!;
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _services = API_service().fetchAllServices();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(children: _tabs),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {

            if(_currentIndex == 2){
              _services = API_service().fetchAllServices();
            }

            if (_currentIndex == i) {
              // Pop to root if re-tapping the current tab
              _navKeys[i].currentState!
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() => _currentIndex = i);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
