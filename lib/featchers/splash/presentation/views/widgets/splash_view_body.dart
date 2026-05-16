import 'dart:ui';

import 'package:e_commerce/constants.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  static const _brandAsset = 'assets/pharma_go_splash_brand.png';
  static const _animationDuration = Duration(milliseconds: 2200);
  static const _handoffDelay = Duration(milliseconds: 2450);

  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _glowFade;
  late final Animation<double> _progress;
  late final Animation<double> _captionFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, .45, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: .88, end: 1).animate(curved);
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(curved);
    _glowFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.12, .75, curve: Curves.easeOut),
      ),
    );
    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.25, 1, curve: Curves.easeInOutCubic),
      ),
    );
    _captionFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.5, .95, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _navigateAfterSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoSize = (size.shortestSide * .72).clamp(250.0, 360.0);

    return ColoredBox(
      color: const Color(0xFFF7FBFD),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _SplashBackdrop(),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  SizedBox(
                    height: logoSize,
                    width: logoSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        FadeTransition(
                          opacity: _glowFade,
                          child: Container(
                            width: logoSize * .86,
                            height: logoSize * .86,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(.18),
                                  blurRadius: 70,
                                  spreadRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: _logoSlide,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Image.asset(
                              _brandAsset,
                              width: logoSize,
                              height: logoSize,
                              fit: BoxFit.contain,
                              opacity: _logoFade,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -34),
                    child: FadeTransition(
                      opacity: _captionFade,
                      child: Column(
                        children: [
                          Text(
                            'Smart Pharmacy System',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.darkBlue.withOpacity(.72),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0,
                                ),
                          ),
                          const SizedBox(height: 22),
                          AnimatedBuilder(
                            animation: _progress,
                            builder: (context, _) {
                              return Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 148,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      minHeight: 4,
                                      value: _progress.value,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(.12),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            AppColors.primary,
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(_handoffDelay);
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(_targetRoute);
  }

  String get _targetRoute {
    final isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    final isLoggedIn =
        FirebaseAuth.instance.currentUser != null || Prefs.getBool('isLoggedIn');

    if (!isOnBoardingViewSeen) {
      return AppRoutes.onboarding;
    }
    if (isLoggedIn) {
      return AppRoutes.home;
    }
    return AppRoutes.login;
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFEAF8FC),
            Color(0xFFD9F0F8),
          ],
          stops: [0, .52, 1],
        ),
      ),
      child: CustomPaint(painter: _SplashPatternPainter()),
    );
  }
}

class _SplashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = AppColors.primary.withOpacity(.08)
      ..style = PaintingStyle.fill;
    final goldPaint = Paint()
      ..color = AppColors.secondaryColor.withOpacity(.12)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * .13, size.height * .17),
      size.shortestSide * .28,
      primaryPaint,
    );
    canvas.drawCircle(
      Offset(size.width * .88, size.height * .78),
      size.shortestSide * .34,
      goldPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .08,
          size.height * .78,
          size.width * .24,
          size.width * .24,
        ),
        const Radius.circular(28),
      ),
      primaryPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
