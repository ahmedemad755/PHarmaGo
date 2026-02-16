import 'package:e_commerce/core/enteties/cart_item_entety.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemActionButtons extends StatelessWidget {
  const CartItemActionButtons({super.key, required this.cartItemEntity});

  final CartItemEntity cartItemEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // زر الزيادة (+)
        _ActionButton(
          icon: Icons.add,
          iconColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            context.read<CartCubit>().updateQuantity(
                  cartItemEntity.productIntety,
                  cartItemEntity.quantty + 1,
                  pharmacyId: cartItemEntity.pharmacyId,
                );
          },
        ),
        
        // عرض الكمية
Container(
          constraints: const BoxConstraints(minWidth: 40),
        
          child: Text(
            cartItemEntity.quantty.toString(),
            textAlign: TextAlign.center, // ✅ المكان الصحيح هنا جوه الـ Text
            style: TextStyles.bold16.copyWith(fontSize: 14),
          ),
        ),

        // زر النقصان (-)
// زر النقصان (-)
        _ActionButton(
          icon: cartItemEntity.quantty > 1 ? Icons.remove : Icons.delete_outline,
          iconColor: cartItemEntity.quantty > 1 ? Colors.grey[700]! : Colors.red,
          backgroundColor: const Color(0xFFF3F5F7),
          onPressed: () async { // أضفنا async هنا
            if (cartItemEntity.quantty > 1) {
              context.read<CartCubit>().updateQuantity(
                    cartItemEntity.productIntety,
                    cartItemEntity.quantty - 1,
                    pharmacyId: cartItemEntity.pharmacyId,
                  );
            } else {
              // 🚀 الطريقة الصحيحة لإظهار الشيت وانتظار النتيجة
              final bool? confirmDelete = await showModalBottomSheet<bool>(
                context: context,
                backgroundColor: Colors.transparent, // لجعل تصميمك الدائري يظهر
                builder: (context) => DeleteConfirmationSheet( // تأكد من وجود الـ _ قبل الاسم لو كانت داخل نفس الملف
                  itemName: cartItemEntity.productIntety.name,
                ),
              );

              // إذا ضغط المستخدم على "نعم، احذف" (التي تعيد true)
              if (confirmDelete == true && context.mounted) {
                context.read<CartCubit>().deleteCarItem(cartItemEntity);
              }
            }
          },
        ),
      ],
    );
  }
}

// ويدجيت الزر المنفصلة بتصميم أنيق
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    required this.iconColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32, // تكبير الحجم قليلاً لسهولة الضغط
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            if (backgroundColor != const Color(0xFFF3F5F7))
              BoxShadow(
                color: backgroundColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}