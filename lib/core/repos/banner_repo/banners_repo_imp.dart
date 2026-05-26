import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/models/BannerModel.dart';
import 'package:e_commerce/core/repos/banner_repo/banners_repo.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/featchers/home/domain/enteties/BannerEntity.dart';

class BannersRepoImpl implements BannersRepo {
  final DatabaseService databaseService;

  BannersRepoImpl({required this.databaseService});

  @override
  Future<Either<Faliur, List<BannerEntity>>> getBanners() async {
    try {
      // استقبال البيانات كـ dynamic لتفادي مشاكل الكاستينج الصارم عند الإنتاج
      final rawData = await databaseService.getData(
        path: BackendPoints.banners,
        query: {'orderBy': 'created_at', 'descending': true},
      );

      // تحويل آمن للبيانات إلى قائمة مستقلة دون افتراض كاستينج مسبق لنوع الـ List
      final List<Map<String, dynamic>> data = [];
      if (rawData is List) {
        for (var item in rawData) {
          if (item is Map) {
            data.add(Map<String, dynamic>.from(item));
          }
        }
      }

      // تحويل القواميس إلى موديلات مع فلترة العناصر النشطة فقط
      final banners = data
          .map((e) => BannerModel.fromJson(e, e['id']?.toString() ?? ''))
          .where((banner) => banner.isActive)
          .toList();

      return Right(banners);
    } catch (e, stackTrace) {
      // طباعة تفاصيل الخطأ في الـ Console لضمان سهولة تتبعه في مرحلة الإنتاج دون التأثير على المستخدم
      log('Error in BannersRepoImpl.getBanners: $e', stackTrace: stackTrace);

      return Left(ServerFaliur('عذراً، فشل تحميل العروض الحالية.'));
    }
  }
}
