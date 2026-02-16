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
          title: const GradientText(
            "منبه الدواء",
            gradient: AppColors.accentGradient2,
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: alarms.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return Dismissible(
                    key: Key(alarm.id),
                    direction: DismissDirection.horizontal,
                    background: _buildDeleteBackground(Alignment.centerRight),
                    secondaryBackground: _buildDeleteBackground(Alignment.centerLeft),
                    confirmDismiss: (direction) async => await _showDeleteConfirmation(context),
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

  Widget _buildDeleteBackground(Alignment alignment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.white,
        title: const Text("حذف المنبه", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("هل أنت متأكد من رغبتك في حذف هذا المنبه؟", textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("إلغاء", style: TextStyle(color: AppColors.darkGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_active_outlined, size: 80, color: AppColors.primary.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          const Text(
            "لا توجد منبهات حالياً",
            style: TextStyle(color: AppColors.darkBlue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("ابدأ بإضافة أول منبه لجرعاتك", style: TextStyle(color: AppColors.mediumGray)),
          const SizedBox(height: 40),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildActionArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(child: Center(child: _buildAddButton(context))),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GradientButton(
      label: "إضافة منبه جديد",
      width: MediaQuery.of(context).size.width * 0.7,
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
        builder: (_) => BlocProvider.value(value: cubit, child: const AddAlarmView()),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.medicationName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
                ),
                Text(alarm.dosage, style: const TextStyle(color: AppColors.mediumGray, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: alarm.reminderTimes
                .map((t) => Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.activeBg, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        DateFormat.jm().format(t),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
                      ),
                    ))
                .toList(),
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
          title: const Text("إضافة منبه جديد", style: TextStyle(fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 16),
              _buildTextField(),
              const SizedBox(height: 20),
              _buildDosageDropdown(),
              const SizedBox(height: 32),
              _buildSectionTitle("مواعيد التذكير"),
              const SizedBox(height: 8),
              _buildDoseHint(requiredDoses),
              const SizedBox(height: 12),
              _buildTimePickerTile(context),
              const SizedBox(height: 12),
              _buildTimeChips(),
              const SizedBox(height: 60),
              Center(child: _buildSaveButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoseHint(int requiredDoses) {
    bool isComplete = _selectedTimes.length == requiredDoses;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "يرجى اختيار عدد ($requiredDoses) مواعيد بناءً على الجرعة",
        style: TextStyle(color: isComplete ? Colors.green : AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue));
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: "اسم الدواء (مثال: بنادول)",
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(Icons.medication_rounded, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderColor)),
      ),
    );
  }

  Widget _buildDosageDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedDosage,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderColor)),
      ),
      items: ["جرعة واحدة يومياً", "جرعتين يومياً", "3 جرعات يومياً"]
          .map((label) => DropdownMenuItem(value: label, child: Text(label)))
          .toList(),
      onChanged: (value) => setState(() {
        _selectedDosage = value!;
        _selectedTimes.clear();
      }),
    );
  }

  Widget _buildTimePickerTile(BuildContext context) {
    return InkWell(
      onTap: () => _pickTime(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderColor)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("إضافة موعد تذكير جديد", style: TextStyle(color: AppColors.mediumGray)),
            Icon(Icons.add_circle_outline, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChips() {
    return Wrap(
      spacing: 8,
      children: _selectedTimes
          .map((t) => Chip(
                backgroundColor: AppColors.activeBg,
                label: Text(DateFormat.jm().format(t), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                onDeleted: () => setState(() => _selectedTimes.remove(t)),
                deleteIconColor: AppColors.errorColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: AppColors.primaryMid)),
              ))
          .toList(),
    );
  }

  Widget _buildSaveButton() {
    return GradientButton(
      label: "حفظ المنبه",
      gradientColors: AppColors.getAccentGradientByPage(2).colors.toList(),
      onPressed: _saveAlarm,
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
}