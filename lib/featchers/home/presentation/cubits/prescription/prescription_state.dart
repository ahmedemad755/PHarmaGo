part of 'prescription_cubit.dart';

@immutable
abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionAddDirect extends PrescriptionState {
  final AddProductIntety product;
  PrescriptionAddDirect(this.product);
}

class PrescriptionNeedConfirm extends PrescriptionState {
  final AddProductIntety product;
  final double score;
  PrescriptionNeedConfirm(this.product, this.score);
}

class PrescriptionAISuggest extends PrescriptionState {}

class PrescriptionFailure extends PrescriptionState {
  final String message;
  PrescriptionFailure(this.message);
}
