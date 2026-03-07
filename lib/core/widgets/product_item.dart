import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class productItem extends StatefulWidget {
  const productItem({super.key, required this.productEntity});
  final AddProductIntety productEntity;

  @override
  State<productItem> createState() => _productItemState();
}

class _productItemState extends State<productItem> {
  bool isFavorite = false;

  void _addToCart() {
    context.read<CartCubit>().addProduct(widget.productEntity, quantity: 1);
  }

  void _navigateToDetails() {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetails,
      arguments: widget.productEntity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final num discount = widget.productEntity.discountPercentage;
    final bool hasDiscount = discount > 0;
    return GestureDetector(
      onTap: _navigateToDetails,
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
                // === الصف الأول (العلامة والمفضلة) ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hasDiscount)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, // زيادة العرض قليلاً ليناسب الشكل
                          vertical: 6,
                        ),
  decoration: BoxDecoration(
  // تم تغيير لون الخلفية لأخضر خفيف جداً
  color: const Color.fromARGB(255, 108, 244, 54).withOpacity(0.1),
  borderRadius: BorderRadius.circular(8),
  // تم تغيير لون الحدود لأخضر
  border: Border.all(color: Colors.green.shade400),
),
child: Icon(
  Icons.local_offer, // أيقونة تدل على العرض
  // تم تغيير لون الأيقونة لأخضر داكن
  color: Colors.green.shade700,
  size: 16,
),
                      ),
                    if (!hasDiscount) const SizedBox(width: 42),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black54,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // === الصورة ===
                Flexible(
                  child: Center(
                    child: widget.productEntity.imageurl != null
                        ? CustomNetworkImage(
                            imageUrl: widget.productEntity.imageurl!,
                          )
                        : Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Text(
                              '🖼️ Image URL for ${widget.productEntity.name}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                // === الاسم والسعر وزر الإضافة ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // الاسم والسعر
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productEntity.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${widget.productEntity.price} جنيه مصري",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}