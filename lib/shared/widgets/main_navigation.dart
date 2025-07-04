import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    NavigationItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag,
      label: 'Market',
      route: '/market',
    ),
    NavigationItem(
      icon: Icons.qr_code_scanner_outlined,
      activeIcon: Icons.qr_code_scanner,
      label: 'Scan',
      route: '/upcycle',
    ),
    NavigationItem(
      icon: Icons.eco_outlined,
      activeIcon: Icons.eco,
      label: 'Greenity',
      route: '/social',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
  ];

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      context.go(_navigationItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF4CAF50), // Green color matching your app
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: _navigationItems.map((item) {
            final isSelected = _navigationItems[_currentIndex] == item;
            return BottomNavigationBarItem(
              icon: Icon(isSelected ? item.activeIcon : item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
