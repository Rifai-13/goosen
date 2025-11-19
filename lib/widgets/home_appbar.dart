import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  // 1. Terima controller dari luar
  final TextEditingController searchController;
  
  const HomeAppBar({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1.0, 
      
      // 2. GANTI 'GestureDetector' DENGAN 'TextField'
      title: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Cari makanan atau resto...",
          border: InputBorder.none, 
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.green), 
          ),
          // Ikon di depan
          prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
          // Background
          filled: true,
          fillColor: Colors.grey[100],
          // Atur padding internal biar rapi
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        style: TextStyle(fontSize: 16),
      ),
      
      // 3. ACTIONS (Ikon profile) tetap sama
      actions: [
        IconButton(
          icon: Icon(Icons.person_outline, color: Colors.green, size: 36),
          onPressed: () {
            print("Profile diklik!");
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}