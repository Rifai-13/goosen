import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/menu_makanan.dart';
import '../widgets/home_appbar.dart';
import '../screens/restaurant_menu_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AllFoodScreen extends StatefulWidget {
  const AllFoodScreen({super.key});

  @override
  State<AllFoodScreen> createState() => _AllFoodScreenState();
}

class _AllFoodScreenState extends State<AllFoodScreen> {
  late final TextEditingController _searchController;

  // 1. KITA BUTUH 2 LIST
  List<MenuMakanan> _allMenu = [];
  List<MenuMakanan> _filteredMenu = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchAllMenu();
  }

  Future<void> fetchAllMenu() async {
    try {
      final String urlAPI = dotenv.env['API_URL'] ?? '';
      final response = await http.get(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final List<dynamic> dataJSON = json.decode(response.body);

        // Convert ke List Model
        final resultList = dataJSON
            .map((json) => MenuMakanan.fromJson(json))
            .toList();

        setState(() {
          _allMenu = resultList;
          _filteredMenu = resultList;
          isLoading = false;
        });
        await FirebaseAnalytics.instance.logViewItemList(
          itemListId: "all_menu_list",
          itemListName: "All Food Screen",
        );
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print("Error all food: $e");
      setState(() => isLoading = false);
    }
  }

  // 2. FUNGSI PENCARIAN
  void _runFilter(String keyword) {
    List<MenuMakanan> results = [];
    if (keyword.isEmpty) {
      results = _allMenu;
    } else {
      results = _allMenu
          .where(
            (item) => item.nama.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
      FirebaseAnalytics.instance.logSearch(searchTerm: keyword);
    }

    // Update UI
    setState(() {
      _filteredMenu = results;
    });
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

        // 3. SAMBUNGKAN FUNGSI SEARCH DISINI
        onChanged: (value) => _runFilter(value),

        customLeading: IconButton(
          icon: const Icon(Icons.close, size: 28, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan jumlah hasil pencarian
                    Text(
                      _searchController.text.isNotEmpty
                          ? 'Found ${_filteredMenu.length} results'
                          : 'All Menu Available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. GUNAKAN _filteredMenu UNTUK DITAMPILKAN
                    _filteredMenu.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 50),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Yah, makanannya nggak ketemu bro :(",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: _filteredMenu.map((item) {
                              return _buildFoodItem(
                                context: context,
                                item: item,
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFoodItem({
    required BuildContext context,
    required MenuMakanan item,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 32 - 16) / 2;

    return GestureDetector(
      onTap: () async {
        await FirebaseAnalytics.instance.logSelectItem(
        itemListName: "All Food Screen Search Results",
        items: [
          AnalyticsEventItem(
            itemId: item.id.toString(), // Pastikan model MenuMakanan punya ID
            itemName: item.nama,
            itemCategory: "Food",
            price: double.tryParse(item.harga.toString()),
          ),
        ],
      );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantMenuScreen(selectedMenu: item),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                item.gambar,
                height: itemWidth,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(
                  height: itemWidth,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.distance} • ${item.duration}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item.terjual})',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Rp ${item.harga}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
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
