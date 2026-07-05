import 'dart:io';

import 'package:e_commerce/Features/orders/data/datasource/remote/orders_remote_datasource.dart';
import 'package:e_commerce/core/services/database/database_service.dart';
import 'package:e_commerce/core/services/storage/storage_service.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:image_picker/image_picker.dart';

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this._databaseService, this._storageService);

  final DatabaseService _databaseService;
  final StorgeService _storageService;

  @override
  Future<String?> uploadPrescriptionImage(File imageFile) {
    final xFile = XFile(imageFile.path);
    return _storageService.uploadImage(xFile, 'prescriptions');
  }

  @override
  Future<void> createOrder({
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    return _databaseService.addData(
      path: BackendPoints.orders,
      data: data,
      documentId: documentId,
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> fetchOrders({required String uID}) {
    return _databaseService.getCollectionStream(
      path: BackendPoints.orders,
      query: (q) =>
          q.where('uId', isEqualTo: uID).orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<void> cancelOrder({required String orderId}) {
    return _databaseService.updateData(
      path: BackendPoints.orders,
      documentId: orderId,
      data: {
        'status': 'cancelled', // تم توحيدها لتكون بلام واحدة كما في الـ Enum
        'cancelledBy':
            'customer', // 👈 إضافة هذا الحقل ليعرف لوحة التحكم أن العميل هو من ألغى
      },
    );
  }
}
