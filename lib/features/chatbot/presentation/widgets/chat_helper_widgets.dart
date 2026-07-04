import 'package:flutter/material.dart';
import 'package:e_commerce/core/utils/app_colors.dart';

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Text(
          'جاري البحث عن اقتراحات مناسبة...',
          style: TextStyle(
            color: AppColors.darkGray,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SafetyStrip extends StatelessWidget {
  const SafetyStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.14)),
      ),
      child: const Text(
        "⚠️ تنويه طبي: هذا المساعد يقدم معلومات عامة وإرشادية فقط ولا يغني عن استشارة الطبيب أو الصيدلي. إذا كنت تعاني من أي حساسية، أو موانع استخدام لمواد فعالة معينة، أو لديك مشاكل صحية مزمنة (مثل مرضى الكبد والكلى الذين تتطلب حالتهم حذراً خاصاً مع مواد كالباراسيتامول أو الكافيين)، أو أي حالة خطيرة أخرى، يرجى استشارة طبيب مختص فوراً قبل أخذ أي علاج. الإجابات المقدمة هنا هي إجابات عامة ومبنية على افتراض سلامتك التامة وعدم معاناتك من أي عارض صحي آخر غير الذي قمت بوصفه بدقة.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}