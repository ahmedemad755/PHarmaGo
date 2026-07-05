import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/Features/alarm/domain/entities/alarm_entity.dart';
import 'package:e_commerce/Features/alarm/presentation/cubits/alarm/alarm_cubit.dart';
import 'package:e_commerce/Features/alarm/presentation/cubits/alarm/alarm_state.dart';
import 'package:e_commerce/Features/alarm/presentation/widgets/alarm_text_field.dart';
import 'package:e_commerce/Features/auth/widgets/custombotton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAlarmView extends StatefulWidget {
  const AddAlarmView({super.key});

  @override
  State<AddAlarmView> createState() => _AddAlarmViewState();
}

class _AddAlarmViewState extends State<AddAlarmView> {
  final List<DateTime> _selectedTimes = [];
  final TextEditingController _nameController = TextEditingController();
  String _selectedDosage = "جرعة واحدة يومياً";

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveAlarm() {
    int requiredDoses = _selectedDosage == "جرعة واحدة يومياً"
        ? 1
        : (_selectedDosage == "جرعتين يومياً" ? 2 : 3);

    if (_nameController.text.trim().isEmpty) {
      showBar(context, "يرجى إدخال اسم الدواء");
      return;
    }

    if (_selectedTimes.length != requiredDoses) {
      showBar(context, "يجب اختيار $requiredDoses مواعيد بالضبط");
      return;
    }

    final newAlarm = AlarmEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicationName: _nameController.text.trim(),
      reminderTimes: List.from(_selectedTimes),
      dosage: _selectedDosage,
    );
    context.read<AlarmsCubit>().addAlarm(newAlarm);
  }

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        _selectedTimes.add(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int requiredDoses = _selectedDosage == "جرعة واحدة يومياً"
        ? 1
        : (_selectedDosage == "جرعتين يومياً" ? 2 : 3);

    return BlocListener<AlarmsCubit, AlarmsState>(
      listener: (context, state) {
        if (state is AlarmAddedSuccessfully) Navigator.pop(context);
        if (state is AlarmsError) showBar(context, state.message);
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          title: const Text(
            "إضافة منبه جديد",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkBlue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const  AlarmSectionTitle(title: "اسم الدواء"),
            const SizedBox(height: 16),
            AlarmTextField(
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            AlarmDosageDropdown(
              initialValue: _selectedDosage,
              onChanged: (value) {
                setState(() {
                  _selectedDosage = value!;
                  _selectedTimes.clear();
                });
              },
            ),
             const SizedBox(height: 32),
             AlarmSectionTitle(title: "مواعيد التذكير"),
              const SizedBox(height: 8),
              AlarmDoseHint(requiredDoses: requiredDoses,
              selectedTimesCount: _selectedTimes.length),
             const SizedBox(height: 32),
             AlarmTimePickerTile(onTap: () => _pickTime(context)),
              const SizedBox(height: 12),
              AlarmTimeChipsView(selectedTimes: _selectedTimes,
              onDelete: (t)=> setState(() => _selectedTimes.remove(t))),
              const SizedBox(height: 60),
              Center(
                child: GradientButton(
                  label: "حفظ المنبه",
                  gradientColors: AppColors.getAccentGradientByPage(2).colors.toList(),
                  onPressed: _saveAlarm,
                  
                ),
              ),


    

            
              
  
              


            ],
          ),
        ),
      ),
    );
  }
}

