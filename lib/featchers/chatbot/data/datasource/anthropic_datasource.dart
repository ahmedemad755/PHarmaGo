import 'dart:convert';
import 'package:http/http.dart' as http;

class AnthropicDataSource {
  final String apiKey;

  AnthropicDataSource(this.apiKey);

  Future<String> sendMessage(String userMessage) async {
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

    final data = jsonDecode(response.body);
    return data["content"][0]["text"];
  }

  static const String _prompt = """
You are a pharmacy assistant.

Rules:
- Only answer medical/pharmacy questions
- Give safe advice
- Suggest alternatives
- No diagnosis
""";
}
