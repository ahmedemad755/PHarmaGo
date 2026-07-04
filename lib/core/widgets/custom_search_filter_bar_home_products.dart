import 'package:flutter/material.dart';

class CustomSearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onFilterTap;
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;

  const CustomSearchFilterBar({
    super.key,
    required this.controller,
    this.hintText = 'ابحث عن منتج...',
    required this.onFilterTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      // استخدام Directionality لضمان ثبات الاتجاه العربي من اليمين للشمال
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // 1. أيقونة البحث في البداية (يمين)
            const Icon(Icons.search, color: Color(0xFF007BBB)),
            const SizedBox(width: 8),
            
            // 2. خانة الكتابة
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.right,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  // إزالة أي Padding داخلي إضافي يفسد المحاذاة العمودية
                  contentPadding: EdgeInsets.zero, 
                ),
              ),
            ),
            
            // 3. الفاصل الرأسي
            const VerticalDivider(indent: 12, endIndent: 12, width: 20),
            
            // 4. زر الفلتر مع تأثير الـ Ripple عند الضغط (يسار)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.filter_list_rounded,
                    color: Color(0xFF007BBB),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}