import 'package:flutter/material.dart';
import 'package:service_stack/screens/user/LoginPage.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(height: 12),
                  Text('John Doe', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('johndoe@example.com',
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(icon: Icons.shopping_bag, label: 'Orders', value: 12),
                _StatCard(icon: Icons.favorite, label: 'Favorites', value: 24),
                _StatCard(icon: Icons.settings, label: 'Settings', value: null),
              ],
            ),

            const SizedBox(height: 36),

            Divider(),

            // Menu Options
            _MenuItem(icon: Icons.shopping_cart, text: 'My Orders', onTap: () {}),
            _MenuItem(icon: Icons.settings, text: 'Settings', onTap: () {}),
            _MenuItem(icon: Icons.credit_card, text: 'Payment Methods', onTap: () {}),
            _MenuItem(icon: Icons.headset_mic, text: 'Help & Support', onTap: () {}),
            _MenuItem(icon: Icons.logout, text: 'Logout', onTap: () {
              // TODO: Clear session before navigating
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Reusable Stat Card
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? value;

  const _StatCard({ required this.icon, required this.label, this.value });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(value?.toString() ?? '-', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// Reusable Menu Item
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _MenuItem({ required this.icon, required this.text, required this.onTap });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
