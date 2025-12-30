import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LocationScreen extends StatefulWidget {
  // Terima alamat yang sedang aktif sekarang (opsional, biar otomatis terpilih)
  final String? currentAddress;

  const LocationScreen({super.key, this.currentAddress});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Variabel untuk menyimpan alamat yang dipilih user
  String? _selectedAddress;

  // Controller untuk input teks alamat baru
  final TextEditingController _addressController = TextEditingController();

  // Ambil User ID yang sedang login
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Set alamat awal sesuai yang dikirim dari halaman sebelumnya (kalau ada)
    _selectedAddress = widget.currentAddress;
  }

  // --- FUNGSI TAMBAH ALAMAT KE FIREBASE ---
  Future<void> _addNewAddress(String newAddress) async {
    if (newAddress.isEmpty) return;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('addresses')
          .add({
            'address': newAddress,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await FirebaseAnalytics.instance.logEvent(
        name: 'create_new_address',
        parameters: {'address_length': newAddress.length},
      );

      // Reset text field dan tutup dialog
      _addressController.clear();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    }
  }

  // --- FUNGSI MUNCULIN POPUP INPUT ---
  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Alamat Baru"),
          content: TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: "Contoh: Jl. Mawar No. 12",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => _addNewAddress(_addressController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E9C3C),
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- TOMBOL APPLY (Kirim Data Balik) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedAddress == null) {
                // Beri tahu user kalau alamat belum dipilih
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pilih alamat dulu, bro!"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Kirim analytics tanpa await
              FirebaseAnalytics.instance.logEvent(
                name: 'apply_shipping_location',
                parameters: {'has_address': true},
              );

              Navigator.pop(context, _selectedAddress);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Apply Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: user == null
          ? const Center(child: Text("Silakan login terlebih dahulu"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alamat favorit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // --- TOMBOL TAMBAH LOCATION (Memicu Dialog) ---
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF1E9C3C),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: _showAddLocationDialog,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xFF1E9C3C)),
                          SizedBox(width: 8),
                          Text(
                            'Tambah location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E9C3C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Daftar Alamat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // --- STREAM BUILDER (Ambil Data Firebase) ---
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('addresses')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text("Belum ada alamat tersimpan.");
                      }

                      final docs = snapshot.data!.docs;

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final String address = data['address'] ?? '';

                          return _buildLastLocationItem(
                            context,
                            address,
                            // Cek apakah alamat ini sama dengan yang sedang dipilih
                            _selectedAddress == address,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // Widget Item Alamat
  Widget _buildLastLocationItem(
    BuildContext context,
    String address,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAddress = address;
        });
        FirebaseAnalytics.instance.logSelectItem(
          itemListName: 'Saved Addresses',
          items: [
            AnalyticsEventItem(
              itemName: address,
              itemCategory: 'Location Selection',
            ),
          ],
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
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
