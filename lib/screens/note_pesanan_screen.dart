// note_pesanan_screen.dart

import 'package:flutter/material.dart';

class NotePesananScreen extends StatefulWidget {
  final String initialNote;

  const NotePesananScreen({
    super.key,
    this.initialNote = '',
  });

  @override
  State<NotePesananScreen> createState() => _NotePesananScreenState();
}

class _NotePesananScreenState extends State<NotePesananScreen> {
  late TextEditingController _controller;
  final int _maxLength = 200;
  final FocusNode _focusNode = FocusNode(); // Untuk melacak fokus input

  // Fungsi untuk menyimpan catatan dan kembali
  void _saveNote() {
    Navigator.pop(context, _controller.text);
  }
  
  // Fungsi untuk membersihkan catatan
  void _clearNote() {
    setState(() {
      _controller.clear();
      Navigator.pop(context, '');
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
    
    // Tambahkan listener untuk memaksa rebuild saat fokus berubah
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan apakah tombol Save harus aktif (hijau)
    final bool isSaveActive = _controller.text.isNotEmpty;
    // Tentukan apakah placeholder contoh harus ditampilkan
    final bool showExamplePlaceholder = _controller.text.isEmpty && !_focusNode.hasFocus;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add notes to your dish',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          // Tombol Clear hanya muncul jika sudah ada teks
          if (widget.initialNote.isNotEmpty || _controller.text.isNotEmpty)
            TextButton(
              onPressed: _clearNote,
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- 1. KONTEN UTAMA (TextField dan Placeholder Contoh) ---
            Expanded(
              child: Stack( // Gunakan Stack untuk menempatkan placeholder di belakang TextField
                alignment: Alignment.topLeft,
                children: [
                  
                  // A. Placeholder Contoh (Hanya muncul jika kondisi terpenuhi)
                  if (showExamplePlaceholder)
                    // Container yang memberikan efek "Shadow" seperti di gambar
                    GestureDetector(
                      onTap: () {
                        // Jika diklik, fokuskan ke TextField agar keyboard muncul
                        _focusNode.requestFocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 0), // Sesuaikan dengan padding TextField
                        child: const Text(
                          'Example: Make my food spicy!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),

                  // B. TextField Catatan
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    maxLength: _maxLength,
                    expands: true,
                    // Tambahkan listener untuk mengubah warna tombol secara real-time
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterText: '',
                      // Gunakan hintText kosong karena kita menggunakan placeholder custom
                      hintText: showExamplePlaceholder ? '' : null, 
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            
            // --- 2. Bagian Bawah: Counter dan Tombol Save ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Counter Karakter
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return Text(
                      '${value.text.length}/$_maxLength',
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
                
                // Tombol Save
                TextButton(
                  onPressed: isSaveActive ? _saveNote : null, // Tombol tidak bisa diklik jika teks kosong
                  style: TextButton.styleFrom(
                    // WARNA TOMBOL BERUBAH BERDASARKAN isSaveActive
                    backgroundColor: isSaveActive ? const Color(0xFF1E9C3C) : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      // WARNA TEKS BERUBAH
                      color: isSaveActive ? Colors.white : Colors.black54, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}