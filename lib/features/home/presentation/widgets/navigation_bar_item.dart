import 'package:e_commerce/Features/home/domain/enteties/bottom_Navigation_bar_entetie.dart';
import 'package:e_commerce/Features/home/presentation/widgets/activ_navigation_bar_item.dart';
import 'package:e_commerce/Features/home/presentation/widgets/inactive_navigatin_bar_item.dart';
import 'package:flutter/material.dart';

class NavigationBarItems extends StatelessWidget {
  const NavigationBarItems({
    super.key,
    required this.isSelected,
    required this.bottomNavigationbarEntety,
  });
  final bool isSelected;
  final BottomNavigationbarEntety bottomNavigationbarEntety;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? ActiveImag(
            image: bottomNavigationbarEntety.activimag,
            text: bottomNavigationbarEntety.name,
          )
        : InActiveImag(image: bottomNavigationbarEntety.inactivimag);
  }
}
