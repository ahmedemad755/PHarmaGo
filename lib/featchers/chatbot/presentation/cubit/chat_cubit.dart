import 'package:e_commerce/core/drug_engine/data/egypt_drug_catalog.dart';
import 'package:e_commerce/core/drug_engine/models/drug_model.dart';
import 'package:e_commerce/core/drug_engine/rules/drug_rules.dart';
import 'package:e_commerce/core/drug_engine/services/drug_firestore_service.dart';
import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final DrugFirestoreService firestoreService;

  ChatCubit(this.firestoreService)
      : super(ChatLoaded(messages: List.unmodifiable(_initialMessages)));

  static final List<MessageEntity> _initialMessages = [
    MessageEntity(
      'أهلا بك في PharmaGo AI.\nاكتب العرض الذي تشعر به مثل: عندي صداع، I have fever، أو عندي برد.',
      false,
    ),
  ];

  final List<MessageEntity> _messages = List.of(_initialMessages);

  Future<void> send(String text) async {
    final message = text.trim();
    if (message.isEmpty) return;

    _addMessage(MessageEntity(message, true), isTyping: true);

    if (DrugRules.isEmergency(message)) {
      _addBotMessage(
        'هذه الأعراض قد تكون طارئة. يرجى التوجه إلى أقرب مستشفى أو الاتصال بالطوارئ فورا.\n\nهذه معلومات عامة ولا تغني عن الطبيب.',
      );
      return;
    }

    if (!DrugRules.looksMedical(message)) {
      _addBotMessage(
        'أقدر أساعدك فقط في أسئلة الصيدلية والأعراض البسيطة. اكتب عرضا طبيا مثل صداع، حرارة، برد، حساسية، أو ألم.',
      );
      return;
    }

    final symptom = DrugRules.normalize(message);
    if (symptom == null) {
      _addBotMessage(
        'لم أقدر أحدد العرض بوضوح. جرب تكتبه بشكل أبسط مثل: عندي صداع، عندي حرارة، عندي برد، أو I have allergy.\n\n⚠️ هذه معلومات عامة ولا تغني عن استشارة الطبيب أو الصيدلي.',
      );
      return;
    }

    try {
      final egyptResults = EgyptDrugCatalog.findBySymptom(symptom);
      final results = egyptResults.isNotEmpty
          ? egyptResults
          : await firestoreService.search(symptom);

      if (results.isEmpty) {
        _addBotMessage(
          'لم أجد منتجا مصريا مناسبا لهذا العرض حاليا. حاول وصف العرض بطريقة أخرى أو اسأل الصيدلي.\n\n⚠️ هذه معلومات عامة ولا تغني عن استشارة الطبيب أو الصيدلي.',
        );
        return;
      }

      _addBotMessage(_buildDrugResponse(symptom, results));
    } catch (_) {
      _addBotMessage(
        'حدث خطأ أثناء البحث عن الأدوية. تأكد من اتصال الإنترنت وحاول مرة أخرى.\n\n⚠️ في الحالات الطارئة يرجى التوجه لأقرب مستشفى.',
      );
    }
  }

  void _addMessage(MessageEntity message, {bool isTyping = false}) {
    _messages.add(message);
    _emitLoaded(isTyping: isTyping);
  }

  void _addBotMessage(String text) {
    _messages.add(MessageEntity(text, false));
    _emitLoaded();
  }

  void _emitLoaded({bool isTyping = false}) {
    emit(
      ChatLoaded(
        messages: List.unmodifiable(_messages),
        isTyping: isTyping,
      ),
    );
  }

  String _buildDrugResponse(String symptom, List<DrugModel> drugs) {
    if (symptom == 'infection') {
      return 'في حالة وجود التهاب، صديد، خراج، أو اشتباه عدوى: لا ينفع اقتراح مضاد حيوي تلقائيا.\n\nالأفضل مراجعة طبيب أو صيدلي لتحديد السبب والجرعة المناسبة، خصوصا لو في حرارة عالية، تورم، ألم شديد، أو الأعراض مستمرة.';
    }

    final symptomLabel = DrugRules.labelFor(symptom);
    final buffer = StringBuffer()
      ..writeln('نتائج مصرية مرتبطة بعرض: $symptomLabel')
      ..writeln();

    for (var i = 0; i < drugs.length; i++) {
      final drug = drugs[i];
      buffer
        ..writeln('${i + 1}. ${drug.name}')
        ..writeln('المادة الفعالة: ${drug.genericName}');

      if (i != drugs.length - 1) {
        buffer.writeln();
      }
    }

    buffer
      ..writeln()
      ..write(
        _warningFor(symptom),
      );

    return buffer.toString();
  }

  String _warningFor(String symptom) {
    if (symptom == 'diarrhea') {
      return '⚠️ اهتم بالسوائل. لو في دم، جفاف، حرارة عالية، أو إسهال شديد مستمر، راجع طبيب فورا.';
    }

    if (symptom == 'fever') {
      return '⚠️ لو الحرارة عالية جدا، مستمرة أكثر من يومين، أو لطفل صغير، لازم مراجعة طبيب.';
    }

    if (symptom == 'cough') {
      return '⚠️ لو في ضيق تنفس، ألم صدر، دم مع الكحة، أو الكحة مستمرة، راجع طبيب.';
    }

    return '⚠️ المنتجات قد تختلف حسب التوفر في الصيدلية. لا تبدأ أو توقف أي دواء بدون الرجوع للطبيب أو الصيدلي، خصوصا مع الحمل، الحساسية، الأمراض المزمنة، أو أدوية أخرى.';
  }
}
