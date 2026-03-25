// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ----------------- Reusable TextField Widget -----------------
class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final String? errorText;
  final TextInputType keyboardType;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final VoidCallback? toggleObscure;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.errorText,
    this.onSaved,
    this.onChanged,
    this.toggleObscure,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    TextInputType? keyboardType,
    TextInputType? textInputType,
  }) : keyboardType = textInputType ?? keyboardType ?? TextInputType.text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
          // إضافة الـ formatters للتحكم في المدخلات (مثل منع الأرقام في الاسم)
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lightGray,
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.darkGray, fontSize: 13),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.primary, size: 22)
                : null,
            suffixIcon: suffixIcon ??
                (toggleObscure != null
                    ? GestureDetector(
                        onTap: toggleObscure,
                        child: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.darkGray,
                          size: 22,
                        ),
                      )
                    : null),
            // الحدود الافتراضية
            border: _buildOutlineInputBorder(AppColors.mediumGray),
            // الحدود عند التفعيل
            enabledBorder: _buildOutlineInputBorder(
              errorText != null ? AppColors.error : AppColors.mediumGray,
              width: errorText != null ? 2 : 1,
            ),
            // الحدود عند الضغط (Focus)
            focusedBorder: _buildOutlineInputBorder(
              AppColors.primary,
              width: 2,
            ),
            // الحدود في حالة الخطأ
            errorBorder: _buildOutlineInputBorder(AppColors.error, width: 1),
            focusedErrorBorder: _buildOutlineInputBorder(AppColors.error, width: 2),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Text(
              errorText!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          )
        else
          const SizedBox(height: 16), // مسافة ثابتة بين الحقول
      ],
    );
  }

  // دالة مساعدة لتقليل تكرار الكود في الحدود
  OutlineInputBorder _buildOutlineInputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}