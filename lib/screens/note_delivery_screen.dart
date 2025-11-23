// note_delivery_screen.dart

import 'package:flutter/material.dart';

class NoteDeliveryScreen extends StatefulWidget {
  // Menerima catatan pengiriman yang sudah ada
  final String initialNote;

  const NoteDeliveryScreen({
    super.key,
    this.initialNote = '',
  });

  @override
  State<NoteDeliveryScreen> createState() => _NoteDeliveryScreenState();
}

class _NoteDeliveryScreenState extends State<NoteDeliveryScreen> {
  late TextEditingController _controller;
  final int _maxLength = 200;
  final FocusNode _focusNode = FocusNode(); 

  // Fungsi untuk menyimpan catatan dan kembali
  void _saveNote() {
    // Mengembalikan teks yang diketik ke halaman sebelumnya
    Navigator.pop(context, _controller.text);
  }
  
  // Fungsi untuk membersihkan catatan
  void _clearNote() {
    setState(() {
      _controller.clear();
      Navigator.pop(context, ''); // Mengembalikan string kosong
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
    
    // Tambahkan listener untuk memaksa rebuild saat fokus/teks berubah
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
    final bool isSaveActive = _controller.text.isNotEmpty;
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
          'Delivery notes', // <--- JUDUL BERBEDA
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
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
              child: Stack( 
                alignment: Alignment.topLeft,
                children: [
                  
                  // A. Placeholder Contoh (Hanya muncul jika kondisi terpenuhi)
                  if (showExamplePlaceholder)
                    GestureDetector(
                      onTap: () {
                        _focusNode.requestFocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 0),
                        child: const Text(
                          'Example: keep on the fence', // <--- CONTOH BERBEDA
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
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterText: '',
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
                  onPressed: isSaveActive ? _saveNote : null, 
                  style: TextButton.styleFrom(
                    backgroundColor: isSaveActive ? const Color(0xFF1E9C3C) : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
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