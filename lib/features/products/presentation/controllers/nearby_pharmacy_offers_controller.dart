import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Features/products/presentation/models/pharmacy_offer.dart';
import 'package:e_commerce/core/functions_helper/get_user_data.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// يجلب عروض الصيدليات القريبة لمنتج معين عبر مصدرين:
/// 1) استماع مباشر (Live) على المنتج + موقع الجهاز الحالي.
/// 2) استماع على موقع المستخدم المحفوظ فى Firestore، مع إعادة حساب العروض
///    كلما تغيّر هذا الموقع.
///
/// [onOffersUpdated] يُستدعى فى الحالتين، مع preserveSelection يوضح هل
/// الشاشة لازم تحافظ على العرض المختار حالياً (لو لسه موجود) ولا تختار
/// أول عرض تلقائياً - نفس السلوك الأصلي بالظبط لكل مصدر.
class NearbyPharmacyOffersController {
  NearbyPharmacyOffersController({
    required this.productCode,
    required this.onOffersUpdated,
  });

  final String productCode;
  final void Function(
    List<PharmacyOffer> offers, {
    required bool preserveSelection,
  })
  onOffersUpdated;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _offersSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _userLocationSubscription;
  double? _userLat;
  double? _userLng;

  void start() {
    _initUserLocationFromCache();
    _listenToUserLocation();
    _listenToPharmacyOffers();
  }

  void dispose() {
    _offersSubscription?.cancel();
    _userLocationSubscription?.cancel();
  }

  void _initUserLocationFromCache() {
    final user = getUser();
    if (user.lat != 0.0 || user.lng != 0.0) {
      _userLat = user.lat;
      _userLng = user.lng;
    }
  }

  void _listenToUserLocation() {
    final cachedUser = getUser();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? cachedUser.uId;
    if (userId.isEmpty) return;

    _userLocationSubscription = FirebaseFirestore.instance
        .collection(BackendPoints.getUserData)
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
          final data = snapshot.data();
          final lat = (data?['lat'] as num?)?.toDouble();
          final lng = (data?['lng'] as num?)?.toDouble();

          if (lat == null || lng == null) return;
          if (lat == _userLat && lng == _userLng) return;

          _userLat = lat;
          _userLng = lng;
          _refreshOffersForSavedUserLocation();
        });
  }

  void _listenToPharmacyOffers() {
    _offersSubscription = FirebaseFirestore.instance
        .collection(BackendPoints.getProducts)
        .where('code', isEqualTo: productCode)
        .snapshots()
        .listen((querySnapshot) async {
          List<PharmacyOffer> realOffers = [];
          Position? userPos;
          try {
            // 1. محاولة جلب آخر موقع مسجل بسرعة
            userPos = await Geolocator.getLastKnownPosition();

            // 2. إذا لم يوجد، اطلب الموقع الحالي بدقة عالية
            userPos ??= await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
                timeLimit: const Duration(seconds: 5),
              );
            print("User Location: ${userPos.latitude}, ${userPos.longitude}");
          } catch (e) {
            debugPrint("Location Error: $e");
          }

          for (var doc in querySnapshot.docs) {
            final data = doc.data();
            final String pharmacyId = data['pharmacyId'] ?? '';

            // جلب بيانات الصيدلية الأصلية من كوليكشن الصيدليات
            final pharmacyDoc = await FirebaseFirestore.instance
                .collection(BackendPoints.pharmacies)
                .doc(pharmacyId)
                .get();

            if (pharmacyDoc.exists) {
              final pData = pharmacyDoc.data()!;

              // أخذ الإحداثيات من ملف الصيدلية نفسه (lat , lng) كما في بياناتك
              final double shopLat = (pData['lat'] as num? ?? 0).toDouble();
              final double shopLng = (pData['lng'] as num? ?? 0).toDouble();

              double distanceInKm = 0;
              if (userPos != null && shopLat != 0) {
                double distanceInMeters = Geolocator.distanceBetween(
                  userPos.latitude,
                  userPos.longitude,
                  shopLat,
                  shopLng,
                );
                distanceInKm = distanceInMeters / 1000;
                print(
                  "Distance to ${pData['pharmacyName']}: $distanceInMeters meters",
                );
              }

              // الفلترة في نطاق 5 كيلو
              if (userPos == null || distanceInKm <= 5.0) {
                final double price = (data['price'] as num).toDouble();
                // ... (باقي كود حساب السعر والخصم)

                realOffers.add(
                  PharmacyOffer(
                    id: pharmacyId,
                    name: pData['pharmacyName'] ?? 'صيدلية غير معروفة',
                    address: pData['address'] ?? '',
                    status: pData['status'] ?? '',
                    originalPrice: price,
                    discountedPrice: price, // احسب الخصم هنا لو موجود
                    distanceKm: distanceInKm,
                    deliveryTimeMin: (distanceInKm * 10).toInt() + 10,
                    rating: 4.5,
                    unitAmount: (data['unitAmount'] as num? ?? 0).toInt(),
                    hasDiscount: data['hasDiscount'] ?? false,
                  ),
                );
              }
            }
          }

          // ترتيب
          realOffers.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

          onOffersUpdated(realOffers, preserveSelection: false);
          unawaited(_refreshOffersForSavedUserLocation());
        });
  }

  Future<void> _refreshOffersForSavedUserLocation() async {
    if (_userLat == null || _userLng == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection(BackendPoints.getProducts)
        .where('code', isEqualTo: productCode)
        .get();

    final realOffers = <PharmacyOffer>[];

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final String pharmacyId = data['pharmacyId'] ?? '';
      if (pharmacyId.isEmpty) continue;

      final pharmacyDoc = await FirebaseFirestore.instance
          .collection(BackendPoints.pharmacies)
          .doc(pharmacyId)
          .get();

      if (!pharmacyDoc.exists) continue;

      final pData = pharmacyDoc.data()!;
      final double shopLat = (pData['lat'] as num? ?? 0).toDouble();
      final double shopLng = (pData['lng'] as num? ?? 0).toDouble();
      if (shopLat == 0 || shopLng == 0) continue;

      final distanceInKm =
          Geolocator.distanceBetween(_userLat!, _userLng!, shopLat, shopLng) /
          1000;
      if (distanceInKm > 5.0) continue;

      final double price = (data['price'] as num).toDouble();
      final bool hasDiscount = data['hasDiscount'] ?? false;
      final int discountPercentage =
          (data['discountPercentage'] as num? ?? 0).toInt();
      final double discountedPrice = hasDiscount && discountPercentage > 0
          ? price - (price * (discountPercentage / 100))
          : price;

      realOffers.add(
        PharmacyOffer(
          id: pharmacyId,
          name: pData['pharmacyName'] ?? 'صيدلية غير معروفة',
          address: pData['address'] ?? '',
          status: pData['status'] ?? '',
          originalPrice: price,
          discountedPrice: discountedPrice,
          distanceKm: distanceInKm,
          deliveryTimeMin: (distanceInKm * 10).toInt() + 10,
          rating: 4.5,
          unitAmount: (data['unitAmount'] as num? ?? 0).toInt(),
          hasDiscount: hasDiscount,
        ),
      );
    }

    realOffers.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    onOffersUpdated(realOffers, preserveSelection: true);
  }
}
