import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/repos/pripresetion_repo/prescription_repo.dart';
import 'package:e_commerce/featchers/home/domain/enteties/medicine_entity.dart';
import 'package:equatable/equatable.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final PrescriptionRepo _prescriptionRepo;

  PrescriptionCubit(this._prescriptionRepo) : super(PrescriptionInitial());

  Future<void> uploadAndAnalyzePrescription(File image) async {
    emit(PrescriptionLoading());

    final result = await _prescriptionRepo.analyzePrescription(image);

    result.fold(
      (failure) => emit(PrescriptionFailure(failure)),
      (medicines) => emit(PrescriptionAnalyzed(medicines)),
    );
  }
}
