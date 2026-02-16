import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/featchers/home/domain/enteties/BannerEntity.dart';


abstract class BannersRepo {
  Future<Either<Faliur, List<BannerEntity>>> getBanners();
}