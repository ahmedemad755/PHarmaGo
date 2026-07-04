import 'dart:async';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/functions_helper/upload_helper.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/Features/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class Chatbootview extends StatefulWidget {
  const Chatbootview({super.key});

  @override
  State<Chatbootview> createState() => _ChatbootviewState();
}

class _ChatbootviewState extends State<Chatbootview> {
  bool _isOpening = false;

  Future<void> _openChat() async {
    if (_isOpening) return;

    setState(() => _isOpening = true);

    _syncEgyptDrugCatalogInBackground();

    if (!mounted) return;
    await Navigator.pushNamed(context, AppRoutes.ChatbootBody);

    if (mounted) {
      setState(() => _isOpening = false);
    }
  }

  void _syncEgyptDrugCatalogInBackground() {
    unawaited(
      UploadHelper.uploadDrugs().catchError((error, stackTrace) {
        debugPrint('Chatbot catalog sync skipped: $error');
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text(
            'محادثة صحية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppColors.darkBlue),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    ShaderMask(
                      shaderCallback: AppColors.primaryGradient.createShader,
                      blendMode: BlendMode.srcIn,
                      child: Icon(
                        Icons.medical_services_rounded,
                        size: screenHeight * 0.12,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    const Text(
                      'صحتك بذكاء',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اسأل عن الأعراض البسيطة واحصل على اقتراحات عامة من كتالوج أدوية مصري داخل التطبيق.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const _MedicalWarningCard(),
                    SizedBox(height: screenHeight * 0.05),
                    IgnorePointer(
                      ignoring: _isOpening,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: _isOpening ? 0.7 : 1,
                        child: SizedBox(
                          height: 56,
                          child: GradientButton(
                            onPressed: _openChat,
                            label: _isOpening
                                ? 'جاري فتح المحادثة...'
                                : 'ابدأ الاستشارة الطبية الآن',
                            icon: _isOpening
                                ? Icons.hourglass_top_rounded
                                : Icons.chat_rounded,
                          ),
                        ),
                      ),
                    ),
                    if (_isOpening) ...[
                      const SizedBox(height: 16),
                      const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ],
                    SizedBox(height: screenHeight * 0.08),
                  ],
                ),
              ),
            
          ),
        ),
      ),
    ));
  }
}

class _MedicalWarningCard extends StatelessWidget {
  const _MedicalWarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.errorColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'تنبيه هام',
                style: TextStyle(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'هذا المساعد لا يقدم تشخيصا أو روشتة نهائية. استخدمه كمعلومات عامة فقط، وفي الحالات الطارئة يرجى التوجه لأقرب مستشفى.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.errorColor.withOpacity(0.82),
              fontSize: 13,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}