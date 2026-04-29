import '../models/drug_model.dart';

class DrugEngine {
  List<DrugModel> drugs;

  DrugEngine(this.drugs);

  List<DrugModel> recommend(String symptom) {
    return drugs.where((d) => d.symptoms.contains(symptom)).toList();
  }
}
