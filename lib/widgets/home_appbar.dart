import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool showProfile;
  final VoidCallback? onSearchTap;
  final Widget? customLeading;

  const HomeAppBar({
    Key? key,
    required this.searchController,
    this.showProfile = true,
    this.onSearchTap,
    this.customLeading,
  }) : super(key: key);

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

      // 3. LOGIC: Cek jika showProfile true, tampilkan icon. Jika false, list kosong.
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
          : [SizedBox(width: 16)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}