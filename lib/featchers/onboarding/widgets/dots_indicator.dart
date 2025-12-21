import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int totalDots;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const DotsIndicator({
    Key? key,
    required this.totalDots,
    required this.currentIndex,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white,
    this.dotSize = 10,
    this.spacing = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: index == currentIndex ? dotSize * 2.5 : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? activeColor
                  : inactiveColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          ),
        ),
      ),
    );
  }
}
