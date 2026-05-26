import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AnthropicDataSource {
  final String apiKey;

  AnthropicDataSource(this.apiKey);

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.anthropic.com/v1/messages"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey,
          "anthropic-version": "2023-06-01",
        },
        body: jsonEncode({
          "model": "claude-3-sonnet-20240229",
          "max_tokens": 400,
          "system": _prompt,
          "messages": [
            {"role": "user", "content": userMessage},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["content"][0]["text"] ?? "لم أتمكن من استيعاب النص حالياً.";
      } else {
        log("Anthropic API Error: ${response.statusCode} - ${response.body}");
        throw Exception("فشل الاتصال بمحرك الذكاء الاصطناعي");
      }
    } catch (e, stackTrace) {
      log("Exception in AnthropicDataSource: $e", stackTrace: stackTrace);
      rethrow;
    }
  }

  static const String _prompt = """
You are a pharmacy assistant in an app called PharmaGo.
Rules:
- Only answer medical/pharmacy questions.
- Give safe advice and always tell the user this is for educational purposes.
- Suggest alternatives if applicable.
- No direct medical diagnosis.
- Answer in Arabic naturally.
""";
}