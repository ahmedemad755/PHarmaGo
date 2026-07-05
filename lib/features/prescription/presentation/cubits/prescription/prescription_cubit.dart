import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/Features/prescription/domain/entities/medicine_entity.dart';
import 'package:e_commerce/Features/prescription/domain/usecases/analyze_prescription_usecase.dart';
import 'package:equatable/equatable.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final AnalyzePrescriptionUseCase _analyzePrescriptionUseCase;

  PrescriptionCubit(this._analyzePrescriptionUseCase)
    : super(PrescriptionInitial());

  Future<void> uploadAndAnalyzePrescription(File image) async {
    emit(PrescriptionLoading());

    final result = await _analyzePrescriptionUseCase(image);

    result.fold(
      (failure) => emit(PrescriptionFailure(failure)),
      (medicines) => emit(PrescriptionAnalyzed(medicines)),
    );
  }
}
