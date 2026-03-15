import 'package:cached_network_image/cached_network_image.dart'; // 👈 لازم تحمل المكتبة دي
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      // 👈 تحديد حجم الصورة في الذاكرة (بيوفر رامات جداً)
      memCacheHeight: 250, 
      memCacheWidth: 250,
      fit: BoxFit.contain,
      placeholder: (context, url) => Container(color: Colors.white, width: 100, height: 100),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}