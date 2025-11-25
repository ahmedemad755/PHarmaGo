import 'package:e_commerce/featchers/home/presentation/views/widgets/products_grid_view_bloc_builder.dart';
import 'package:flutter/material.dart';

class BestSelilingFruitesBody extends StatelessWidget {
  const BestSelilingFruitesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver app bar or header if needed
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      children: [
        // Back Button
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Best Selling Fruits',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),


          // BlocBuilder that returns Slivers
          const ProductsGridViewBlocBuilder(),
        ],
      ),
    );
  }
}
