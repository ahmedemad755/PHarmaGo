
import 'package:e_commerce/featchers/home/domain/enteties/BannerEntity.dart';

abstract class BannersState {}

class BannersInitial extends BannersState {}

class GetBannersLoading extends BannersState {}

class GetBannersSuccess extends BannersState {
  final List<BannerEntity> banners;
  GetBannersSuccess(this.banners);
}

class GetBannersFailure extends BannersState {
  final String errMessage;
  GetBannersFailure(this.errMessage);
}