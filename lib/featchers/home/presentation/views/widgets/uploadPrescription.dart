import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
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
  String? _selectedPharmacyId;
  String? _selectedPharmacyName;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _pickedImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب روشتة جديدة'), centerTitle: true),
      body: SingleChildScrollView(
        // أضفنا سكرول لتجنب مشاكل المساحة مع الكيبورد
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "1. اختر الصيدلية:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // --- الدروب داون ليست مرتبطة بـ Firestore ---
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(BackendPoints.pharmacies)
                  .where('status', isEqualTo: 'approved')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Text("خطأ في تحميل الصيدليات");
                if (!snapshot.hasData) return const LinearProgressIndicator();

                var docs = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    hintText: 'اختر الصيدلية من القائمة',
                  ),
                  initialValue: _selectedPharmacyId,
                  items: docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: data['uId'],
                      child: Text(data['pharmacyName'] ?? 'صيدلية غير معروفة'),
                      onTap: () {
                        _selectedPharmacyName = data['pharmacyName'];
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPharmacyId = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 30),
            const Text(
              "2. صورة الروشتة:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // منطقة عرض الصورة
            GestureDetector(
              onTap: () => _showImageSourceDialog(),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_pickedImage!, fit: BoxFit.contain),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 60,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "اضغط هنا لالتقاط أو رفع الصورة",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 40),

            CustomButtn(
              text: 'تأكيد وإضافة للسلة',
              onPressed: () {
                if (_selectedPharmacyId == null) {
                  showBar(
                    context,
                    'من فضلك اختر الصيدلية أولاً',
                    color: Colors.orange,
                  );
                  return;
                }
                if (_pickedImage == null) {
                  showBar(
                    context,
                    'من فضلك ارفع صورة الروشتة',
                    color: Colors.orange,
                  );
                  return;
                }

                // إضافة للسلة عبر الكيوبت
                context.read<CartCubit>().setPrescriptionImage(
                  XFile(_pickedImage!.path),
                );
                context.read<CartCubit>().addPrescriptionToCart(
                  _pickedImage!,
                  _selectedPharmacyId!,
                  _selectedPharmacyName!,
                );

                showBar(
                  context,
                  'تمت الإضافة بنجاح لصيدلية $_selectedPharmacyName',
                  color: Colors.green,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.camera_alt)),
              title: const Text('استخدام الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.photo_library)),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
