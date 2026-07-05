import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/Features/orders/data/datasource/remote/orders_remote_datasource.dart';
import 'package:e_commerce/Features/orders/domain/entities/order_entity.dart';
import 'package:e_commerce/Features/orders/domain/repositories/orders_repo.dart';
import 'package:e_commerce/Features/orders/data/models/order_model.dart';
import 'package:e_commerce/Features/checkout/domain/enteteis/order_entity.dart';

class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._remoteDataSource);

  final OrdersRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Faliur, String>> uploadPrescription(File imageFile) async {
    try {
      final downloadUrl = await _remoteDataSource.uploadPrescriptionImage(
        imageFile,
      );

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
  Future<Either<Faliur, void>> addOrder({
    required OrderInputEntity order,
  }) async {
    try {
      String? uploadedImageUrl;

      if (order.prescriptionFile != null) {
        final uploadResult = await uploadPrescription(
          File(order.prescriptionFile!.path),
        );

        uploadedImageUrl = uploadResult.fold(
          (failure) => throw Exception(failure.message),
          (url) => url,
        );
      }

      order.prescriptionImageUrl = uploadedImageUrl;

      var orderModel = OrderModel.fromInputEntity(order);
      Map<String, dynamic> orderData = orderModel.toJson();

      orderData['prescriptionImage'] = uploadedImageUrl;
      orderData['createdAt'] = FieldValue.serverTimestamp();
      orderData['uId'] = order.uID;

      await _remoteDataSource.createOrder(
        documentId: orderModel.orderId,
        data: orderData,
      );

      return right(null);
    } catch (e) {
      return left(ServerFaliur('فشل في إتمام الطلب: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Faliur, List<OrderEntity>>> fetchOrders({required String uID}) {
    return _remoteDataSource.fetchOrders(uID: uID).map((data) {
      try {
        List<OrderEntity> orders = data
            .map((e) => OrderModel.fromJson(e).toEntity())
            .toList();
        return right(orders);
      } catch (e) {
        return left(ServerFaliur('خطأ في تحويل البيانات: $e'));
      }
    });
  }

  @override
  Future<Either<Faliur, void>> cancelOrder({required String orderId}) async {
    try {
      await _remoteDataSource.cancelOrder(orderId: orderId);
      return right(null);
    } catch (e) {
      return left(ServerFaliur(e.toString()));
    }
  }
}
