import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    required String documentId,
  });

  Future<dynamic> getData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  });

Stream<List<Map<String, dynamic>>> getCollectionStream({
  required String path,
  // تأكد أن النوع هنا Query من مكتبة cloud_firestore
  Query Function(Query query)? query, 
});

  Future<void> setData({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  });

  Future<bool> checkIfDataExists({
    required String documentId,
    required String path,
  });

  Future<void> updateData({
  required String path,
  required String documentId,
  required Map<String, dynamic> data,
});
}
