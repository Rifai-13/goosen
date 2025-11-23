// main_screen.dart

import 'package:flutter/material.dart';
import 'activity_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex; // Tambahkan parameter ini

  const MainScreen({super.key, this.initialIndex = 0}); // Default ke 0 (Home)

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex; // Ubah jadi late agar bisa diinisialisasi di initState

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Gunakan index dari constructor
  }

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const ActivityScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Activity',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}