import 'package:flutter/material.dart';
import 'manage_account_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Kita gunakan Stack untuk menumpuk background hijau dan card profil
      body: Stack(
        children: [
          // 1. BACKGROUND HIJAU DENGAN LENGKUNGAN
          Container(
            height: 200, // Tinggi area hijau
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50), // Warna hijau (sesuaikan jika perlu)
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 100),
                // CARD PROFIL (Kotak Putih dengan Shadow)
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
                        // AVATAR HIJAU (MR)
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A600), // Hijau lebih tua
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'MR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // INFO USER
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Muhammad Rifai',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'muhrifai261@gmail.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  decoration: TextDecoration
                                      .underline, // Garis bawah email
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '085244584052',
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

                // MENU MANAGE ACCOUNT
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
                      // Aksi saat tombol Manage Account diklik
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Sudut sangat bulat
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.grey),
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
            ),
          ),
        ],
      ),
    );
  }
}
