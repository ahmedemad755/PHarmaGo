import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/services/storge_service.dart'; // استيراد الواجهة
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:image_picker/image_picker.dart';

class OrdersRepoImpl implements OrdersRepo {
  final DatabaseService fireStoreService;
  final StorgeService storgeService; // إضافة خدمة التخزين هنا

  OrdersRepoImpl(this.fireStoreService, this.storgeService);

  @override
  Future<Either<Faliur, String>> uploadPrescription(File imageFile) async {
    try {
      // تحويل File إلى XFile للعمل مع الخدمة الجديدة
      final XFile xFile = XFile(imageFile.path);
      
      // الرفع إلى البوكيت المخصص 'prescriptions'
      final String? downloadUrl = await storgeService.uploadImage(xFile, 'prescriptions');

      if (downloadUrl != null) {
        return right(downloadUrl);
      } else {
        return left(ServerFaliur('فشل الحصول على رابط الصورة بعد الرفع'));
      }
    } catch (e) {
      return left(ServerFaliur('فشل رفع صورة الروشتة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Faliur, void>> addOrder({required OrderInputEntity order}) async {
    try {
      String? uploadedImageUrl;

      if (order.prescriptionFile != null) {
        final uploadResult = await uploadPrescription(File(order.prescriptionFile!.path));
        
        uploadedImageUrl = uploadResult.fold(
          (failure) => throw Exception(failure.message),
          (url) => url,
        );
      }

      order.prescriptionImageUrl = uploadedImageUrl;

      var orderModel = OrderModel.fromEntity(order);
      Map<String, dynamic> orderData = orderModel.toJson();

      orderData['prescriptionImage'] = uploadedImageUrl; 
      orderData['createdAt'] = FieldValue.serverTimestamp();
      orderData['uId'] = order.uID;

      await fireStoreService.addData(
        path: BackendPoints.orders,
        data: orderData,
        documentId: orderModel.orderId,
      );

      return right(null);
    } catch (e) {
      return left(ServerFaliur('فشل في إتمام الطلب: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Faliur, List<OrderModel>>> fetchOrders({required String uID}) {
    return fireStoreService.getCollectionStream(
      path: BackendPoints.orders,
      query: (q) => q.where('uId', isEqualTo: uID).orderBy('createdAt', descending: true),
    ).map((data) {
      try {
        List<OrderModel> orders = data.map((e) => OrderModel.fromJson(e)).toList();
        return right(orders);
      } catch (e) {
        return left(ServerFaliur('خطأ في تحويل البيانات: $e'));
      }
    });
  }

  @override
  Future<Either<Faliur, void>> cancelOrder({required String orderId}) async {
    try {
      await fireStoreService.updateData(
        path: BackendPoints.orders,
        documentId: orderId,
        data: {'status': 'cancelled'},
      );
      return right(null);
    } catch (e) {
      return left(ServerFaliur(e.toString()));
    }
  }
}