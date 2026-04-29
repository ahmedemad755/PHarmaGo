import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenFdaService {
  static Future<List<Map<String, dynamic>>> fetch() async {
    final res = await http.get(
      Uri.parse("https://api.fda.gov/drug/label.json?limit=50"),
    );

    final data = json.decode(res.body);

    return List<Map<String, dynamic>>.from(data["results"]);
  }
}
