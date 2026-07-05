import 'dart:io';

abstract class OrdersRemoteDataSource {
  Future<String?> uploadPrescriptionImage(File imageFile);

  Future<void> createOrder({
    required String documentId,
    required Map<String, dynamic> data,
  });

  Stream<List<Map<String, dynamic>>> fetchOrders({required String uID});

  Future<void> cancelOrder({required String orderId});
}
