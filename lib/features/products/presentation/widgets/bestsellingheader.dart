import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_styles.dart';

class BestSellingHeader extends StatelessWidget {
  const BestSellingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'الأكثر مبيعًا',
          textAlign: TextAlign.right,
          style: TextStyles.bold16,
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.bestFruites);
          },
          child: Text(
            'المزيد',
            style: TextStyles.regular13.copyWith(
              color: const Color(0xFF949D9E),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
