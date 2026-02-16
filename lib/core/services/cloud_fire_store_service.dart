import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/services/database_service.dart';

class FireStoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    await firestore.collection(path).doc(documentId).set(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  }) async {
    if (docuementId != null) {
      var data = await firestore.collection(path).doc(docuementId).get();
      return data.data() != null ? [data.data()!] : [];
    } else {
      Query<Map<String, dynamic>> data = firestore.collection(path);
      if (query != null) {
        if (query['orderBy'] != null) {
          var orderByField = query['orderBy'];
          var descending = query['descending'];
          data = data.orderBy(orderByField, descending: descending);
        }
        if (query['limit'] != null) {
          var limit = query['limit'];
          data = data.limit(limit);
        }
      }
      var result = await data.get();
      return result.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<void> setData({
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(path).doc(id).set(data, SetOptions(merge: true));
  }

  @override
  Future<bool> checkIfDataExists({
    required String documentId,
    required String path,
  }) async {
    final doc = await firestore.collection(path).doc(documentId).get();
    return doc.exists;
  }
  
@override
Stream<List<Map<String, dynamic>>> getCollectionStream({
  required String path,
  Query Function(Query query)? query, // تأكد من استخدام Query هنا
}) {
  Query collection = firestore.collection(path);
  
  if (query != null) {
    // هنا نقوم بتنفيذ الفلترة
    return query(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
  
  return firestore.collection(path).snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList();
  });
}

  @override
  Future<void> updateData({required String path, required String documentId, required Map<String, dynamic> data}) async{
await firestore.collection(path).doc(documentId).update(data);
  }
}
