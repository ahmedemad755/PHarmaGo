import 'package:flutter/material.dart';

class ProductBottomActionBar extends StatelessWidget {
  const ProductBottomActionBar({
    super.key,
    required this.quantity,
    required this.canAdd,
    required this.selectedOfferName,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  final int quantity;
  final bool canAdd;
  final String? selectedOfferName;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: onDecrement,
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAdd
                      ? const Color(0xFF007BBB)
                      : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      canAdd ? 'إضافة للسلة' : 'غير متوفر',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (selectedOfferName != null && canAdd)
                      Text(
                        'من صيدلية: $selectedOfferName',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
