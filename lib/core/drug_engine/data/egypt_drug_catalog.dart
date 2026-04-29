import 'package:e_commerce/core/drug_engine/models/drug_model.dart';

class EgyptDrugCatalog {
  static List<DrugModel> findBySymptom(String symptom) {
    final drugs = _drugsBySymptom[symptom] ?? const <DrugModel>[];
    final seen = <String>{};

    return drugs.where((drug) {
      final key = '${drug.name}|${drug.genericName}'.toLowerCase();
      return seen.add(key);
    }).take(3).toList();
  }

  static List<DrugModel> get allDrugs {
    final seen = <String>{};
    return _drugsBySymptom.values
        .expand((drugs) => drugs)
        .where((drug) {
          final key = '${drug.name}|${drug.genericName}'.toLowerCase();
          return seen.add(key);
        })
        .toList();
  }

  static const Map<String, List<DrugModel>> _drugsBySymptom = {
    'headache': [
      DrugModel(
        name: 'CETAL 500 mg',
        genericName: 'Paracetamol 500 mg',
        symptoms: ['headache', 'fever', 'pain'],
      ),
      DrugModel(
        name: 'Cetal Extra',
        genericName: 'Paracetamol 500 mg + Caffeine 65 mg',
        symptoms: ['headache', 'pain'],
      ),
      DrugModel(
        name: 'ALFAMOL 500 mg',
        genericName: 'Paracetamol 500 mg',
        symptoms: ['headache', 'fever', 'pain'],
      ),
    ],
    'fever': [
      DrugModel(
        name: 'CETAL 500 mg',
        genericName: 'Paracetamol 500 mg',
        symptoms: ['headache', 'fever', 'pain'],
      ),
      DrugModel(
        name: 'Fevano Syrup',
        genericName: 'Paracetamol syrup',
        symptoms: ['fever', 'pain'],
      ),
      DrugModel(
        name: 'PARACETAMOL CID',
        genericName: 'Paracetamol 500 mg',
        symptoms: ['fever', 'headache', 'pain'],
      ),
    ],
    'cold': [
      DrugModel(
        name: 'Cetal Cold & Flu',
        genericName:
            'Paracetamol 500 mg + Pseudoephedrine 30 mg + Chlorpheniramine 2 mg',
        symptoms: ['cold', 'fever'],
      ),
      DrugModel(
        name: 'CETAL SINUS',
        genericName: 'Paracetamol 500 mg + Pseudoephedrine 30 mg',
        symptoms: ['cold', 'headache', 'nasal_congestion'],
      ),
      DrugModel(
        name: 'FEVANO COLD',
        genericName:
            'Paracetamol 650 mg + Pseudoephedrine 60 mg + Chlorpheniramine 4 mg',
        symptoms: ['cold', 'fever'],
      ),
    ],
    'cough': [
      DrugModel(
        name: 'Selgon',
        genericName: 'Pipazethate',
        symptoms: ['cough'],
      ),
      DrugModel(
        name: 'Osipect Syrup',
        genericName:
            'Potassium citrate + Diphenhydramine + Terbutaline + Guaifenesin',
        symptoms: ['cough', 'cold'],
      ),
      DrugModel(
        name: 'Balkis Syrup',
        genericName: 'Etilefrine + Chlorpheniramine',
        symptoms: ['cough', 'cold', 'allergy'],
      ),
    ],
    'sore_throat': [
      DrugModel(
        name: 'Hexitol Mouth Wash',
        genericName: 'Hexetidine',
        symptoms: ['sore_throat'],
      ),
      DrugModel(
        name: 'Strepsils',
        genericName: 'Throat lozenges',
        symptoms: ['sore_throat'],
      ),
      DrugModel(
        name: 'Megalase',
        genericName: 'Alpha amylase',
        symptoms: ['sore_throat'],
      ),
    ],
    'pain': [
      DrugModel(
        name: 'CETAL 500 mg',
        genericName: 'Paracetamol 500 mg',
        symptoms: ['pain', 'fever', 'headache'],
      ),
      DrugModel(
        name: 'FLABU 400 mg',
        genericName: 'Ibuprofen 400 mg',
        symptoms: ['pain', 'fever'],
      ),
      DrugModel(
        name: 'EPIFENAC 50 mg',
        genericName: 'Diclofenac sodium 50 mg',
        symptoms: ['pain', 'muscle_pain'],
      ),
    ],
    'muscle_pain': [
      DrugModel(
        name: 'Dichloren Gel',
        genericName: 'Diclofenac sodium topical gel',
        symptoms: ['muscle_pain', 'pain'],
      ),
      DrugModel(
        name: 'ROMAFEN Gel',
        genericName: 'Diclofenac sodium topical gel',
        symptoms: ['muscle_pain', 'pain'],
      ),
      DrugModel(
        name: 'Adwiflam Gel',
        genericName: 'Diclofenac diethylamine + Menthol + Methyl salicylate',
        symptoms: ['muscle_pain', 'pain'],
      ),
    ],
    'stomach_pain': [
      DrugModel(
        name: 'Spasmofen',
        genericName: 'Antispasmodic analgesic combination',
        symptoms: ['stomach_pain'],
      ),
      DrugModel(
        name: 'Buscopan',
        genericName: 'Hyoscine butylbromide',
        symptoms: ['stomach_pain'],
      ),
      DrugModel(
        name: 'Colona',
        genericName: 'Mebeverine + Sulpiride',
        symptoms: ['stomach_pain'],
      ),
    ],
    'heartburn': [
      DrugModel(
        name: 'Antodine',
        genericName: 'Famotidine',
        symptoms: ['heartburn'],
      ),
      DrugModel(
        name: 'Gaviscon',
        genericName: 'Sodium alginate + antacid combination',
        symptoms: ['heartburn'],
      ),
      DrugModel(
        name: 'Epicogel',
        genericName: 'Antacid suspension',
        symptoms: ['heartburn'],
      ),
    ],
    'diarrhea': [
      DrugModel(
        name: 'Antinal',
        genericName: 'Nifuroxazide',
        symptoms: ['diarrhea'],
      ),
      DrugModel(
        name: 'Smecta',
        genericName: 'Diosmectite',
        symptoms: ['diarrhea'],
      ),
      DrugModel(
        name: 'Rehydran-N',
        genericName: 'Oral rehydration salts',
        symptoms: ['diarrhea'],
      ),
    ],
    'constipation': [
      DrugModel(
        name: 'Minalax',
        genericName: 'Bisacodyl + Docusate sodium',
        symptoms: ['constipation'],
      ),
      DrugModel(
        name: 'Lactulose',
        genericName: 'Lactulose oral solution',
        symptoms: ['constipation'],
      ),
      DrugModel(
        name: 'Laxel',
        genericName: 'Effervescent laxative salts',
        symptoms: ['constipation'],
      ),
    ],
    'nausea': [
      DrugModel(
        name: 'Motilium',
        genericName: 'Domperidone',
        symptoms: ['nausea'],
      ),
      DrugModel(
        name: 'Dompidone',
        genericName: 'Domperidone',
        symptoms: ['nausea'],
      ),
      DrugModel(
        name: 'PLEMAZOL',
        genericName: 'Metoclopramide',
        symptoms: ['nausea'],
      ),
    ],
    'allergy': [
      DrugModel(
        name: 'MOSEDIN 10 mg',
        genericName: 'Loratadine 10 mg',
        symptoms: ['allergy'],
      ),
      DrugModel(
        name: 'DESA 5 mg',
        genericName: 'Desloratadine 5 mg',
        symptoms: ['allergy'],
      ),
      DrugModel(
        name: 'BREVY 5 mg',
        genericName: 'Desloratadine 5 mg',
        symptoms: ['allergy'],
      ),
    ],
    'skin_allergy': [
      DrugModel(
        name: 'Allergex Cream',
        genericName: 'Chlorphenoxamine topical cream',
        symptoms: ['skin_allergy'],
      ),
      DrugModel(
        name: 'Crotamiton Cream',
        genericName: 'Crotamiton topical',
        symptoms: ['skin_allergy'],
      ),
      DrugModel(
        name: 'Calamyl-D Lotion',
        genericName: 'Calamine combination lotion',
        symptoms: ['skin_allergy'],
      ),
    ],
    'nasal_congestion': [
      DrugModel(
        name: 'Balkis 0.05% Nasal Drops',
        genericName: 'Xylometazoline 0.05%',
        symptoms: ['nasal_congestion', 'cold'],
      ),
      DrugModel(
        name: 'Otrivin',
        genericName: 'Xylometazoline',
        symptoms: ['nasal_congestion', 'cold'],
      ),
      DrugModel(
        name: 'Saline Nasal Spray',
        genericName: 'Sodium chloride nasal spray',
        symptoms: ['nasal_congestion'],
      ),
    ],
    'eye_irritation': [
      DrugModel(
        name: 'Optozoline Eye Drops',
        genericName: 'Naphazoline + Chlorpheniramine',
        symptoms: ['eye_irritation', 'allergy'],
      ),
      DrugModel(
        name: 'Swixoline Eye Drops',
        genericName: 'Naphazoline + Chlorpheniramine',
        symptoms: ['eye_irritation', 'allergy'],
      ),
      DrugModel(
        name: 'Artificial Tears',
        genericName: 'Lubricant eye drops',
        symptoms: ['eye_irritation'],
      ),
    ],
    'infection': [
      DrugModel(
        name: 'اشتباه عدوى',
        genericName: 'لا يتم اقتراح مضاد حيوي تلقائيا',
        symptoms: ['infection'],
      ),
    ],
  };
}
