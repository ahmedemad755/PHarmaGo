import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_imags.dart';
import 'package:e_commerce/featchers/onboarding/widgets/page_view_items.dart';
import 'package:flutter/material.dart';

class OnboardingPageview extends StatelessWidget {
  const OnboardingPageview({
    super.key,
    required this.pageController,
    required this.currentPage,
  });
  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        //  docimageandbackground(
        //         isVisible: pageController.hasClients
        //         ? pageController.page?.round() == 0
        //         : true,),
        //   docimageandbackground(
        //             isVisible: pageController.hasClients
        //         ? pageController.page?.round() != 0
        //         : false,
        // ),
        PageViewItems(
          image: Assets.fruitbasket1,
          backgroundimag: Assets.background2Onboarding,
          subtitle:
              "تشكيلة من الفواكه المجففة بالتبريد، طبيعية 100٪ سناكس صحي وخفيف… بدون سكر مضاف وبدون مواد حافظة",
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'مرحبًا بك في',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              Text(
                '  fruits',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                'ZANATY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          isVisible: pageController.hasClients
              ? pageController.page?.round() == 0
              : true,

          // Show "Skip" only on the first page
        ),
        PageViewItems(
          image: Assets.imag2,
          backgroundimag: Assets.background2Onboarding,
          subtitle:
              'نقدم لك أفضل الفواكه المختارة بعناية. اطلع على التفاصيل والصور والتقييمات لتتأكد من اختيار الفاكهة المثالية',
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " ابحث وتسوق",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ],
          ),
          isVisible: pageController.hasClients
              ? pageController.page?.round() != 0
              : false,
        ),
      ],
    );
  }
}

// ################
