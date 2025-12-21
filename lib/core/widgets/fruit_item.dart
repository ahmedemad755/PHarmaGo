import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FruitItem extends StatefulWidget {
  const FruitItem({super.key, required this.productEntity});
  final AddProductIntety productEntity;

  @override
  State<FruitItem> createState() => _FruitItemState();
}

class _FruitItemState extends State<FruitItem> {
  bool isFavorite = false;

  // دالة وهمية للإضافة إلى السلة. (يمكنك استبدالها لاحقًا بـ Bloc أو Provider)
  void _addToCart() {
    // 💡 يمكن هنا استخدام:
    context.read<CartCubit>().addItemToCart(widget.productEntity);

showOverlayToast(
      context,
      'تمت إضافة ${widget.productEntity.name} إلى السلة! 🛒',
      // يمكنك إرسال لون آخر هنا، الافتراضي هو الأخضر
      color: Colors.green.shade700,
    );
  }

  // Function to handle navigation
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
                // === الصف الأول (الخصم والمفضلة) ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hasDiscount)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "$discount%",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    if (!hasDiscount) 
                       const SizedBox(width: 42),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black54,
                        size: 20,
                      ),
                      onPressed: () {
                        // لإيقاف حدث الـ onTap الخاص بالـ GestureDetector الرئيسي
                        // يجب استخدام MaterialStateProperty أو onTap منفصل، لكن
                        // في IconButton، يتم تمرير onTap الخاص به دون تشغيل onTap للـ GestureDetector
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
                            widget.productEntity.price.toString(),
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

                    // ➕ زر الإضافة إلى السلة
                    GestureDetector(
                      onTap: _addToCart, // ⬅️ استدعاء دالة الإضافة
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700, // لون مميز للزر
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
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
