import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/drug_engine/data/egypt_drug_catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadHelper {
  static const String _key = 'egypt_drugs_uploaded_v1';

  static Future<void> uploadDrugs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool(_key) == true) {
        return;
      }

      final firestore = FirebaseFirestore.instance;

      for (final drug in EgyptDrugCatalog.allDrugs) {
        await firestore.collection('drugs').doc(_docId(drug.name)).set({
          'name': drug.name,
          'genericName': drug.genericName,
          'symptoms': drug.symptoms,
          'market': 'EG',
        });
      }

      await prefs.setBool(_key, true);
    } catch (error) {
      debugPrint('UploadHelper.uploadDrugs skipped: $error');
    }
  }

  static String _docId(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
