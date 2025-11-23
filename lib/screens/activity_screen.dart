import 'package:flutter/material.dart';

// ==========================================
// 1. ACTIVITY SCREEN UTAMA
// ==========================================
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan DefaultTabController untuk mengontrol tab navigation
    return DefaultTabController(
      length: 3, // Jumlah tab: Dalam Proses, Riwayat, Cancel
      child: Scaffold(
        // Hapus: bottomNavigationBar di sini
        backgroundColor: Colors.white,

        // --- CUSTOM APP BAR DENGAN TABS ---
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // Hilangkan tombol back default karena diurus oleh MainScreen (index 0)
          automaticallyImplyLeading: false, 
          title: const Text(
            'Activity',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const TabBar(
                isScrollable: true, 
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Dalam Proses'),
                  Tab(text: 'Riwayat'),
                  Tab(text: 'Cancel'),
                ],
              ),
            ),
          ),
        ),

        // --- BODY: KONTEN TAB ---
        body: TabBarView(
          children: [
            // Konten Tab 1: Dalam Proses (Menampilkan Card Pesanan)
            _buildDalamProsesTab(),
            // Konten Tab 2: Riwayat (Placeholder)
            _buildPlaceholderTab('Riwayat Pesanan'),
            // Konten Tab 3: Cancel (Placeholder)
            _buildPlaceholderTab('Pesanan Dibatalkan'),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. WIDGET TAB CONTENT
  // ==========================================

  Widget _buildDalamProsesTab() {
    // SingleChildScrollView penting agar daftar pesanan bisa di-scroll
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActivityCard(
            title: 'Chicken Katsu Single',
            price: '23.000',
            itemCount: 1,
            note: 'extra saus',
            // Gunakan gambar yang sesuai dari konteks Anda
            imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500&q=80',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        'Belum ada $title',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // ==========================================
  // 3. WIDGET ITEM PESANAN (CARD)
  // ==========================================

  Widget _buildActivityCard({
    required String title,
    required String price,
    required int itemCount,
    required String note,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Border hijau menunjukkan pesanan sedang dalam proses
        border: Border.all(color: const Color(0xFF1E9C3C), width: 1.5), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Item
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              
              // Detail Pesanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp.$price | $itemCount item',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note,
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tombol Completed (Outline Button dengan border hijau)
              SizedBox(
                height: 35,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E9C3C),
                    side: const BorderSide(color: Color(0xFF1E9C3C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Complitied'),
                ),
              ),
              const SizedBox(width: 8),
              // Tombol Cancel (Outline Button dengan border merah)
              SizedBox(
                height: 35,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}