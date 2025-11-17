import 'package:flutter/material.dart';
// Import halaman-halaman yang akan jadi isi tab
import 'activity_page.dart';
import 'home_screen.dart';

// Ini adalah "Otak" yang memegang layout BottomNavBar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // State untuk tahu tab mana yang aktif

  // Daftar halaman/widget yang akan jadi isi dari tiap tab
  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const ActivityPage(),
  ];

  // Fungsi yang dipanggil saat tab di-klik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body-nya otomatis ganti halaman sesuai tab yang aktif
      body: _pages.elementAt(_selectedIndex),
      
      // Ini adalah Bottom Navigation Bar-nya
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
        selectedItemColor: Colors.green, // Warna tab aktif
        unselectedItemColor: Colors.grey,  // Warna tab non-aktif
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}