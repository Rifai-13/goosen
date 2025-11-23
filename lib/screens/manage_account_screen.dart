import 'package:flutter/material.dart';
import 'menu_awal_screen.dart'; // Pastikan import ini ada untuk navigasi logout

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
        padding: const EdgeInsets.all(20.0), // Padding agak besar biar lega
        child: Column(
          children: [
            // MENU ITEM: LOG OUT
            InkWell(
              onTap: () {
                // Tampilkan dialog konfirmasi (Opsional, tapi disarankan)
                _showLogoutDialog(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Biar icon sejajar atas
                children: [
                  // Icon Pintu Keluar
                  const Icon(
                    Icons.logout, // Atau Icons.exit_to_app
                    color: Colors.grey, 
                    size: 28
                  ),
                  const SizedBox(width: 16),
                  
                  // Teks Judul & Deskripsi
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
                            height: 1.3, // Jarak antar baris teks
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icon Panah Kanan
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
            // Garis Pemisah
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
              onPressed: () => Navigator.pop(ctx), // Tutup dialog
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup dialog dulu
                
                // LOGIKA LOGOUT:
                // Hapus semua route (history) dan kembali ke MenuAwalScreen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuAwalScreen()),
                  (route) => false, // False artinya hapus semua history sebelumnya
                );
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}