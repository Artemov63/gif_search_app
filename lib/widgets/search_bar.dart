import 'package:flutter/material.dart';

class GifSearchBar extends StatelessWidget {
  const GifSearchBar({
    super.key,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.controller,
  });

  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: focusNode.hasFocus ? 1 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F2230),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search GIFs...',
            hintStyle: TextStyle(color: Colors.white60),
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }
}
