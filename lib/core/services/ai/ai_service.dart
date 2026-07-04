// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class AiService {
//   final String _apiKey = "AIzaSyACPKd-D2WOOalRNSw6kh77-YIKVNcuybk";

//   // التغيير هنا: استخدام v1 (المستقر) بدل v1beta + موديل gemini-pro
//   static const String _url =
//       'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

//   Future<String> sendMessage(String message) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('$_url?key=$_apiKey'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               "contents": [
//                 {
//                   "parts": [
//                     {"text": message},
//                   ],
//                 },
//               ],
//             }),
//           )
//           .timeout(const Duration(seconds: 15));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['candidates'][0]['content']['parts'][0]['text'];
//       } else {
//         // لو لسه مطلع أيرور، اطبع لنا الـ Body كامل هنا
//         debugPrint("❌ Final Debug: ${response.statusCode} - ${response.body}");
//         return "❌ خطأ في السيرفر: ${response.statusCode}";
//       }
//     } catch (e) {
//       return "⚠️ مشكلة اتصال: $e";
//     }
//   }
// }
