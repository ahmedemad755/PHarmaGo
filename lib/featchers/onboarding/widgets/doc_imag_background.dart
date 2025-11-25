import 'package:e_commerce/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class docimageandbackground extends StatelessWidget {
  const docimageandbackground({super.key, required this.isVisible});

   final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset("assets/docdoc_logo_low_opacity.svg"),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          // height: MediaQuery.of(context).size.height * 0.5,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.0)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.14, 0.4],
            ),
          ),
          child: Image.asset("assets/thirdcups.png", fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 40,
          right: 0,
          left: 0,
          child: Text(
            "best doctor appointment app",
            textAlign: TextAlign.center,
            style: TextStyles.bold28.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
