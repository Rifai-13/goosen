// main_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // 1. LIST HALAMAN (ADA 3)
  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),     // Index 0
    const ActivityScreen(), // Index 1
    const ProfileScreen(),  // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pastikan mengakses halaman sesuai index
      body: _pages.elementAt(_selectedIndex),
      
      // Bungkus Container untuk Shadow
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        
        child: BottomNavigationBar(
          // 2. ITEM NAVIGASI (HARUS ADA 3 JUGA BIAR GAK ERROR)
          items: const <BottomNavigationBarItem>[
            // Item 0
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // Item 1
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Activity',
            ),
            // Item 2 (INI YANG KEMARIN MUNGKIN KURANG/HILANG)
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF1E9C3C), // Hijau Goosen
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}