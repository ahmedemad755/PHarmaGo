import 'dart:io';

import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/prescription/prescription_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF007BBB);
  static const Color lightBlueBackground = Color(0xFFE6FBFF);
  static const Color guideCardGradientTop = Color(0xFF8EDFEF);
  static const Color guideCardGradientBottom = Color(0xFF52A6E9);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color greyText = Color(0xFF555555);
}

// ====================================================================
// Upload Prescription Screen
// ====================================================================
class UploadPrescription extends StatefulWidget {
  const UploadPrescription({super.key});

  @override
  State<UploadPrescription> createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  File? _pickedImage;
  bool _isProcessing = false;
  String? _ocrResult;

  // 1️⃣ معالجة الصورة OCR
  Future<void> _processImageForOCR(File imageFile) async {
    setState(() {
      _isProcessing = true;
      _ocrResult = null;
    });

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      textRecognizer.close();

      String prescriptionText = recognizedText.text;

      setState(() {
        _ocrResult = prescriptionText;
      });

      debugPrint('OCR Result: $prescriptionText');

      // إرسال النص للـ Cubit للمعالجة
      context.read<PrescriptionCubit>().processOCR(prescriptionText);
    } catch (e) {
      debugPrint('Error during OCR processing: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في معالجة الصورة. حاول مجدداً.')),
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

  // 2️⃣ اختيار صورة من الكاميرا أو المعرض
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final file = File(image.path);
      setState(() => _pickedImage = file);
      await _processImageForOCR(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightBlueBackground,
        appBar: AppBar(
          title: const Text(
            'تحميل الوصفة الطبية',
            style: TextStyle(color: AppColors.primaryBlue),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<PrescriptionCubit, PrescriptionState>(
            listener: (context, state) {
              if (state is PrescriptionAddDirect) {
                context.read<CartCubit>().addProduct(
                  state.product,
                  quantity: 1,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إضافة الدواء مباشرة للسلة')),
                );
              }

              if (state is PrescriptionNeedConfirm) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('تأكيد الدواء'),
                    content: Text('تم العثور بنسبة ${state.score.toInt()}%'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<CartCubit>().addProduct(
                            state.product,
                            quantity: 1,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('موافق'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                    ],
                  ),
                );
              }

              if (state is PrescriptionAISuggest) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'لا يوجد تطابق مباشر. AI يقترح منتجات مشابهة',
                    ),
                  ),
                );
              }

              if (state is PrescriptionFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const PrescriptionGuideCard(),
                    const SizedBox(height: 30),
                    UploadDropZone(
                      image: _pickedImage,
                      isProcessing: state is PrescriptionLoading,
                    ),
                    const SizedBox(height: 20),
                    ImageSourceSelection(onPickImage: _pickImage),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ======================
// Prescription Guide Card
// ======================
class PrescriptionGuideCard extends StatelessWidget {
  const PrescriptionGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            AppColors.guideCardGradientTop,
            AppColors.guideCardGradientBottom,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'دليل الوصفة الطبية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 10),
          _GuideCheckItem(text: 'تحميل صورة واضحة'),
          _GuideCheckItem(text: 'بيانات الطبيب مطلوبة'),
          _GuideCheckItem(text: 'تاريخ الوصفة الطبية'),
          _GuideCheckItem(text: 'بيانات المريض'),
          _GuideCheckItem(text: 'تفاصيل الجرعة'),
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
    return Row(
      children: [
        const Icon(Icons.check_box, color: AppColors.white, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: AppColors.white)),
      ],
    );
  }
}

// ======================
// Upload Drop Zone
// ======================
class UploadDropZone extends StatelessWidget {
  final File? image;
  final bool isProcessing;

  const UploadDropZone({super.key, this.image, required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isProcessing) {
      content = const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      );
    } else if (image != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          image!,
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    } else {
      content = const Center(
        child: Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.primaryBlue,
          size: 50,
        ),
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }
}

// ======================
// Image Source Selection
// ======================
class ImageSourceSelection extends StatelessWidget {
  final Function(ImageSource) onPickImage;
  const ImageSourceSelection({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onPickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('كاميرا'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onPickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('معرض الصور'),
          ),
        ),
      ],
    );
  }
}
