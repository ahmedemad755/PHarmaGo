class DrugRules {
  static const Set<String> supportedSymptoms = {
    'headache', 'fever', 'cold', 'cough', 'sore_throat', 'pain',
    'muscle_pain', 'stomach_pain', 'heartburn', 'diarrhea',
    'constipation', 'nausea', 'allergy', 'skin_allergy',
    'nasal_congestion', 'eye_irritation', 'infection',
    'toothache', 'mouth_ulcers', 'ear_pain', 'menstrual_pain', // إضافات جديدة
  };

  static const Map<String, String> symptomLabels = {
    'headache': 'صداع',
    'fever': 'حرارة',
    'cold': 'برد وأنفلونزا',
    'cough': 'كحة',
    'sore_throat': 'احتقان الحلق',
    'pain': 'ألم عام',
    'muscle_pain': 'ألم عضلات ومفاصل',
    'stomach_pain': 'مغص أو ألم بطن',
    'heartburn': 'حموضة وحرقان معدة',
    'diarrhea': 'إسهال',
    'constipation': 'إمساك',
    'nausea': 'غثيان أو ميل للقيء',
    'allergy': 'حساسية',
    'skin_allergy': 'حساسية جلدية وهرش',
    'nasal_congestion': 'انسداد أو زكام',
    'eye_irritation': 'تهيج أو احمرار العين',
    'infection': 'اشتباه عدوى (التهاب)',
    'toothache': 'ألم أسنان',
    'mouth_ulcers': 'قرح فم',
    'ear_pain': 'ألم أذن',
    'menstrual_pain': 'آلام الدورة الشهرية',
  };

  static const List<String> emergencyKeywords = [
    // التنفس والقلب
    'chest pain', 'shortness of breath', 'cannot breathe', 'heart attack',
    'الم صدر', 'نهجان شديد', 'خناقه', 'مش قادره اخد نفسي', 'رفرفة قلب',
    // الإصابات الخطيرة
    'severe bleeding', 'fainting', 'stroke', 'نزيف', 'غيبوبه', 'فقد وعي',
    // حالات خاصة
    'poisoning', 'swallowed something', 'تسمم', 'شرب مادة', 'انتحار',
    // أطفال
    'high fever baby', 'blue lips', 'حراره طفل رضيع', 'تشنجات', 'ازرقاق',
  ];

  static String? normalize(String input) {
    final normalizedInput = _clean(input);
    for (final entry in _symptomKeywords.entries) {
      if (entry.value.any((keyword) => normalizedInput.contains(keyword))) {
        return entry.key;
      }
    }
    return null;
  }

  static bool isEmergency(String input) {
    final normalizedInput = _clean(input);
    return emergencyKeywords.any(
      (keyword) => normalizedInput.contains(keyword),
    );
  }

  static bool looksMedical(String input) {
    final normalizedInput = _clean(input);
    return _symptomKeywords.values
        .expand((keywords) => keywords)
        .any((keyword) => normalizedInput.contains(keyword));
  }

  static String labelFor(String symptom) {
    return symptomLabels[symptom] ?? symptom;
  }

  static String _clean(String input) {
    return input
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('گ', 'ك') // دعم لبعض اللهجات
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static const Map<String, List<String>> _symptomKeywords = {
    'headache': [
      'صداع',
      'راس بتوجع',
      'دماغ بتوجع',
      'شقيقة',
      'migraine',
      'headache',
    ],
    'fever': ['حراره', 'سخن', 'سخونيه', 'حمي', 'دفيان', 'fever', 'high temp'],
    'cold': [
      'برد',
      'انفلونزا',
      'عطس',
      'زكام',
      'رشح',
      'flu',
      'cold',
      'sneezing',
    ],
    'cough': ['كحه', 'سعال', 'بلغم', 'كحه ناشفه', 'شرقه', 'cough', 'phlegm'],
    'sore_throat': ['زور', 'حلق', 'بلع', 'لوز', 'sore throat', 'throat'],
    'stomach_pain': [
      'بطن',
      'مغص',
      'تقلصات',
      'كرشة نفس',
      'stomach',
      'colic',
      'cramps',
    ],
    'heartburn': [
      'حموضه',
      'حرقان',
      'معده',
      'ارتجاع',
      'نار في صدري',
      'heartburn',
      'acidity',
    ],
    'diarrhea': ['اسهال', 'ليونة', 'تواليت كتير', 'diarrhea'],
    'constipation': ['امساك', 'تحجر', 'صعوبة اخراج', 'constipation'],
    'nausea': [
      'ترجيع',
      'غمام نفس',
      'قرفان',
      'غثيان',
      'عايز ارجع',
      'vomit',
      'nausea',
    ],
    'muscle_pain': [
      'عضلات',
      'مفاصل',
      'ضهري',
      'شد عضلي',
      'روماتيزم',
      'muscle',
      'back pain',
    ],
    'toothache': ['سنان', 'ضرس', 'لثة', 'وجع سنه', 'toothache', 'dental'],
    'mouth_ulcers': ['قرحه', 'فطريات فم', 'قرح فم', 'mouth ulcers'],
    'ear_pain': ['ودني', 'اذن', 'التهاب اذن', 'ear pain'],
    'allergy': ['حساسيه', 'ارتيكاريا', 'هرش', 'حكه', 'rash', 'allergy'],
    'eye_irritation': ['عين', 'رمد', 'دموع كتير', 'عيني حمرا', 'eye'],
    'menstrual_pain': [
      'بريود',
      'دوره شهرية',
      'وجع بريود',
      'period pain',
      'menstrual',
    ],
    'infection': ['عدوي', 'صديد', 'التهاب', 'خراج', 'جرح ملوث', 'infection'],
  };
}
