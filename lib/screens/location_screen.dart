// location_screen.dart

import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // Tombol 'Applay' di bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Logika untuk menyimpan dan kembali ke halaman sebelumnya
              Navigator.pop(context); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9C3C), // Warna hijau
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Applay', // Mungkin maksudnya "Apply"
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
      
      // AppBar kustom
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Location',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      
      // Body konten
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Alamat Favorit ---
            const Text(
              'Alamat favorit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'add your alamat',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Tombol Tambah Location
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1E9C3C), width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  // Logika untuk menambahkan alamat baru
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xFF1E9C3C)),
                    SizedBox(width: 8),
                    Text(
                      'Tambah location',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E9C3C)),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // --- Bagian Alamat Terakhir ---
            const Text(
              'Alamat Terakhir',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Item Alamat Terakhir
            _buildLastLocationItem(context, 'Jalan Raya Dadaprejo No.293', true),
            
            // Anda bisa menambahkan item alamat lain di sini jika ada
            // _buildLastLocationItem(context, 'Alamat Kedua, RT 05/RW 01', false),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan satu item alamat
  Widget _buildLastLocationItem(BuildContext context, String address, bool isSelected) {
    return InkWell(
      onTap: () {
        // Logika memilih alamat
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                address,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF1E9C3C) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}