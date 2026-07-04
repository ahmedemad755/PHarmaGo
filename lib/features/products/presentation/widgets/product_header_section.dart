import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:flutter/material.dart';

class ProductHeaderSection extends StatelessWidget {
  const ProductHeaderSection({
    super.key,
    required this.product,
    required this.hasDiscount,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
  });

  final AddProductIntety product;
  final bool hasDiscount;
  final double price;
  final double discountedPrice;
  final int discountPercentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (hasDiscount)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "خصم $discountPercentage%",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          product.category,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              "${discountedPrice.toStringAsFixed(2)} جنيه ",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BBB),
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                "${price.toStringAsFixed(2)} جنيه ",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
