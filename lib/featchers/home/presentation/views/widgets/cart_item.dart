import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_item_action_bottons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_text_styles.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.carItemEntity});

  final CartItemEntity carItemEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final currentCart = switch (state) {
          CartInitial(cartEntity: final cart) => cart,
          CartUpdated(cartEntity: final cart) => cart,
          CartItemAdded(cartEntity: final cart) => cart,
          CartItemRemoved(cartEntity: final cart) => cart,
        };

        // تحسين البحث ليشمل كود المنتج ومعرف الصيدلية معاً
        final currentItem = currentCart.cartItems.firstWhere(
          (item) =>
              item.productIntety.code == carItemEntity.productIntety.code &&
              item.pharmacyId == carItemEntity.pharmacyId,
          orElse: () => carItemEntity,
        );

        return IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 73,
                height: 92,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomNetworkImage(
                  imageUrl: currentItem.productIntety.imageurl!,
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            currentItem.productIntety.name,
                            style: TextStyles.bold13,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // 💡 التغيير هنا: استخدام Bottom Sheet بدلاً من Dialog
                            final confirmed = await showModalBottomSheet<bool>(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // مؤشر السحب الصغير في الأعلى للتجميل
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Icon(
                                      Icons.delete_sweep_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'حذف من السلة؟',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'هل أنت متأكد أنك تريد إزالة هذا المنتج؟ يمكنك إضافته مرة أخرى لاحقاً.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              side: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text(
                                              'إلغاء',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text(
                                              'نعم، احذف',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ), // مساحة أمان للآيفون
                                  ],
                                ),
                              ),
                            );

                            if (confirmed == true) {
                              context.read<CartCubit>().deleteCarItem(
                                currentItem,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(
                                0.1,
                              ), // خلفية خفيفة جداً للأيقونة
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 💡 التعديل الجديد: إظهار اسم الصيدلية
                    Row(
                      children: [
                        const Icon(
                          Icons.storefront,
                          size: 14,
                          color: Color(0xFF007BBB),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            currentItem.pharmacyName ?? 'صيدلية غير محددة',
                            style: TextStyles.regular13.copyWith(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        CartItemActionButtons(cartItemEntity: currentItem),
                        const Spacer(),
                        Text(
                          '${currentItem.calculateTotalPrice()} ريال',
                          style: TextStyles.bold16.copyWith(
                            color: AppColors
                                .primaryColor, // أو اللون الذي تفضله للسعر
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
