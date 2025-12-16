import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/menu_makanan.dart';
import '../widgets/my_food_card.dart';
import '../widgets/home_appbar.dart';
import '../screens/all_food_screen.dart';
import '../screens/restaurant_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  // 1. Variabel Data Utama
  List<MenuMakanan> listTopRated = [];
  bool isLoading = true;

  // 2. Variabel Tambahan untuk Search
  List<MenuMakanan> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchTopRatedFoods();
  }

  Future<void> fetchTopRatedFoods() async {
    try {
      final String urlAPI = dotenv.env['API_URL'] ?? '';
      final response = await http.get(Uri.parse(urlAPI));

      if (response.statusCode == 200) {
        final List<dynamic> dataJSON = json.decode(response.body);
        setState(() {
          listTopRated = dataJSON
              .map((json) => MenuMakanan.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print("Error ambil data home: $e");
      setState(() => isLoading = false);
    }
  }

  // 3. FUNGSI LOGIC PENCARIAN
  void _runSearch(String keyword) {
    if (keyword.isEmpty) {
      // Kalau kosong, matikan mode searching
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      // Kalau ada teks, nyalakan mode searching & filter data
      setState(() {
        _isSearching = true;
        _searchResults = listTopRated
            .where(
              (item) => item.nama.toLowerCase().contains(keyword.toLowerCase()),
            )
            .toList();
      });
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
        showProfile: true,
        // 4. SAMBUNGKAN FUNGSI SEARCH DISINI
        onChanged: (value) => _runSearch(value),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // 5. LOGIC TAMPILAN (SWITCHING)
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isSearching
            ? _buildSearchResults()
            : _buildNormalContent()
      ),
    );
  }

  // WIDGET 1: Tampilan Normal (Banner + Top Rated)
  Widget _buildNormalContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Deals to see when you\'re hungry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/banner.png',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 180, color: Colors.grey[300]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Rated',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllFoodScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 255,
            child: listTopRated.isEmpty
                ? const Center(child: Text("Belum ada menu hits nih"))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: listTopRated.length > 5
                        ? 5
                        : listTopRated.length,
                    itemBuilder: (context, index) {
                      final food = listTopRated[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        // 1. BUNGKUS DENGAN GESTURE DETECTOR
                        child: GestureDetector(
                          onTap: () {
                            // 2. NAVIGASI KE RESTAURANT MENU
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantMenuScreen(
                                  selectedMenu:
                                      food,
                                ),
                              ),
                            );
                          },
                          // 3. Child-nya tetap Card Makanan kamu
                          child: MyFoodCard(
                            imageUrl: food.gambar,
                            title: food.nama,
                            rating: food.rating,
                            distance: food.distance,
                            duration: food.duration,
                            ratingCount: food.terjual,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // WIDGET 2: Tampilan Hasil Pencarian (List ke Bawah)
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              "Yah, '${_searchController.text}' nggak ketemu bro.",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final food = _searchResults[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantMenuScreen(selectedMenu: food),
              ),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              food.gambar,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(width: 60, height: 60, color: Colors.grey[300]),
            ),
          ),
          title: Text(
            food.nama,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rp ${food.harga}",
                style: const TextStyle(color: Colors.green),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(" ${food.rating} • ${food.distance}"),
                ],
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
