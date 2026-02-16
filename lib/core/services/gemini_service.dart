import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart'; // مهم عشان debugPrint
import 'package:e_commerce/core/utils/app_key.dart' as ApiKeys;
import 'package:e_commerce/featchers/home/domain/enteties/medicine_entity.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

GeminiService() {
  _model = GenerativeModel(
    // جرب تغيير المسمى لهذا الشكل الدقيق
    model: 'gemini-1.5-flash', 
    apiKey: ApiKeys.geminiApiKey,
    // إضافة الـ Safety Settings والـ Config تضمن أن المكتبة تستخدم البروتوكول الصحيح
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
    ),
  );
}

  Future<List<MedicineEntity>> analyzeImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();

      const prompt = """
        Identify medicines in this prescription. 
        Return ONLY a raw JSON array like this:
        [{"name": "medicine_name", "dose": "strength", "frequency": "times per day"}]
        If no medicines, return [].
      """;

      final String mimeType = imageFile.path.endsWith('.png') ? 'image/png' : 'image/jpeg';

      final response = await _model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart(mimeType, imageBytes),
        ])
      ]);

      final textResponse = response.text;
      if (textResponse == null || textResponse.isEmpty) throw Exception("رد فارغ من الذكاء الاصطناعي");

      // استخراج الـ JSON باستخدام Regex لضمان الدقة
      final jsonRegExp = RegExp(r'\[.*\]', dotAll: true);
      final match = jsonRegExp.stringMatch(textResponse);

      if (match != null) {
        final List<dynamic> decodedList = jsonDecode(match);
        return decodedList.map((e) => MedicineEntity(
          name: e['name']?.toString() ?? 'Unknown',
          dose: e['dose']?.toString() ?? '',
          frequency: e['frequency']?.toString() ?? '',
        )).toList();
      } else {
        return [];
      }

    } catch (e) {
      debugPrint("++++++===============Full Error Log: $e");
      // غيرنا الرسالة عشان تكون معبرة أكتر لو لسه فيه مشكلة في الموديل
      if (e.toString().contains('not found')) {
         throw Exception("الموديل المختار غير مدعوم، جرب تحديث مكتبة Google AI");
      }
      throw Exception("فشل في معالجة النص المستخرج");
    }
  }
}