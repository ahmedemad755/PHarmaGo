import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/repos/banner_repo/banners_repo.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/banners/banner_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit(this.bannersRepo) : super(BannersInitial());

  final BannersRepo bannersRepo;

  Future<void> getBanners() async {
    emit(GetBannersLoading());
    final result = await bannersRepo.getBanners();
    
    result.fold(
      (failure) => emit(GetBannersFailure(failure.message)),
      (banners) {
        // فلترة العروض للتأكد من عرض النشط فقط (زيادة أمان)
        final activeBanners = banners.where((b) => b.isActive).toList();
        emit(GetBannersSuccess(activeBanners));
      },
    );
  }
}