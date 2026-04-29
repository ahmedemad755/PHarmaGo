# PharmaGo Chatbot Feature

## 1. فكرة الفيتشر

الشات بوت في **PharmaGo** مساعد صيدلي بسيط يساعد المستخدم في وصف أعراض عامة ثم يعرض منتجات دوائية متداولة في السوق المصري قدر الإمكان.

الهدف الحالي:

- المستخدم يكتب عرض مثل: `عندي صداع`، `حاسس بمغص شديد`، `I have fever`.
- النظام يحول النص إلى symptom ثابت مثل: `headache`، `stomach_pain`، `fever`.
- البوت يعرض أولا منتجات من كتالوج مصري داخلي.
- لو لم توجد نتيجة في الكتالوج، يستخدم Firestore كـ fallback.
- يمنع تكرار المنتجات ويستبعد بيانات `Unknown`.
- في حالات العدوى أو الحالات الطارئة، لا يقترح علاج تلقائيا ويعرض رسالة أمان.
- كل رد يحتوي على تنبيه أن المعلومات عامة ولا تغني عن الطبيب أو الصيدلي.

> مهم: البوت لا يشخص مرضا ولا يكتب روشتة، لكنه يعرض معلومات عامة ومنتجات محتملة فقط.

---

## 2. المكونات المستخدمة

- Flutter
- Bloc / Cubit
- Firebase Firestore
- SharedPreferences
- getIt Dependency Injection
- كتالوج داخلي للمنتجات المصرية
- Routing الموجود في `generateRoute`

لم يعد OpenFDA هو مصدر الاقتراحات الأساسي، لأن نتائجه كانت تعرض أدوية غير مناسبة للسوق المصري أو سجلات باسم `Unknown`.

---

## 3. هيكلة الملفات الحالية

```text
lib/
├── core/
│   ├── drug_engine/
│   │   ├── data/
│   │   │   └── egypt_drug_catalog.dart
│   │   ├── models/
│   │   │   └── drug_model.dart
│   │   ├── rules/
│   │   │   └── drug_rules.dart
│   │   └── services/
│   │       └── drug_firestore_service.dart
│   └── functions_helper/
│       └── upload_helper.dart
│
└── featchers/
    ├── chatbot/
    │   ├── domain/
    │   │   └── entitys/
    │   │       └── message_entity.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── chat_cubit.dart
    │       │   └── chat_state.dart
    │       └── views/
    │           └── chat_screen.dart
    └── home/
        └── presentation/views/widgets/
            └── chatbootView.dart
```

> ملاحظة: اسم folder في المشروع هو `featchers` وليس `features`، لذلك حافظنا على نفس الاسم.

---

## 4. شرح الملفات

### 4.1 `drug_model.dart`

المسار:

```text
lib/core/drug_engine/models/drug_model.dart
```

يمثل شكل الدواء داخل التطبيق:

- `name`: اسم المنتج التجاري.
- `genericName`: المادة الفعالة.
- `symptoms`: الأعراض المرتبطة بالمنتج.

تم إضافة getter:

```dart
bool get hasReadableNames
```

الغرض منه فلترة أي سجل ناقص أو يحتوي على:

- `Unknown`
- `Unknown drug`
- `Unknown generic name`
- قيمة فارغة

مثال:

```json
{
  "name": "CETAL 500 mg",
  "genericName": "Paracetamol 500 mg",
  "symptoms": ["headache", "fever", "pain"],
  "market": "EG"
}
```

---

### 4.2 `drug_rules.dart`

المسار:

```text
lib/core/drug_engine/rules/drug_rules.dart
```

هذا الملف مسؤول عن فهم النص وتحويله إلى symptom ثابت.

يدعم الآن أعراض أكثر، منها:

- `headache`: صداع
- `fever`: حرارة / حراره / سخونية
- `cold`: برد / رشح / زكام
- `cough`: كحة / سعال / بلغم
- `sore_throat`: احتقان أو ألم الحلق
- `stomach_pain`: مغص / وجع بطن
- `heartburn`: حموضة / ارتجاع
- `diarrhea`: إسهال
- `constipation`: إمساك
- `nausea`: قيء / ترجيع / غثيان
- `muscle_pain`: ألم عضلات / ألم ظهر / ألم مفاصل
- `allergy`: حساسية
- `skin_allergy`: هرش / طفح / حساسية جلد
- `nasal_congestion`: انسداد الأنف
- `eye_irritation`: تهيج العين
- `infection`: التهاب / صديد / عدوى

أمثلة:

```text
"عندي حراره"        => fever
"حاسس بمغص شديد"   => stomach_pain
"عندي كحة وبلغم"   => cough
"I have heartburn" => heartburn
```

يوجد أيضا:

- `isEmergency`: يلتقط الحالات الطارئة مثل ألم الصدر، ضيق التنفس الشديد، النزيف، التشنجات.
- `looksMedical`: يمنع الرد على الأسئلة غير الطبية.
- `labelFor`: يعرض اسم العرض بالعربي داخل الرد.

---

### 4.3 `egypt_drug_catalog.dart`

المسار:

```text
lib/core/drug_engine/data/egypt_drug_catalog.dart
```

هذا هو المصدر الأساسي الحالي لاقتراحات الأدوية.

الفكرة:

- كتالوج داخلي curated لمنتجات متداولة في مصر.
- البحث يتم حسب symptom.
- يتم إزالة التكرار قبل العرض.
- يعرض أول 3 نتائج فقط.

أمثلة من الكتالوج:

```text
headache:
- CETAL 500 mg
- Cetal Extra
- ALFAMOL 500 mg

stomach_pain:
- Spasmofen
- Buscopan
- Colona

diarrhea:
- Antinal
- Smecta
- Rehydran-N

allergy:
- MOSEDIN 10 mg
- DESA 5 mg
- BREVY 5 mg
```

ملاحظة مهمة:

```text
infection
```

لا يعرض مضاد حيوي تلقائيا. يظهر للمستخدم أن العدوى تحتاج طبيب أو صيدلي.

---

### 4.4 `drug_firestore_service.dart`

المسار:

```text
lib/core/drug_engine/services/drug_firestore_service.dart
```

يستخدم كـ fallback بعد الكتالوج المصري.

طريقة البحث:

```dart
collection('drugs')
  .where('symptoms', arrayContains: symptom)
  .limit(20)
  .get();
```

ثم تتم الفلترة:

- الاسم والمادة الفعالة يجب ألا يكونا `Unknown`.
- السجل يجب أن يحتوي على:

```json
"market": "EG"
```

ثم يعرض أول 3 نتائج فقط.

السبب:

الداتا القديمة من OpenFDA كانت تحتوي على منتجات غير مناسبة للسوق المصري وأسماء ناقصة.

---

### 4.5 `upload_helper.dart`

المسار:

```text
lib/core/functions_helper/upload_helper.dart
```

لم يعد يرفع بيانات OpenFDA.

الوظيفة الحالية:

- يأخذ كل المنتجات من `EgyptDrugCatalog.allDrugs`.
- يرفعها في Firestore داخل collection:

```text
drugs
```

- يضيف field:

```json
"market": "EG"
```

- يستخدم `SharedPreferences` لمنع الرفع المتكرر:

```dart
static const String _key = 'egypt_drugs_uploaded_v1';
```

---

### 4.6 `chat_cubit.dart`

المسار:

```text
lib/featchers/chatbot/presentation/cubit/chat_cubit.dart
```

مسؤول عن منطق المحادثة:

1. يستقبل رسالة المستخدم.
2. يضيفها إلى قائمة الرسائل.
3. يفحص هل الرسالة طارئة.
4. يفحص هل الرسالة طبية.
5. يحول النص إلى symptom باستخدام `DrugRules.normalize`.
6. يبحث أولا في `EgyptDrugCatalog`.
7. لو لم يجد نتيجة، يستخدم `DrugFirestoreService`.
8. يبني رد آمن للمستخدم.

الترتيب الحالي:

```text
User message
↓
DrugRules emergency / medical guard
↓
DrugRules.normalize
↓
EgyptDrugCatalog.findBySymptom
↓
Firestore fallback if needed
↓
Safe bot response
```

---

### 4.7 `chat_state.dart`

المسار:

```text
lib/featchers/chatbot/presentation/cubit/chat_state.dart
```

الحالات:

- `ChatInitial`
- `ChatLoaded`

`ChatLoaded` يحتوي على:

```dart
final List<MessageEntity> messages;
final bool isTyping;
```

`isTyping` يستخدم لإظهار أن البوت يبحث عن نتيجة.

---

### 4.8 `chat_screen.dart`

المسار:

```text
lib/featchers/chatbot/presentation/views/chat_screen.dart
```

واجهة المحادثة:

- `AppBar`
- `ListView` للرسائل
- bubble للمستخدم والبوت
- مؤشر كتابة بسيط
- شريط تنبيه طبي ثابت
- TextField للإرسال
- زر إرسال

الإرسال يتم عبر:

```dart
context.read<ChatCubit>().send(text);
```

---

### 4.9 `chatbootView.dart`

المسار:

```text
lib/featchers/home/presentation/views/widgets/chatbootView.dart
```

شاشة الدخول للشات بوت.

عند الضغط على زر بدء الاستشارة:

```dart
await UploadHelper.uploadDrugs();
Navigator.pushNamed(context, AppRoutes.ChatbootBody);
```

تمت إضافة:

- loading state
- منع الضغط المتكرر
- رسالة خطأ لو فشل تجهيز البيانات
- تنبيه طبي واضح قبل الدخول للشات

---

## 5. شكل البيانات في Firestore

Collection:

```text
drugs
```

Document example:

```json
{
  "name": "CETAL 500 mg",
  "genericName": "Paracetamol 500 mg",
  "symptoms": ["headache", "fever", "pain"],
  "market": "EG"
}
```

Field `market: EG` مهم جدا لأنه يمنع رجوع بيانات قديمة غير مصرية.

---

## 6. أمثلة استخدام

### مثال 1

Input:

```text
عندي صداع
```

Normalize:

```text
headache
```

Response:

```text
نتائج مصرية مرتبطة بعرض: صداع

1. CETAL 500 mg
المادة الفعالة: Paracetamol 500 mg

2. Cetal Extra
المادة الفعالة: Paracetamol 500 mg + Caffeine 65 mg

⚠️ المنتجات قد تختلف حسب التوفر في الصيدلية...
```

### مثال 2

Input:

```text
حاسس بمغص شديد
```

Normalize:

```text
stomach_pain
```

Response examples:

```text
Spasmofen
Buscopan
Colona
```

### مثال 3

Input:

```text
عندي حراره
```

Normalize:

```text
fever
```

Response examples:

```text
CETAL 500 mg
Fevano Syrup
PARACETAMOL CID
```

### مثال 4

Input:

```text
عندي التهاب وصديد
```

Normalize:

```text
infection
```

Response:

```text
لا يتم اقتراح مضاد حيوي تلقائيا.
راجع طبيب أو صيدلي لتحديد السبب والجرعة المناسبة.
```

### مثال 5

Input:

```text
مين كسب الماتش؟
```

Response:

```text
أقدر أساعدك فقط في أسئلة الصيدلية والأعراض البسيطة...
```

---

## 7. Routing

في `generateRoute`:

```dart
case AppRoutes.ChatbootBody:
  return authGuard(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => getIt<ChatCubit>(),
        child: const ChatScreen(),
      ),
    ),
  );
```

الغرض:

- `ChatScreen` يحتاج `ChatCubit`.
- `ChatCubit` يحتاج `DrugFirestoreService`.
- حقن الاعتمادات يتم من `getIt`.

---

## 8. Dependency Injection

في `injection.dart`:

```dart
getIt.registerLazySingleton(() => FirebaseFirestore.instance);

getIt.registerLazySingleton(
  () => DrugFirestoreService(getIt<FirebaseFirestore>()),
);

getIt.registerFactory(
  () => ChatCubit(getIt<DrugFirestoreService>()),
);
```

---

## 9. نقاط الأمان الطبي

- البوت لا يشخص مرضا.
- البوت لا يكتب روشتة نهائية.
- البوت لا يقترح مضادا حيويا تلقائيا.
- الحالات الطارئة يتم توجيهها للطوارئ.
- النتائج معلومات عامة فقط.
- يجب الرجوع لطبيب أو صيدلي قبل استخدام أي دواء.
- يجب الحذر مع الحمل، الأطفال، كبار السن، الأمراض المزمنة، الحساسية، أو أدوية أخرى.

---

## 10. لماذا توقفنا عن OpenFDA؟

OpenFDA مفيد كمصدر بيانات عالمي، لكنه غير مناسب كمصدر اقتراحات مباشر لهذا التطبيق لأن:

- يعرض منتجات غير موجودة غالبا في مصر.
- بعض السجلات لا تحتوي على اسم واضح.
- ظهر للمستخدم `Unknown`.
- بعض النتائج كانت مكررة.
- لا يضمن أن المنتج متداول في السوق المصري.

لذلك أصبح النظام الحالي:

```text
EgyptDrugCatalog
↓
Firestore EG fallback
↓
Safe response
```

---

## 11. مصادر مرجعية استخدمت لاختيار اتجاه الكتالوج

- Egyptian Drug Authority OTC list:
  https://www.edaegypt.gov.eg/media/21edqngj/otc.pdf

- ECMI Pharmaceutical Database:
  https://www.ecmi-eg.org/ecmi-pharmaceutical-database/

> الكتالوج الحالي ليس بديلا عن مراجعة صيدلي، ويحتاج مراجعة نهائية قبل production.

---

## 12. تحسينات مقترحة للمرحلة القادمة

1. إضافة كتالوج أكبر من مصدر مصري موثوق أو Admin Panel.
2. إضافة جرعات حسب العمر والوزن بعد مراجعة طبية.
3. إضافة user medical profile: الحساسية، الحمل، الأمراض المزمنة.
4. إضافة drug interaction checker.
5. إضافة OCR للروشتة.
6. نقل إدارة المنتجات إلى backend أو Cloud Function.
7. تنظيف Firestore من سجلات OpenFDA القديمة التي لا تحتوي على `market: EG`.

---

## 13. ملخص سريع

الشات بوت الآن يعمل بهذا الشكل:

```text
User message
↓
DrugRules.normalize
↓
EgyptDrugCatalog.findBySymptom
↓
Firestore fallback with market: EG
↓
Egyptian product suggestions
↓
Safe medical warning
```

النسخة الحالية مناسبة كـ prototype أقوى للسوق المصري، لكنها تحتاج مراجعة صيدلية/طبية قبل الاستخدام الإنتاجي.
