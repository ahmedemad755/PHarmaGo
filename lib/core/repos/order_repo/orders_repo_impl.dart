// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:e_commerce/core/errors/faliur.dart';
// import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
// import 'package:e_commerce/core/services/database_service.dart';
// import 'package:e_commerce/core/utils/backend_points.dart';
// import 'package:e_commerce/featchers/checkout/data/order_model.dart';
// import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';

// class OrdersRepoImpl implements OrdersRepo {
//   final DatabaseService fireStoreService;
//   OrdersRepoImpl(this.fireStoreService);

//   @override
//   Future<Either<Faliur, void>> addOrder({required OrderInputEntity order}) async {
//     try {
//       var orderModel = OrderModel.fromEntity(order);
      
//       // 1. حفظ الأوردر
//       await fireStoreService.addData(
//         path: BackendPoints.orders,
//         data: orderModel.toJson(),
//         documentId: orderModel.orderId,
//       );

//       // 2. تحديث عداد المبيعات (sellingcount) لكل منتج في الطلب تلقائياً
//       for (var item in order.cartItems) { // تأكد من اسم قائمة المنتجات في الـ Entity
//         await FirebaseFirestore.instance
//             .collection(BackendPoints.products)
//             .doc(item.productId) 
//             .update({
//           'sellingcount': FieldValue.increment(item.quantity),
//         });
//       }

//       return right(null);
//     } catch (e) {
//       return left(ServerFaliur(e.toString()));
//     }
//   }

//   @override
//   Stream<Either<Faliur, List<OrderModel>>> fetchOrders({required String uID}) {
//     return fireStoreService.getCollectionStream(
//       path: BackendPoints.orders,
//       query: (q) => q.where('uId', isEqualTo: uID),
//     ).map((data) {
//       List<OrderModel> orders = data.map((e) => OrderModel.fromJson(e)).toList();
//       return right(orders);
//     });
//   }

//   @override
//   Future<Either<Faliur, void>> cancelOrder({required String orderId}) async {
//     try {
//       await fireStoreService.updateData(
//         path: BackendPoints.orders,
//         documentId: orderId,
//         data: {'status': 'cancelled'},
//       );
//       return right(null);
//     } catch (e) {
//       return left(ServerFaliur(e.toString()));
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/faliur.dart';
import 'package:e_commerce/core/repos/order_repo/orders_repo.dart';
import 'package:e_commerce/core/services/database_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/featchers/checkout/data/order_model.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';

class OrdersRepoImpl implements OrdersRepo {
  final DatabaseService fireStoreService;
  OrdersRepoImpl(this.fireStoreService);

  @override
  Future<Either<Faliur, void>> addOrder({required OrderInputEntity order}) async {
    try {
      var orderModel = OrderModel.fromEntity(order);
      
      // 1. حفظ الأوردر في كولكشن orders
      await fireStoreService.addData(
        path: BackendPoints.orders,
        data: orderModel.toJson(),
        documentId: orderModel.orderId,
      );

      // 2. تحديث عداد المبيعات (sellingcount) لكل منتج في الطلب تلقائياً
      // تم تعديل المسار للوصول لـ cartItems من داخل cartEntity
      for (var item in order.cartEntity.cartItems) { 
        await FirebaseFirestore.instance
            .collection(BackendPoints.getProducts)
            .doc(item.productIntety.code) // نستخدم الكود كـ ID للمنتج
            .update({
          'sellingcount': FieldValue.increment(item.quantty), // زيادة الكمية المباعة
        });
      }

      return right(null);
    } catch (e) {
      return left(ServerFaliur('فشل في إتمام الطلب: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Faliur, List<OrderModel>>> fetchOrders({required String uID}) {
    return fireStoreService.getCollectionStream(
      path: BackendPoints.orders,
      query: (q) => q.where('uId', isEqualTo: uID),
    ).map((data) {
      List<OrderModel> orders = data.map((e) => OrderModel.fromJson(e)).toList();
      return right(orders);
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