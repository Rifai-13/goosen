import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import Model dan Screen lain
import '../models/menu_makanan.dart';
import '../widgets/home_appbar.dart';
import '../screens/restaurant_menu_screen.dart';

class AllFoodScreen extends StatefulWidget {
  const AllFoodScreen({super.key});

  @override
  State<AllFoodScreen> createState() => _AllFoodScreenState();
}

class _AllFoodScreenState extends State<AllFoodScreen> {
  late final TextEditingController _searchController;
  
  // 1. Variabel State untuk Data API
  List<MenuMakanan> allMenu = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchAllMenu(); // Panggil fungsi fetch saat layar dibuka
  }

  // 2. Fungsi Ambil Data dari API
  Future<void> fetchAllMenu() async {
    try {
      final String urlAPI = dotenv.env['API_URL'] ?? '';
      final response = await http.get(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final List<dynamic> dataJSON = json.decode(response.body);
        setState(() {
          // Convert JSON ke List<MenuMakanan>
          allMenu = dataJSON.map((json) => MenuMakanan.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print("Error all food: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(
        searchController: _searchController,
        showProfile: false,
        customLeading: IconButton(
          icon: const Icon(Icons.close, size: 28, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // 3. Handle Loading State
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Menu Available', // Judul diganti dikit biar keren
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Tampilkan Grid Makanan dari Data API
                    allMenu.isEmpty
                        ? const Center(child: Text("Tidak ada menu ditemukan"))
                        : Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: allMenu.map((item) {
                              return _buildFoodItem(
                                context: context,
                                item: item, // Lempar object MenuMakanan
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  // 5. Widget Item Makanan (Updated pake Model MenuMakanan)
  Widget _buildFoodItem({
    required BuildContext context,
    required MenuMakanan item,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Rumus lebar card
    final itemWidth = (screenWidth - 32 - 16) / 2;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RestaurantMenuScreen(),
          ),
        );
      },
      child: Container(
        width: itemWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                item.gambar, // Pake data dari API
                height: itemWidth, // Biar kotak (square)
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(
                  height: itemWidth,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            // Info Teks
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.distance} • ${item.duration}', // Data Jarak & Waktu
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.nama, // Nama Makanan
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item.terjual})', // Data Terjual/Rating Count
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                   // Tambahan Harga biar informatif
                  Text(
                    "Rp ${item.harga}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}