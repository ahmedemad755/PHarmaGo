import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/Features/onboarding/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class HomeUploadPrescriptionCard extends StatelessWidget {
  const HomeUploadPrescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 75,
      borderRadius: 16,
      opacity: 0.9,
      gradientColors: const [Color(0xFFE3F2FD), Color(0xFFF1F8E9)],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 30,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هل لديك روشتة؟',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ارفعها الآن وسنوفر لك الأدوية',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.uploadPrescription),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text("رفع", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
