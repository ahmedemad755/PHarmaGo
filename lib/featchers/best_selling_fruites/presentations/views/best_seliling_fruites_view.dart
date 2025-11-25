import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BestSellingFruitesView extends StatelessWidget {
  const BestSellingFruitesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<ProductsCubit>()..fetchBestSelling(topN: 5),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Best Selling Fruits"),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsSuccess) {
              final products = state.products;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index];

                  return Card(
  child: Row(
    children: [
      Image.network(
        product.imageurl ?? 'https://via.placeholder.com/150',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      const SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Sold: ${product.sellingcount} units'),
          Text('\$${product.price}'),
        ],
      ),
    ],
  ),
)
;
                },
              );
            } else if (state is ProductsFailure) {
              return Center(child: Text(state.errMessage));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
