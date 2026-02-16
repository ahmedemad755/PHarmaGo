import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart'; // تأكد من استيراد الموديل
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';

abstract class OrdersRepo {
  Future<Either<Faliur, void>> addOrder({required OrderInputEntity order});
  
  // 💡 الدالة الجديدة لجلب الطلبات الخاصة بالمستخدم
  Stream<Either<Faliur, List<OrderModel>>> fetchOrders({required String uID});

  Future<Either<Faliur, void>> cancelOrder({required String orderId});
}