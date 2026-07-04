class MedicalRule {
  final String conditionId;
  final List<String> targetValues; // القيم التي تفعّل القاعدة (مثلاً: "عالي")
  final List<String> restrictedIngredients; // المواد المحظورة
  final String warningMessage;

  MedicalRule({
    required this.conditionId,
    required this.targetValues,
    required this.restrictedIngredients,
    required this.warningMessage,
  });

  factory MedicalRule.fromFirestore(Map<String, dynamic> data) {
    return MedicalRule(
      conditionId: data['condition_id'],
      targetValues: List<String>.from(data['target_values']),
      restrictedIngredients: List<String>.from(data['restricted_ingredients']),
      warningMessage: data['warning_message'],
    );
  }
}