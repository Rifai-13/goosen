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
  final FocusNode _focusNode = FocusNode();

  // Cukup kembalikan teks ke layar sebelumnya
  void _saveNote() {
    Navigator.pop(context, _controller.text);
  }
  
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
          'Add notes to your dish',
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
            Expanded(
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  if (showExamplePlaceholder)
                    GestureDetector(
                      onTap: () {
                        _focusNode.requestFocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 0),
                        child: const Text(
                          'Example: Make my food spicy!',
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
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return Text(
                      '${value.text.length}/$_maxLength',
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
                
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