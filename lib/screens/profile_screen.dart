import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_account_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fungsi Helper untuk mengambil Inisial Nama (Misal: Arthur Morgan -> AM)
  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> nameParts = name.trim().split(" ");
    if (nameParts.length > 1) {
      // Ambil huruf pertama kata pertama & kedua
      return "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
    } else {
      // Kalau cuma 1 kata, ambil huruf pertama saja
      return nameParts[0][0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil User yang sedang Login
    final User? user = FirebaseAuth.instance.currentUser;

    // Jika user entah kenapa null (belum login), kembalikan loading/kosong
    if (user == null) {
      return const Scaffold(body: Center(child: Text("User belum login")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- BACKGROUND HIJAU (TETAP) ---
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // --- KONTEN DATA DARI FIREBASE ---
          SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              // 2. Request Data ke Firestore berdasarkan UID User
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              
              builder: (context, snapshot) {
                // KONDISI 1: Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }

                // KONDISI 2: Error atau Data Kosong
                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Gagal memuat profil"));
                }

                // KONDISI 3: Data Berhasil Diambil
                // Kita ambil datanya sebagai Map
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                
                // Ambil field (pakai default value string kosong biar gak error null)
                String name = userData['name'] ?? 'User';
                String email = userData['email'] ?? user.email ?? '-';
                String phone = userData['phoneNumber'] ?? '-';
                String initials = _getInitials(name);

                return Column(
                  children: [
                    const SizedBox(height: 100),
                    
                    // CARD PROFIL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // AVATAR DINAMIS
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00A600),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  initials, // Tampilkan Inisial Nama
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // INFO USER DARI DATABASE
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name, // Nama dari Firestore
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email, // Email dari Firestore
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    phone, // No HP dari Firestore
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // MENU MANAGE ACCOUNT (TETAP)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManageAccountScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.person_outline, color: Colors.grey), // Ganti icon biar lebih relevan
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Manage account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}