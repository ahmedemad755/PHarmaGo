import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatelessWidget {
  const ProductDescriptionSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوصف',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }
}
