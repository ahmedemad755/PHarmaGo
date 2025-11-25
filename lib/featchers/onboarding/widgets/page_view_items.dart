import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageViewItems extends StatelessWidget {
  const PageViewItems({
    super.key,
    required this.image,
    required this.backgroundimag,
    required this.subtitle,
    required this.title,
    required this.isVisible,
  });
  final String image;
  final String backgroundimag;
  final String subtitle;
  final Widget title;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(backgroundimag, fit: BoxFit.fill),
                ),
Positioned(

bottom: 0,

left: 0,

right: 0,

child: SvgPicture.asset(image, ),

),

                Visibility(
                  visible: isVisible,

                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        right: 30,
                      ), // نزل شويه
                      child: GestureDetector(
                        onTap: () {
                          Prefs.setBool(kIsOnBoardingViewSeen, true);
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.login);
                        },
                        child: Text(
                          'تخط',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // bold بدل normal
                            fontSize: 18, // أكبر من 13
                            color: const Color.fromARGB(255, 52, 53, 53),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          title,
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xFF4E5456),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
