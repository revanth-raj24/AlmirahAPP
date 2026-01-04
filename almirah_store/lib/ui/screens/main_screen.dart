import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'bag_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. State: Track which tab is active
  int _currentIndex = 0;

  // 2. The List of "Pages" the shell can show
  final List<Widget> _pages = [
    const HomeScreen(),        // Index 0
    const CategoriesScreen(),  // Index 1
    const BagScreen(),         // Index 2
    const ProfileScreen(),     // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. The Body switches based on the index
      body: _pages[_currentIndex],

      // 4. The Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // We use Material 3 "NavigationDestination" for that modern pill look
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

