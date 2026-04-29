import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await uploadDrugs();

  print("✅ Upload Done");
}

Future<void> uploadDrugs() async {
  final firestore = FirebaseFirestore.instance;

  for (int i = 0; i < 500; i += 50) {
    final response = await http.get(
      Uri.parse("https://api.fda.gov/drug/label.json?limit=50&skip=$i"),
    );

    final data = json.decode(response.body);

    for (var item in data["results"]) {
      final name = item["openfda"]?["brand_name"]?[0] ?? "Unknown";
      final generic = item["openfda"]?["generic_name"]?[0] ?? "Unknown";

      final text = (item["indications_and_usage"] != null)
          ? item["indications_and_usage"][0].toString().toLowerCase()
          : "";

      List<String> symptoms = [];

      if (text.contains("pain")) symptoms.add("pain");
      if (text.contains("fever")) symptoms.add("fever");
      if (text.contains("headache")) symptoms.add("headache");
      if (text.contains("infection")) symptoms.add("infection");

      if (symptoms.isEmpty) continue;

      await firestore.collection("drugs").add({
        "name": name,
        "genericName": generic,
        "symptoms": symptoms,
      });
    }

    print("Uploaded batch $i");
  }
}
