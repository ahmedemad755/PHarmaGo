part of 'prescription_cubit.dart';

abstract class PrescriptionState extends Equatable {
  const PrescriptionState();
  @override
  List<Object> get props => [];
}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

// الحالة دي لما الذكاء الاصطناعي يرجع لستة أدوية
class PrescriptionAnalyzed extends PrescriptionState {
  final List<MedicineEntity> medicines;
  const PrescriptionAnalyzed(this.medicines);
  
  @override
  List<Object> get props => [medicines];
}

class PrescriptionFailure extends PrescriptionState {
  final String errMessage;
  const PrescriptionFailure(this.errMessage);
  
  @override
  List<Object> get props => [errMessage];
}