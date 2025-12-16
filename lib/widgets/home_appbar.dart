import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool showProfile;
  final VoidCallback? onSearchTap;
  final Widget? customLeading;
  // 1. TAMBAHKAN INI: Callback saat teks berubah
  final ValueChanged<String>? onChanged; 

  const HomeAppBar({
    super.key,
    required this.searchController,
    this.showProfile = true,
    this.onSearchTap,
    this.customLeading,
    this.onChanged, // 2. Masukkan ke constructor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1.0,
      leading: customLeading,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.grey[800]),

      title: TextField(
        controller: searchController,
        onTap: onSearchTap,
        // 3. PASANG DISINI: Biar screen tau kalau ada ketikan baru
        onChanged: onChanged, 
        readOnly: onSearchTap != null,
        decoration: InputDecoration(
          hintText: "Cari makanan...",
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.green),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        style: const TextStyle(fontSize: 16),
      ),

      actions: showProfile
          ? [
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.green, size: 36),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ]
          : [const SizedBox(width: 16)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}