import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';

abstract class OrdersRepo {
  // إرسال الطلب النهائي
  Future<Either<Faliur, void>> addOrder({required OrderInputEntity order});
  
  // 🔥 الدالة الجديدة لرفع صورة الروشتة والحصول على الرابط
  Future<Either<Faliur, String>> uploadPrescription(File imageFile);

  // جلب الطلبات الخاصة بالمستخدم
  Stream<Either<Faliur, List<OrderModel>>> fetchOrders({required String uID});

  // إلغاء طلب
  Future<Either<Faliur, void>> cancelOrder({required String orderId});
}