import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteDeliveryScreen extends StatefulWidget {
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
  
  // Ambil user saat ini
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
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

  // --- FUNGSI SIMPAN KE FIREBASE & KEMBALI ---
  Future<void> _saveNote() async {
    final String noteText = _controller.text;

    // 1. Simpan ke Firebase (Opsional: Simpan sebagai preferensi user)
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'last_delivery_note': noteText, // Field untuk menyimpan catatan terakhir
        }, SetOptions(merge: true)); // Merge agar data lain tidak hilang
      } catch (e) {
        debugPrint("Gagal simpan note ke Firebase: $e");
      }
    }

    // 2. Kembali ke CheckoutScreen membawa data teks
    if (mounted) {
      Navigator.pop(context, noteText);
    }
  }

  void _clearNote() {
    setState(() {
      _controller.clear();
      Navigator.pop(context, '');
    });
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
          'Delivery notes',
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
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  if (showExamplePlaceholder)
                    GestureDetector(
                      onTap: () => _focusNode.requestFocus(),
                      child: Container(
                        padding: const EdgeInsets.only(top: 0),
                        child: const Text(
                          'Example: keep on the fence, dont ring the bell',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    maxLength: _maxLength,
                    expands: true,
                    onChanged: (text) => setState(() {}),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_controller.text.length}/$_maxLength',
                  style: const TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: isSaveActive ? _saveNote : null, // Panggil _saveNote
                  style: TextButton.styleFrom(
                    backgroundColor: isSaveActive ? const Color(0xFF1E9C3C) : Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: isSaveActive ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
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