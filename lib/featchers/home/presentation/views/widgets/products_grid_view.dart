import 'package:e_commerce/core/enteties/product_enteti.dart'; // Assuming this exists
import 'package:e_commerce/core/widgets/product_item.dart';
import 'package:flutter/material.dart';
class ProductsGridView extends StatelessWidget {
  const ProductsGridView({super.key, required this.products, this.limit});
  final List<AddProductIntety> products;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final int displayCount = limit != null 
        ? (limit! > products.length ? products.length : limit!) 
        : products.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          // 👈 أهم خاصية للسكرول الناعم: يجهز العناصر قبل ظهورها بـ 500 بكسل
          cacheExtent: 500, 
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: displayCount,
          itemBuilder: (context, index) => productItem(
            key: ValueKey(products[index].code), // استخدم الـ code أفضل من الاسم
            productEntity: products[index],
          ),
        );
      },
    );
  }
}