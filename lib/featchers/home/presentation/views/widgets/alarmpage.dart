import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/gradiant_text.dart';
import 'package:e_commerce/featchers/auth/widgets/custombotton.dart';
import 'package:e_commerce/featchers/home/domain/enteties/alarm_entites.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/alarm/alarm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MainAlarmsView extends StatelessWidget {
  const MainAlarmsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          title: const GradientText("منبه الدواء", gradient: AppColors.accentGradient2),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
        body: Builder(builder: (context) => _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AlarmsCubit, AlarmsState>(
      builder: (context, state) {
        final alarms = (state is AlarmsSuccess) ? state.alarms : <AlarmEntity>[];

        if (alarms.isEmpty) return _buildEmptyState(context);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  
                  // تم إضافة الـ Dismissible للحذف بالسحب
                  return Dismissible(
                    key: Key(alarm.id),
                    direction: DismissDirection.horizontal,
                    
                    // الخلفية عند السحب
                    background: _buildDeleteBackground(Alignment.centerRight),
                    secondaryBackground: _buildDeleteBackground(Alignment.centerLeft),

                    // دايالوج التأكيد
                    confirmDismiss: (direction) async {
                      return await _showDeleteConfirmation(context);
                    },

                    // استدعاء ميثود الحذف الأصلية من الكيوبيت
                    onDismissed: (direction) {
                      context.read<AlarmsCubit>().removeAlarm(alarm.id);
                      showBar(context, "تم حذف المنبه");
                    },
                    child: AlarmCard(alarm: alarm),
                  );
                },
              ),
            ),
            _buildActionArea(context),
          ],
        );
      },
    );
  }

  // ميثود خلفية الحذف
  Widget _buildDeleteBackground(Alignment alignment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
    );
  }

  // دايالوج التأكيد
  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("حذف المنبه", textAlign: TextAlign.right),
        content: const Text("هل أنت متأكد من رغبتك في حذف هذا المنبه؟", textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("إلغاء", style: TextStyle(color: AppColors.darkGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            size: 100,
            color: AppColors.primaryMid.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            "لا توجد منبهات حالياً",
            style: TextStyle(color: AppColors.darkGray, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 40),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildActionArea(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 110, top: 20),
        child: _buildAddButton(context),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GradientButton(
      label: "إضافة منبه جديد",
      width: 260,
      icon: Icons.add_alarm_rounded,
      gradientColors: AppColors.getAccentGradientByPage(2).colors.toList(),
      onPressed: () => _navigateToAddTask(context),
    );
  }

  void _navigateToAddTask(BuildContext context) {
    final cubit = context.read<AlarmsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const AddAlarmView(),
        ),
      ),
    );
  }
}

class AlarmCard extends StatelessWidget {
  final AlarmEntity alarm;
  const AlarmCard({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.medicationName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alarm.dosage,
                  style: const TextStyle(color: AppColors.darkgrey600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: alarm.reminderTimes.map((t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                DateFormat.jm().format(t),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentSkyBlue,
                  fontSize: 16,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    int requiredDoses = _selectedDosage == "جرعة واحدة يومياً" ? 1 : (_selectedDosage == "جرعتين يومياً" ? 2 : 3);
    
    return BlocListener<AlarmsCubit, AlarmsState>(
      listener: (context, state) {
        if (state is AlarmAddedSuccessfully) Navigator.pop(context);
        if (state is AlarmsError) showBar(context, state.message);
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          title: const Text("إضافة منبه جديد"),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkBlue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("بيانات الدواء"),
              const SizedBox(height: 12),
              _buildTextField(),
              const SizedBox(height: 20),
              _buildDosageDropdown(),
              const SizedBox(height: 30),
              _buildSectionTitle("مواعيد التذكير"),
              const SizedBox(height: 8),
              Text(
                "يرجى اختيار عدد ($requiredDoses) مواعيد بناءً على الجرعة المحددة",
                style: TextStyle(
                  color: _selectedTimes.length == requiredDoses ? Colors.green : AppColors.primary.withOpacity(0.7), 
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildTimePickerTile(context),
              _buildTimeChips(),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: "اسم الدواء (مثال: بنادول)",
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(Icons.medication_liquid_rounded, color: AppColors.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildDosageDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDosage,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
      ),
      items: ["جرعة واحدة يومياً", "جرعتين يومياً", "3 جرعات يومياً"]
          .map((label) => DropdownMenuItem(value: label, child: Text(label)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedDosage = value!;
          _selectedTimes.clear();
        });
      },
    );
  }

  Widget _buildTimePickerTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text("اضغط لإضافة وقت"),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.activeBg, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add_alarm_rounded, color: AppColors.primary),
      ),
      onTap: () => _pickTime(context),
    );
  }

  Widget _buildTimeChips() {
    return Wrap(
      spacing: 8,
      children: _selectedTimes.map((t) => Chip(
        backgroundColor: AppColors.activeBg,
        side: const BorderSide(color: AppColors.borderColor),
        label: Text(DateFormat.jm().format(t), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        onDeleted: () => setState(() => _selectedTimes.remove(t)),
        deleteIconColor: AppColors.errorColor,
      )).toList(),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary, 
            onSurface: AppColors.darkBlue,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        _selectedTimes.add(DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
      });
    }
  }

  void _saveAlarm() {
    int requiredDoses = _selectedDosage == "جرعة واحدة يومياً" ? 1 : (_selectedDosage == "جرعتين يومياً" ? 2 : 3);

    if (_nameController.text.trim().isEmpty) {
      showBar(context, "يرجى إدخال اسم الدواء");
      return;
    }

    if (_selectedTimes.length < requiredDoses) {
      showBar(context, "يجب اختيار $requiredDoses مواعيد بناءً على عدد الجرعات المطلوب");
      return;
    } 
    
    if (_selectedTimes.length > requiredDoses) {
      showBar(context, "لقد اخترت مواعيد أكثر من عدد الجرعات ($requiredDoses)");
      return;
    }

    final newAlarm = AlarmEntity(
      id: DateTime.now().toString(),
      medicationName: _nameController.text.trim(),
      reminderTimes: List.from(_selectedTimes),
      dosage: _selectedDosage,
    );
    context.read<AlarmsCubit>().addAlarm(newAlarm);
  }
}