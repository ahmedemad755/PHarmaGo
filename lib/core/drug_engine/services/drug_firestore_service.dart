import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/drug_engine/models/drug_model.dart';

class DrugFirestoreService {
  final FirebaseFirestore firestore;

  DrugFirestoreService(this.firestore);

  Future<List<DrugModel>> search(String symptom) async {
    final snapshot = await firestore
        .collection('drugs')
        .where('symptoms', arrayContains: symptom)
        .limit(20)
        .get();

    final drugs = <DrugModel>[];

for (final doc in snapshot.docs) {
  final data = doc.data();
  final drug = DrugModel.fromJson(data);

  // حذف شرط market == 'EG' مؤقتاً لأن الـ Data المرفوعة من الـ FDA لا تحتوي عليه
  if (drug.hasReadableNames && drug.name.toLowerCase() != 'unknown') {
    drugs.add(drug);
  }

  if (drugs.length == 3) break;
}

    return drugs;
  }
}
