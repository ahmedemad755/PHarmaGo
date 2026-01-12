import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/models/prescription_match_result.dart';
import 'package:e_commerce/core/repos/pripresetion_repo/prescription_repo.dart';
import 'package:meta/meta.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final PrescriptionRepo repo;

  PrescriptionCubit(this.repo) : super(PrescriptionInitial());

  Future<void> processOCR(String text) async {
    emit(PrescriptionLoading());

    final result = await repo.matchPrescription(text);

    result.fold((failure) => emit(PrescriptionFailure(failure.message)), (
      match,
    ) {
      switch (match.type) {
        case MatchType.exact:
          emit(PrescriptionAddDirect(match.product!));
          break;
        case MatchType.confirm:
          emit(PrescriptionNeedConfirm(match.product!, match.score));
          break;
        case MatchType.aiSuggest:
          emit(PrescriptionAISuggest());
          break;
        case MatchType.none:
          emit(PrescriptionFailure('لا يوجد تطابق'));
      }
    });
  }
}
