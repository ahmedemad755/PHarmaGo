import 'package:e_commerce/core/enteties/product_enteti.dart'; // Assuming this exists
import 'package:e_commerce/core/widgets/fruit_item.dart';
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
        final isLargeScreen = constraints.maxWidth > 700;
        final crossAxisCount = isLargeScreen ? 4 : 2;


        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: displayCount,
          itemBuilder: (context, index) => FruitItem(
            // إضافة ValueKey لضمان عدم تكرار العناصر في الذاكرة
            key: ValueKey(products[index].name + index.toString()), 
            productEntity: products[index],
          ),
        );
      },
    );
  }
}
