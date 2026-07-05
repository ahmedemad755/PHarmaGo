import 'package:equatable/equatable.dart';

class MedicineEntity extends Equatable {
  final String name;
  final String? dose;
  final String? frequency;

  const MedicineEntity({required this.name, this.dose, this.frequency});

  @override
  List<Object?> get props => [name, dose, frequency];
}
