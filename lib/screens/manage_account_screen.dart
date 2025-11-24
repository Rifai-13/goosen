import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. WAJIB IMPORT INI
import 'menu_awal_screen.dart'; 

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage account',
          style: TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
      ),

      // --- BODY ---
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // MENU ITEM: LOG OUT
            InkWell(
              onTap: () {
                _showLogoutDialog(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.logout, 
                    color: Colors.grey, 
                    size: 28
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Log out',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Are you sure? You'll have to log in again once you're back.",
                          style: TextStyle(
                            fontSize: 12, 
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios, 
                    size: 16, 
                    color: Colors.grey
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  // Fungsi Helper: Menampilkan Dialog Konfirmasi & Proses Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Apakah kamu yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), // Tutup dialog (Batal)
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              // 2. JADIKAN ASYNC DI SINI
              onPressed: () async {
                Navigator.pop(ctx); // Tutup dialog dulu
                
                // 3. PROSES LOGOUT DARI FIREBASE (PENTING!)
                await FirebaseAuth.instance.signOut();
                
                // Cek mounted agar tidak error jika widget sudah di-dispose
                if (context.mounted) {
                  // 4. Hapus history dan kembali ke Menu Awal
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuAwalScreen()),
                    (route) => false, 
                  );
                }
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}