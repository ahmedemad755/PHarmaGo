import 'dart:developer';
import 'package:e_commerce/core/drug_engine/data/egypt_drug_catalog.dart';
import 'package:e_commerce/core/drug_engine/rules/drug_rules.dart';
import 'package:e_commerce/core/drug_engine/services/drug_firestore_service.dart';
import 'package:e_commerce/featchers/chatbot/data/datasource/anthropic_datasource.dart';
import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';
import 'package:e_commerce/featchers/chatbot/domain/repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final AnthropicDataSource anthropicDataSource;
  final DrugFirestoreService firestoreService;

  ChatRepoImpl({
    required this.anthropicDataSource,
    required this.firestoreService,
  });

  @override
  Future<MessageEntity> sendMessage(String message) async {
    // 1. الفحص الأولي للحالات الطارئة (Emergency)
    if (DrugRules.isEmergency(message)) {
      return MessageEntity(
        '🚨 هذه الأعراض قد تكون طارئة وتشير إلى حالة خطرة.\nيرجى التوجه إلى أقرب مستشفى أو الاتصال بالطوارئ فوراً.\n\n⚠️ هذه معلومات إرشادية ولا تغني عن التدخل الطبي العاجل.',
        false,
      );
    }

    // 2. التحقق من أن السؤال طبي ومرتبط بالصيدلية
    if (!DrugRules.looksMedical(message)) {
      return MessageEntity(
        'مرحباً بك! أنا مساعدك الذكي في PharmaGo. يمكنني مساعدتك فقط في الاستفسارات الطبية، الصيدلانية، والأعراض البسيطة (مثل: صداع، برد، مغص، ألم أسنان...).\n\nكيف يمكنني مساعدتك طبياً اليوم؟',
        false,
      );
    }

    // 3. تحديد العرض وعمل المطابقة (Normalization)
    final symptom = DrugRules.normalize(message);
    
    // إذا كان العرض "عدوى" يمنع اقتراح مضاد حيوي تماماً طبقاً لقواعدك
    if (symptom == 'infection') {
      return MessageEntity(
        '⚠️ في حالات اشتباه العدوى، وجود صديد، حرارة مستمرة، أو خراج:\nلا يمكنني اقتراح أي مضادات حيوية تلقائياً؛ لأن استخدامها الخاطئ خطير جداً. يرجى استشارة الطبيب أو الصيدلي لتحديد النوع والجرعة بناءً على الفحص.',
        false,
      );
    }

    // 4. جلب المقترحات الدوائية (محلياً ثم من السيرفر)
    List dynamicDrugs = [];
    if (symptom != null) {
      try {
        final localResults = EgyptDrugCatalog.findBySymptom(symptom);
        if (localResults.isNotEmpty) {
          dynamicDrugs = localResults;
        } else {
          // Fallback للفايرستور في حال عدم وجود أدوية محلياً (مثل الأعراض الجديدة)
          dynamicDrugs = await firestoreService.search(symptom);
        }
      } catch (e) {
        log("Error fetching drugs from catalog/firestore: $e");
      }
    }

    // 5. تمرير البيانات كـ Context إلى الـ AI ليصيغ الإجابة بذكاء
    try {
      final contextPrompt = _buildAiContext(message, symptom, dynamicDrugs);
      final aiResponse = await anthropicDataSource.sendMessage(contextPrompt);
      return MessageEntity(aiResponse, false);
    } catch (e) {
      log("Anthropic AI communication failed, falling back to static presentation: $e");
      
      // خطة بديلة جافة في حال انقطاع الـ API أو الـ Internet
      if (dynamicDrugs.isNotEmpty && symptom != null) {
        return MessageEntity(_buildStaticFallbackResponse(symptom, dynamicDrugs), false);
      }
      
      return MessageEntity(
        '⚠️ عذراً، واجهت مشكلة في الاتصال بمحرك الذكاء الاصطناعي. يرجى التحقق من الإنترنت أو استشارة الصيدلي مباشرة.',
        false,
      );
    }
  }

  // دمج محرك الأدوية مع برومبت الذكاء الاصطناعي للحصول على رد احترافي
  String _buildAiContext(String userMessage, String? symptom, List drugs) {
    final symptomLabel = symptom != null ? DrugRules.labelFor(symptom) : "غير محدد بدقة";
    
    String drugListText = "";
    if (drugs.isNotEmpty) {
      drugListText = drugs.map((d) => "- الاسم: ${d.name} (المادة الفعالة: ${d.genericName})").join("\n");
    } else {
      drugListText = "لا توجد أدوية مقترحة محددة في الكتالوج المحلي لهذا العرض حالياً.";
    }

    return """
User Message: "$userMessage"
Detected Symptom Category: $symptomLabel

Suggested Drugs from our Database:
$drugListText

Instructions for you (The AI):
1. Format a friendly, professional Arabic response answering the user's message.
2. If suggested drugs are provided above, mention them naturally as over-the-counter (OTC) options available in pharmacies for treating "$symptomLabel".
3. If no specific drugs are provided, give safe, general pharmacy advice for this symptom without inventing specific brand names.
4. Always close with a strong medical disclaimer that this is educational and they should consult a doctor or pharmacist.
""";
  }

  // الرد الثابت القديم نتركه هنا كـ Emergency Fallback فقط لو الـ API تعطل تماماً
  String _buildStaticFallbackResponse(String symptom, List drugs) {
    final symptomLabel = DrugRules.labelFor(symptom);
    final buffer = StringBuffer()
      ..writeln('نتائج مقترحة مرتبطة بعرض: $symptomLabel')
      ..writeln();

    for (var i = 0; i < drugs.length; i++) {
      final drug = drugs[i];
      buffer.writeln('${i + 1}. ${drug.name}\n   المادة الفعالة: ${drug.genericName}\n');
    }

    buffer.write('\n⚠️ هذه معلومات عامة مستخرجة تلقائياً، لا تتناول أي دواء دون استشارة الصيدلي.');
    return buffer.toString();
  }
}