import 'package:e_commerce/core/functions_helper/get_dummy_product.dart';
import 'package:e_commerce/core/products_cubit/products_cubit.dart';
import 'package:e_commerce/core/widgets/custom_error_widget.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/products_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsGridViewBlocBuilder extends StatelessWidget {
  const ProductsGridViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsSuccess) {
          // تم حذف SliverToBoxAdapter لأن الأب هو Padding عادي
          return ProductsGridView(products: state.products);
        } else if (state is ProductsFailure) {
          return CustomErrorWidget(text: state.errMessage);
        } else {
          return Skeletonizer(
            key: const ValueKey('products_skeleton_active'),
            enabled: true,
            child: ProductsGridView(products: getDummyProducts()),
          );
        }
      },
    );
  }
}