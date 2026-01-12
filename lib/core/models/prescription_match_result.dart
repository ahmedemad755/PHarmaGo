import 'package:e_commerce/core/enteties/product_enteti.dart';

enum MatchType {
  exact, // 100%
  confirm, // 70% - 99%
  aiSuggest, // < 70%
  none,
}

class PrescriptionMatchResult {
  final MatchType type;
  final AddProductIntety? product;
  final double score;

  const PrescriptionMatchResult({
    required this.type,
    this.product,
    required this.score,
  });
}
