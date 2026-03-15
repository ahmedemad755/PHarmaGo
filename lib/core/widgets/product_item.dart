import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class productItem extends StatelessWidget { // تحول لـ StatelessWidget
  const productItem({super.key, required this.productEntity});
  final AddProductIntety productEntity;

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = productEntity.discountPercentage > 0;

    return RepaintBoundary( // 👈 عزل العنصر عن باقي الشاشة في الرسم
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: productEntity),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: GlassCard(
            width: double.infinity,
            height: 200,
            borderRadius: 16,
            opacity: 0.95,
            gradientColors: const [Color(0xFFF2F6F8), Color(0xFFF2F6F8)],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      hasDiscount 
                        ? const _DiscountTag() 
                        : const SizedBox(width: 42),
                      const FavoriteButton(), // 👈 زر منفصل لا يؤثر على الباقي
                    ],
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Center(
                      child: productEntity.imageurl != null
                          ? CustomNetworkImage(imageUrl: productEntity.imageurl!)
                          : const _PlaceholderImage(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _ProductInfo(name: productEntity.name, price: productEntity.price),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 👈 عزل زر المفضلة لمنع ريبلد المنتج بالكامل
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.black54,
        size: 20,
      ),
      onPressed: () => setState(() => isFavorite = !isFavorite),
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    );
  }
}

class _DiscountTag extends StatelessWidget {
  const _DiscountTag();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 108, 244, 54).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade400),
      ),
      child: Icon(Icons.local_offer, color: Colors.green.shade700, size: 16),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final String name;
  final num price;
  const _ProductInfo({required this.name, required this.price});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text("$price جنيه", style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[300], alignment: Alignment.center, child: const Icon(Icons.image_not_supported));
  }
}