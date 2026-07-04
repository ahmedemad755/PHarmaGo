import 'package:e_commerce/Features/products/presentation/cubit/products_cubit.dart';
import 'package:e_commerce/core/utils/app_imags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/app_text_styles.dart';

class ProductsHeader extends StatelessWidget {
  const ProductsHeader({super.key, required this.productsLength});

  final int productsLength;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${context.read<ProductsCubit>().productsLength} نتائج',
          textAlign: TextAlign.right,
          style: TextStyles.bold16,
        ),
        const Spacer(),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(0.10000000149011612),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x66CACECE)),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: SvgPicture.asset(Assets.fillters),
        ),
      ],
    );
  }
}
