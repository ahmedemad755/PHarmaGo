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
      // جلب البيانات من كولكشن العروض
      // لاحظ أننا يمكننا تمرير query لجلب العروض النشطة فقط والترتيب حسب التاريخ
      final data = await databaseService.getData(
        path: BackendPoints.banners,
        query: {
          'orderBy': 'created_at',
          'descending': true,
        },
      ) as List<Map<String, dynamic>>;

      // تحويل البيانات من List<Map> إلى List<BannerEntity>
      // مع فلترة العروض غير النشطة في حال لم تدعم الـ Service فلترة الكويري
      final banners = data
          .map((e) => BannerModel.fromJson(e, '')) 
          .where((banner) => banner.isActive) // فلترة النشط فقط
          .toList();

      return Right(banners);
    } catch (e) {
      // يمكنك تخصيص الرسالة بناءً على نوع الخطأ
      return Left(ServerFaliur('عذراً، فشل تحميل العروض الحالية.'));
    }
  }
}