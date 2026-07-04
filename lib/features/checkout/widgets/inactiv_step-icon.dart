import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class InactivStepIcon extends StatelessWidget {
  const InactivStepIcon({super.key, required this.text, required this.index});
  final String text, index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: const Color(0xFFF3F3F3),
          child: Text(index.toString(), style: TextStyles.semiBold13),
        ),
        const SizedBox(width: 4),
        Text(text, style: TextStyles.bold13.copyWith(color: Color(0xFFAAAAAA))),
      ],
    );
  }
}
