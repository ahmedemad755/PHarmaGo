import 'dart:io';

import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/home/domain/enteties/medicine_entity.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/prescription/prescription_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UploadPrescriptionView extends StatefulWidget {
  const UploadPrescriptionView({super.key});

  @override
  State<UploadPrescriptionView> createState() => _UploadPrescriptionViewState();
}

class _UploadPrescriptionViewState extends State<UploadPrescriptionView> {
  File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85, // لتحسين سرعة الرفع مع الحفاظ على الجودة
    );
    if (image != null) {
      final file = File(image.path);
      setState(() => _pickedImage = file);
      if (mounted) {
        context.read<PrescriptionCubit>().uploadAndAnalyzePrescription(file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية متدرجة تعطي مظهر احترافي
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightPrimaryColor.withOpacity(0.4),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocConsumer<PrescriptionCubit, PrescriptionState>(
                    listener: (context, state) {
                      if (state is PrescriptionFailure) {
                        _showErrorSnackBar(context, state.errMessage);
                      }
                    },
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildStateContent(state),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildImageControls(),
                const SizedBox(height: 30), // مسافة إضافية لتجنب أزرار النظام
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        const Text(
          'الماسح الذكي للروشتات',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(width: 40), // موازن للهيدر
      ],
    );
  }

  Widget _buildStateContent(PrescriptionState state) {
    if (state is PrescriptionLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 24),
            Text(
              "جاري تحليل خط الطبيب...",
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    } else if (state is PrescriptionAnalyzed) {
      return _buildMedicinesList(state.medicines);
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: _pickedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.file(_pickedImage!, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, size: 64, color: AppColors.primary.withOpacity(0.4)),
                    const SizedBox(height: 16),
                    const Text("ارفع صورة الروشتة هنا", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  ],
                ),
        ),
        const SizedBox(height: 30),
        const Text(
          "تقنية الذكاء الاصطناعي ستساعدك في تحديد الأدوية بدقة عالية",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMedicinesList(List<MedicineEntity> medicines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.checklist_rtl, color: AppColors.primary),
            const SizedBox(width: 8),
            Text("النتائج المستخرجة (${medicines.length})",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: medicines.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final item = medicines[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.lightPrimaryColor,
                    child: const Icon(Icons.medication, color: AppColors.primary),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.dose ?? ''} | ${item.frequency ?? ''}"),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                      onPressed: () {
                        // كود السلة
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageControls() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icons.camera_enhance_rounded,
              label: 'تصوير مباشر',
              isPrimary: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icons.image_search_rounded,
              label: 'من المعرض',
              isPrimary: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required VoidCallback onPressed, required IconData icon, required String label, required bool isPrimary}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primary : Colors.white,
        foregroundColor: isPrimary ? Colors.white : AppColors.primary,
        elevation: isPrimary ? 4 : 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isPrimary ? BorderSide.none : const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}