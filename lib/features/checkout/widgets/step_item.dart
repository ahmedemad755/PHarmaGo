import 'package:e_commerce/Features/checkout/widgets/activ_step_icon.dart';
import 'package:e_commerce/Features/checkout/widgets/inactiv_step-icon.dart';
import 'package:flutter/material.dart';

class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.index,
    required this.text,
    required this.isActive,
  });

  final String text, index;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: InactivStepIcon(index: index, text: text),
      secondChild: ActivStepIcon(text: text),
      crossFadeState: isActive
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}
