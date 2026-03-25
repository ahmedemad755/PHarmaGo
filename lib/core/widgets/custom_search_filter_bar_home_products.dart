import 'package:flutter/material.dart';

class CustomSearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onFilterTap;
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;

  const CustomSearchFilterBar({
    super.key,
    required this.controller,
    this.hintText = 'ابحث عن منتج...',
    required this.onFilterTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF007BBB)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const VerticalDivider(indent: 12, endIndent: 12, width: 20),
          GestureDetector(
            onTap: onFilterTap,
            child: const Icon(Icons.filter_list_rounded, color: Color(0xFF007BBB)),
          ),
        ],
      ),
    );
  }
}