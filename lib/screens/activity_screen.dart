import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// ==========================================
// 1. ACTIVITY SCREEN UTAMA
// ==========================================
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,

        // --- CUSTOM APP BAR ---
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Activity',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
            // Tab 1: Menampilkan Data Realtime dari Firebase
            _buildOrderListStream(status: 'pending'),

            // Tab 2 & 3: Placeholder (Bisa diganti logicnya nanti)
            _buildOrderListStream(status: 'completed'),
            _buildOrderListStream(status: 'cancelled'),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. STREAM BUILDER (Logic Pengambil Data)
  // ==========================================
  Widget _buildOrderListStream({required String status}) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Silakan login terlebih dahulu"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // 1. Kondisi Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Kondisi Error
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // 3. Kondisi Data Kosong
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pesanan ($status)',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // 4. Render Data
        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final String docId = docs[index].id;

            // Ambil data Items (Array)
            List<dynamic> items = data['items'] ?? [];

            var firstItem = items.isNotEmpty ? items[0] : {};

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildActivityCard(
                context: context,
                docId: docId,
                title: firstItem['title'] ?? 'Menu Item',
                price: data['totalPrice'] ?? 0,
                itemCount: items.length,
                totalQty: items.fold(
                  0,
                  (sum, item) => sum + (item['quantity'] as int),
                ),
                note: data['orderNote'] ?? '-',
                imageUrl:
                    firstItem['image'] ?? 'https://via.placeholder.com/150',
                status: status,
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // 3. WIDGET ITEM PESANAN (CARD)
  // ==========================================
  Widget _buildActivityCard({
    required BuildContext context,
    required String docId,
    required String title,
    required int price,
    required int itemCount,
    required int totalQty,
    required String note,
    required String imageUrl,
    required String status,
  }) {
    // Helper format duit
    String formatCurrency(int amount) {
      return NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp.',
        decimalDigits: 0,
      ).format(amount);
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Border hijau kalau pending, abu-abu kalau selesai
        border: Border.all(
          color: status == 'pending'
              ? const Color(0xFF1E9C3C)
              : Colors.grey.shade300,
          width: 1.5,
        ),
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
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      Container(width: 60, height: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),

              // Detail Pesanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Jika item lebih dari 1, tambahkan tulisan "& others"
                      itemCount > 1
                          ? "$title & ${itemCount - 1} others"
                          : title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatCurrency(price)} | $totalQty items',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Tampilkan Note jika ada
                    if (note.isNotEmpty)
                      Text(
                        "Note: $note",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tombol Aksi (Hanya muncul jika status Pending)
          if (status == 'pending')
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol Cancel (Fungsi Beneran: Update Status ke Cancelled)
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    onPressed: () {
                      _updateOrderStatus(docId, 'cancelled', price);
                    },
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
                const SizedBox(width: 8),

                // Tombol Complete (Fungsi Beneran: Update Status ke Completed)
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    onPressed: () {
                      _updateOrderStatus(docId, 'completed', price);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E9C3C),
                      side: const BorderSide(color: Color(0xFF1E9C3C)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Complete'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. FUNGSI UPDATE STATUS (CANCEL/COMPLETE)
  // ==========================================
  Future<void> _updateOrderStatus(
    String docId,
    String newStatus,
    int totalPrice,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(docId).update({
        'status': newStatus,
      });

      String eventName = newStatus == 'completed'
          ? 'complete_order'
          : 'cancel_order';

      FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: {
          'order_id': docId,
          'value': totalPrice.toDouble(),
          'currency': 'IDR',
        },
      );
    } catch (e) {
      print("Gagal update status: $e");
    }
  }
}
