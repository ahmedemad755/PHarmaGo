import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_item_action_bottons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_text_styles.dart';
// استيراد ملف الـ Routes الخاص بك

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.carItemEntity});

  final CartItemEntity carItemEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // استخدام الميثود الجديدة getCartEntity التي أضفناها للـ Cubit
        final currentCart = context.read<CartCubit>().getCartEntity(state);
        
        final currentItem = currentCart.cartItems.firstWhere(
          (item) =>
              item.productIntety.code == carItemEntity.productIntety.code &&
              item.pharmacyId == carItemEntity.pharmacyId,
          orElse: () => carItemEntity,
        );

        return GestureDetector(
          onTap: () {
            // 🚀 الانتقال لصفحة التفاصيل باستخدام الـ Route المذكور في ملفك
            Navigator.pushNamed(
              context,
              AppRoutes.productDetails,
              arguments: currentItem.productIntety,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // صورة المنتج
                  _buildProductImage(currentItem.productIntety.imageurl!),
                  const SizedBox(width: 16),
                  
                  // بيانات المنتج
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                currentItem.productIntety.name,
                                style: TextStyles.bold13,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildDeleteButton(context, currentItem),
                          ],
                        ),
                        
                        // اسم الصيدلية
                        _buildPharmacyInfo(currentItem.pharmacyName),
                        
                        const SizedBox(height: 8),
                        
                        // الأزرار والسعر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CartItemActionButtons(cartItemEntity: currentItem),
                            Text(
                              '${currentItem.calculateTotalPrice()} ريال',
                              style: TextStyles.bold16.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widgets مساعدة لتحسين القراءة ---

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomNetworkImage(imageUrl: imageUrl),
      ),
    );
  }

  Widget _buildPharmacyInfo(String? pharmacyName) {
    return Row(
      children: [
        const Icon(Icons.storefront, size: 14, color: Color(0xFF007BBB)),
        const SizedBox(width: 4),
        Text(
          pharmacyName ?? 'صيدلية غير محددة',
          style: TextStyles.regular13.copyWith(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, CartItemEntity item) {
    return GestureDetector(
      onTap: () async {
        final confirmed = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent, // لجعل الحواف الدائرية تظهر
          builder: (context) => DeleteConfirmationSheet(
            itemName: item.productIntety.name,
          ),
        );

        if (confirmed == true && context.mounted) {
          context.read<CartCubit>().deleteCarItem(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
      ),
    );
  }
}

class DeleteConfirmationSheet extends StatelessWidget {
  const DeleteConfirmationSheet({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مؤشر السحب
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.delete_sweep_rounded,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'حذف من السلة؟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'هل أنت متأكد أنك تريد إزالة "$itemName" من سلة المشتريات؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'نعم، احذف',
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // مسافة أمان سفلية
        ],
      ),
    );
  }
}