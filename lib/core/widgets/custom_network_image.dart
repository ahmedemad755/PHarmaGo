import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/utils/app_colors.dart'; // استيراد الألوان الخاصة بمشروعك

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const CustomNetworkImage({
    super.key, 
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // حماية إضافية لو الرابط جاي من الـ Database بـ null أو فاضي عشان الأبليكيشن ما يكرشش
    if (imageUrl.trim().isEmpty) {
      return _buildErrorPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl.trim(),
      width: width,
      height: height,
      // تحديد حجم الصورة في الذاكرة (بيوفر رامات جداً ويمنع كراشات الـ Memory)
      memCacheHeight: 250,
      memCacheWidth: 250,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width ?? 100,
        height: height ?? 100,
        color: const Color(0xFFF6FAFC), // لون خلفية الشات والأبليكيشن الهادي
        alignment: Alignment.center,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
          ),
        ),
      ),
      errorWidget: (context, url, error) => _buildErrorPlaceholder(),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.darkBlue.withOpacity(0.5),
        size: (width != null && width! < 50) ? 20 : 28,
      ),
    );
  }
}