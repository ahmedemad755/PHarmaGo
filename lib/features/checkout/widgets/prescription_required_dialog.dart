import 'package:flutter/material.dart';

class PrescriptionRequiredDialog extends StatelessWidget {
  const PrescriptionRequiredDialog({super.key, required this.onUploadPressed});

  final VoidCallback onUploadPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.medical_information, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'مطلوب روشتة طبية',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      content: const Text(
        'هذا الدواء يتطلب روشتة طبية وإرشاداً طبياً موثوقاً. يرجى رفع صورة الروشتة للمتابعة.',
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onUploadPressed();
          },
          child: const FittedBox(
            child: Text(
              'رفع الروشتة الآن',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
