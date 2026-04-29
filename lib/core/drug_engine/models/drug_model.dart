class DrugModel {
  final String name;
  final String genericName;
  final List<String> symptoms;

  const DrugModel({
    required this.name,
    required this.genericName,
    required this.symptoms,
  });

  bool get hasReadableNames {
    return !_isUnknown(name) && !_isUnknown(genericName);
  }

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? (json['name'] as String).trim()
          : 'Unknown drug',
      genericName: (json['genericName'] as String?)?.trim().isNotEmpty == true
          ? (json['genericName'] as String).trim()
          : 'Unknown generic name',
      symptoms:
          (json['symptoms'] as List<dynamic>?)
              ?.map((symptom) => symptom.toString())
              .toList() ??
          const [],
    );
  }

  static bool _isUnknown(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized == 'unknown' ||
        normalized == 'unknown drug' ||
        normalized == 'unknown generic name';
  }
}
