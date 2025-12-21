import 'dart:io';
import 'dart:ui';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ⚠️ تحتاج لتعريف هذا الكلاس في مكان ما (قد يكون AppColors.dart)
class AppColors {
  static const Color primaryBlue = Color(0xFF007BBB); // لون أزرق أساسي
  static const Color lightBlueBackground = Color(0xFFE6FBFF); // لون خلفية خفيف (فاتح)
  static const Color guideCardGradientTop = Color(0xFF8EDFEF); // لون أعلى التدرج
  static const Color guideCardGradientBottom = Color(0xFF52A6E9); // لون أسفل التدرج
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color greyText = Color(0xFF555555);
  static const Color lightGrey = Color(0xFFE0E0E0);
}



// ====================================================================
// 1. شاشة التحميل الرئيسية (Uploadprescription)
// ====================================================================

class Uploadprescription extends StatefulWidget {
  const Uploadprescription({super.key});

  @override
  State<Uploadprescription> createState() => _UploadprescriptionState();
}

class _UploadprescriptionState extends State<Uploadprescription> {
  File? _pickedImage;
  bool _isProcessing = false;
  String? _ocrResult;

  // 1. منطق معالجة الصورة واكتشاف النص (OCR)
  Future<void> _processImageForOCR(File imageFile) async {
    setState(() {
      _isProcessing = true;
      _ocrResult = null;
    });

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      String prescriptionText = recognizedText.text;

      setState(() {
        _ocrResult = prescriptionText;
      });

      // 💡 هنا يمكنك تمرير النص المستخرج (prescriptionText) إلى الـ Cubit/Repository
      _handleOCRResult(prescriptionText);

    } catch (e) {
      debugPrint('Error during OCR processing: $e');
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في معالجة الصورة. حاول مجدداً.')),
        );
      }
      setState(() {
        _pickedImage = null; // إزالة الصورة عند الفشل
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // 2. دالة التعامل مع النتيجة (هذا هو المنطق الذي يتصل بالـ Repository)
  void _handleOCRResult(String text) {
    // ⚠️ هذا الجزء يحتاج إلى ربط مع الـ Cubit أو Repository الخاص بك
    debugPrint('النص المستخرج سيتم إرساله للتحقق: $text');

    // مثال على ما سيحدث:
    // context.read<PrescriptionCubit>().checkPrescription(text);

    // * بعد التحقق، سيظهر لك التنبيه (Prompt) للانتقال إلى السلة
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم استخراج النص بنجاح. يرجى مراجعة السلة.'),
          action: SnackBarAction(
            label: 'اذهب للسلة',
            onPressed: () {
              // Navigator.pushNamed(context, '/cart'); // الانتقال للسلة
            },
          ),
        ),
      );
    }
  }

  // 3. دالة اختيار الصورة / الالتقاط
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final file = File(image.path);
      setState(() {
        _pickedImage = file;
      });
      await _processImageForOCR(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 💡 لضمان دعم اتجاه النص من اليمين لليسار (RTL) بشكل صحيح
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightBlueBackground,
        appBar: AppBar(
          title: const Text('تحميل الوصفة الطبية', style: TextStyle(color: AppColors.primaryBlue)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: SingleChildScrollView(
            primary: false, // 1. تعطيل خاصية primary
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const PrescriptionGuideCard(),
                const SizedBox(height: 30),
                
                // يتم تمرير الصورة والحالة لمنطقة التحميل
                UploadDropZone(
                  image: _pickedImage,
                  isProcessing: _isProcessing,
                  ocrResult: _ocrResult,
                ),
          
                const SizedBox(height: 20),
                ImageSourceSelection(onPickImage: _pickImage),
                
                // ⚠️ يمكنك إظهار نتيجة OCR لأغراض الاختبار
                if (_ocrResult != null && !_isProcessing) 
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'النص المستخرج:\n$_ocrResult',
                      style: const TextStyle(color: AppColors.greyText),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// 2. بطاقة إرشادات الوصفة (PrescriptionGuideCard) - لم تتغير
// ====================================================================

class PrescriptionGuideCard extends StatelessWidget {
  const PrescriptionGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.guideCardGradientTop, AppColors.guideCardGradientBottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'دليل الوصفة الطبية', 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 15),
          
          const _GuideCheckItem(text: 'تحميل صورة واضحة'),
          const _GuideCheckItem(text: 'بيانات الطبيب مطلوبة'),
          const _GuideCheckItem(text: 'تاريخ الوصفة الطبية'),
          const _GuideCheckItem(text: 'بيانات المريض'),
          const _GuideCheckItem(text: 'تفاصيل الجرعة'),

          const SizedBox(height: 20),
          const Divider(color: AppColors.white, thickness: 0.5),
          const SizedBox(height: 15),

          const Text(
            'كيفية العمل', 
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WorkStep(icon: Icons.upload_file, label: 'تحميل\nالصورة'),
              _WorkStep(icon: Icons.shopping_cart, label: 'إضافة\nللسلة'),
              _WorkStep(icon: Icons.assignment_turned_in, label: 'تأكيد\nالطلب بنفسك'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideCheckItem extends StatelessWidget {
  final String text;
  const _GuideCheckItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_box, color: AppColors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkStep extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WorkStep({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// 3. منطقة التحميل (UploadDropZone) - تم التعديل لعرض الصورة/الحالة
// ====================================================================

class UploadDropZone extends StatelessWidget {
  final File? image;
  final bool isProcessing;
  final String? ocrResult;
  
  const UploadDropZone({
    super.key, 
    this.image, 
    required this.isProcessing,
    this.ocrResult,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    
    if (isProcessing) {
      // 💡 حالة معالجة (تحميل)
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryBlue),
          SizedBox(height: 10),
          Text(
            'جاري معالجة الوصفة واستخراج النص...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      );
    } else if (image != null) {
      // 💡 حالة وجود الصورة
      content = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 150,
        ),
      );
    } else {
      // 💡 حالة الإنتظار
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.primaryBlue,
            size: 50,
          ),
          SizedBox(height: 10),
          Text(
            'قم بتحميل الملف هنا',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        // إظهار الحدود المتقطعة فقط في حالة الانتظار
        painter: image == null && !isProcessing 
            ? _DashedBorderPainter(
                borderColor: AppColors.primaryBlue.withOpacity(0.7),
                borderRadius: 16.0,
              )
            : null,
        child: Center(child: content),
      ),
    );
  }
}

// CustomPainter لرسم الحدود المتقطعة (تم نقله هنا ليكون ملفاً واحداً)
class _DashedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;

  _DashedBorderPainter({required this.borderColor, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8;
    const double dashSpace = 5;
    
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    ));

    Path drawPath = Path();
    for (PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        drawPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(drawPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ====================================================================
// 4. اختيار مصدر الصورة (ImageSourceSelection) - تم التعديل لاستدعاء الدالة
// ====================================================================

class ImageSourceSelection extends StatelessWidget {
  final Function(ImageSource) onPickImage;
  const ImageSourceSelection({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _SourceButton(
            icon: Icons.camera_alt,
            label: 'كاميرا',
            color: AppColors.primaryBlue,
            onPressed: () => onPickImage(ImageSource.camera), // استخدام الكاميرا
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _SourceButton(
            icon: Icons.photo_library,
            label: 'معرض الصور',
            color: AppColors.primaryBlue.withOpacity(0.7),
            onPressed: () => onPickImage(ImageSource.gallery), // استخدام المعرض
          ),
        ),
      ],
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}