// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:e_commerce/constants.dart';
// import 'package:e_commerce/core/functions_helper/routs.dart';
// import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
// import 'package:e_commerce/core/utils/app_colors.dart';
// import 'package:e_commerce/core/widgets/custom_button.dart';
// import 'package:e_commerce/featchers/onboarding/widgets/onboarding_pageView.dart';
// import 'package:flutter/material.dart';

// class OnboardingViewBody extends StatefulWidget {
//   const OnboardingViewBody({super.key});

//   @override
//   State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
// }

// class _OnboardingViewBodyState extends State<OnboardingViewBody> {
//   late PageController pageController;
//   int currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//     pageController.addListener(() {
//       setState(() {
//         currentPage = pageController.page!.round();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//     // Dispose of the page controller to free resources
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: OnboardingPageview(
//             pageController: pageController,
//             currentPage: currentPage,
//           ),
//         ),
//         DotsIndicator(
//           dotsCount: 2,
//           decorator: DotsDecorator(
//             color: currentPage == 1
//                 ? AppColors.primaryColor
//                 : const Color.fromARGB(125, 31, 94, 59), // Active color
//             activeColor: AppColors.primaryColor,
//           ),
//         ),
//         SizedBox(height: 29),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
//           child: Visibility(
//             visible: currentPage == 1 ? true : false,
//             maintainAnimation: true,
//             maintainSize: true,
//             maintainState: true,
//             // Show button only on the first page
//             child: CustomButtn(
//               onPressed: () async {
//                 await Prefs.setBool(kIsOnBoardingViewSeen, true);
//                 Navigator.of(context).pushReplacementNamed(AppRoutes.login);
//               },
//               text: 'ابدأ الان',
//             ),
//           ),
//         ),
//         const SizedBox(height: 43),
//       ],
//     );
//   }
// }

import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart'
    show Prefs;
import 'package:e_commerce/featchers/onboarding/widgets/custom_button.dart';
import 'package:e_commerce/featchers/onboarding/widgets/dots_indicator.dart';
import 'package:e_commerce/featchers/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Ensure the controller is properly initialized before first use
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() async {
    await Prefs.setBool(kIsOnBoardingViewSeen, true);
    Navigator.of(context).pushReplacementNamed(AppRoutes.pharmacyHome);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 3, // Number of onboarding pages
        onPageChanged: (index) {
          if (mounted) {
            setState(() {
              _currentIndex = index;
            });
            _fadeController.reset();
            _fadeController.forward();
          }
        },
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return _buildOnboardingPage(
                screenSize,
                title: 'مسح. طلب.',
                subtitle: 'تم. لا يوجد أخطاء.',
                description:
                    'التقط صورة لوصفتك الطبية (الروشتة).\nسنقوم بقراءة وإضافة جميع الأصناف إلى سلة مشترياتك تلقائيًا وفورًا.',
                cornerColor1: const Color(0xFF00D4FF),
                cornerColor2: const Color.fromARGB(255, 1, 123, 236),
                hasRx: true,
              );
            case 1:
              return _buildOnboardingPage(
                screenSize,
                title: 'تسليم سريع',
                subtitle: 'مباشرة إلى باب منزلك.',
                description:
                    'احصل على أدويتك خلال ساعات.\nخدمة صيدليات موثوقة لراحتك.',
                cornerColor1: const Color(0xFF00C6FF),
                cornerColor2: const Color(0xFF00A8E8),
                hasRx: false,
              );
            case 2:
            default:
              return _buildOnboardingPage(
                screenSize,
                title: 'دعم الخبراء',
                subtitle: '24/7 مساعدة الصيدلي.',
                description:
                    'الدردشة مع الصيادلة المرخصين في أي وقت.\nإجابات على جميع أسئلتك المتعلقة بالأدوية.',
                cornerColor1: const Color(0xFF00E5FF),
                cornerColor2: const Color(0xFF0090FF),
                hasRx: false,
              );
          }
        },
      ),
    );
  }

  Widget _buildOnboardingPage(
    Size screenSize, {
    required String title,
    required String subtitle,
    required String description,
    required Color cornerColor1,
    required Color cornerColor2,
    required bool hasRx,
  }) {
    // Calculate responsive sizes
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;

    final cardSize = isMobile
        ? screenSize.width * 0.45
        : isTablet
        ? screenSize.width * 0.4
        : screenSize.width * 0.35;

    final titleFontSize = isMobile
        ? 22.0
        : isTablet
        ? 26.0
        : 28.0;
    final subtitleFontSize = isMobile
        ? 26.0
        : isTablet
        ? 30.0
        : 32.0;
    final descriptionFontSize = isMobile
        ? 13.0
        : isTablet
        ? 14.0
        : 16.0;
    final buttonHeight = isMobile ? 48.0 : 50.0;
    final horizontalPadding = isMobile ? 20.0 : 24.0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFB1E5F6),
              const Color(0xFF67B0E6),
              const Color(0xFF4A90D9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -50,
              left: -50,
              child: GlassCard(
                width: 200,
                height: 200,
                borderRadius: 40,
                opacity: 0.15,
                gradientColors: [cornerColor1, cornerColor2],
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              bottom: -30,
              right: -30,
              child: GlassCard(
                width: 180,
                height: 180,
                borderRadius: 35,
                opacity: 0.12,
                gradientColors: [cornerColor2, cornerColor1],
                child: const SizedBox.expand(),
              ),
            ),

            // Main content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: isMobile ? 12 : 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Main glass card with icon
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 12 : 16,
                              ),
                              child: GlassCard(
                                width: cardSize,
                                height: cardSize,
                                borderRadius: 32,
                                opacity: 0.2,
                                gradientColors: [cornerColor1, cornerColor2],
                                child: Center(
                                  child: Container(
                                    width: cardSize * 0.7,
                                    height: cardSize * 0.7,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          cornerColor1.withOpacity(0.8),
                                          cornerColor2.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: cornerColor1.withOpacity(0.3),
                                          blurRadius: 16,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: _buildIconForPage(_currentIndex),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Title, Subtitle, Description
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 8 : 12,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: subtitleFontSize,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 10 : 12),
                                  Text(
                                    description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: descriptionFontSize,
                                      height: 1.4,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Bottom section (dots, button, skip)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 8 : 12,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Dots indicator
                                  DotsIndicator(
                                    totalDots: 3,
                                    currentIndex: _currentIndex,
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white,
                                    dotSize: 9,
                                    spacing: 8,
                                  ),

                                  SizedBox(height: isMobile ? 12 : 16),

                                  // Get Started / Next button
                                  GradientButton(
                                    label: _currentIndex == 2
                                        ? 'ابدأ'
                                        : 'التالي',
                                    onPressed: _goToNextPage,
                                    width: double.infinity,
                                    height: buttonHeight,
                                    gradientColors: [
                                      cornerColor1,
                                      cornerColor2,
                                    ],
                                    borderRadius: 16,
                                    hasIcon: true,
                                    icon: _currentIndex == 2
                                        ? Icons.check_circle_outline
                                        : Icons.arrow_forward_ios,
                                  ),

                                  if (_currentIndex < 2)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: TextButton(
                                        onPressed: _navigateToHome,
                                        child: const Text(
                                          'يتخطى',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconForPage(int index) {
    switch (index) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_camera, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            const Text(
              'Rx',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      case 1:
        return Icon(Icons.local_shipping, color: Colors.white, size: 40);
      case 2:
        return Icon(Icons.support_agent, color: Colors.white, size: 40);
      default:
        return const Icon(Icons.home, color: Colors.white);
    }
  }
}
