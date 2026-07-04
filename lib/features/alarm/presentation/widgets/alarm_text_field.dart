import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmSectionTitle extends StatelessWidget {
  final String title;
  const AlarmSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue,
      ),
    );
  }
}

class AlarmTextField extends StatelessWidget {
  final TextEditingController controller;
  const AlarmTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "اسم الدواء (مثال: بنادول)",
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(
          Icons.medication_rounded,
          color: AppColors.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
      ),
    );
  }
}

class AlarmDosageDropdown extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String?> onChanged;

  const AlarmDosageDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
      ),
      items: ["جرعة واحدة يومياً", "جرعتين يومياً", "3 جرعات يومياً"]
          .map((label) => DropdownMenuItem(value: label, child: Text(label)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class AlarmDoseHint extends StatelessWidget {
  final int requiredDoses;
  final int selectedTimesCount;

  const AlarmDoseHint({
    super.key,
    required this.requiredDoses,
    required this.selectedTimesCount,
  });

  @override
  Widget build(BuildContext context) {
    bool isComplete = selectedTimesCount == requiredDoses;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "يرجى اختيار عدد ($requiredDoses) مواعيد بناءً على الجرعة",
        style: TextStyle(
          color: isComplete ? Colors.green : AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class AlarmTimePickerTile extends StatelessWidget {
  final VoidCallback onTap;
  const AlarmTimePickerTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "إضافة موعد تذكير جديد",
              style: TextStyle(color: AppColors.mediumGray),
            ),
            Icon(Icons.add_circle_outline, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class AlarmTimeChipsView extends StatelessWidget {
  final List<DateTime> selectedTimes;
  final ValueChanged<DateTime> onDelete;

  const AlarmTimeChipsView({
    super.key,
    required this.selectedTimes,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: selectedTimes
          .map(
            (t) => Chip(
              backgroundColor: AppColors.activeBg,
              label: Text(
                DateFormat.jm().format(t),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onDeleted: () => onDelete(t),
              deleteIconColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.primaryMid),
              ),
            ),
          )
          .toList(),
    );
  }
}