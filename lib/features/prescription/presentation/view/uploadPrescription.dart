import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/functions_helper/get_user_data.dart';
import 'package:e_commerce/core/functions_helper/pharmacy_distance_helper.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/Features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UploadPrescriptionView extends StatefulWidget {
  const UploadPrescriptionView({super.key});

  @override
  State<UploadPrescriptionView> createState() => _UploadPrescriptionViewState();
}

class _UploadPrescriptionViewState extends State<UploadPrescriptionView> {
  File? _pickedImage;
  String? _selectedPharmacyId;
  String? _selectedPharmacyName;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userLocationSubscription;
  double? _userLat;
  double? _userLng;
  bool _isLoadingLocation = true;

  bool get _hasUserLocation => hasValidCoordinates(_userLat, _userLng);

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _listenToUserLocation();
  }

  @override
  void dispose() {
    _userLocationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserLocation() async {
    final cachedUser = getUser();

    if (hasValidCoordinates(cachedUser.lat, cachedUser.lng)) {
      if (!mounted) return;
      setState(() {
        _userLat = cachedUser.lat;
        _userLng = cachedUser.lng;
        _isLoadingLocation = false;
      });
      return;
    }

    final loadedFromFirestore = await _loadUserLocationFromFirestore();
    if (loadedFromFirestore) {
      if (!mounted) return;
      setState(() => _isLoadingLocation = false);
      return;
    }

    await _loadDeviceLocation();

    if (!mounted) return;
    setState(() => _isLoadingLocation = false);
  }

  Future<bool> _loadUserLocationFromFirestore() async {
    final cachedUser = getUser();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? cachedUser.uId;
    if (userId.isEmpty) return false;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(BackendPoints.getUserData)
          .doc(userId)
          .get();

      final data = snapshot.data();
      final lat = _readDouble(data?['lat']);
      final lng = _readDouble(data?['lng']);

      if (!hasValidCoordinates(lat, lng)) return false;

      _userLat = lat;
      _userLng = lng;
      return true;
    } catch (e) {
      debugPrint('Error loading user location: $e');
      return false;
    }
  }

  Future<void> _loadDeviceLocation() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      _userLat = position.latitude;
      _userLng = position.longitude;
    } catch (e) {
      debugPrint('Device location is not available: $e');
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
          final lat = _readDouble(data?['lat']);
          final lng = _readDouble(data?['lng']);

          if (!hasValidCoordinates(lat, lng)) return;
          if (lat == _userLat && lng == _userLng) return;
          if (!mounted) return;

          setState(() {
            _userLat = lat;
            _userLng = lng;
            _isLoadingLocation = false;
            _selectedPharmacyId = null;
            _selectedPharmacyName = null;
          });
        });
  }

  double? _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  List<_NearbyPharmacy> _filterNearbyPharmacies(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    if (!_hasUserLocation) return [];

    final pharmacies = <_NearbyPharmacy>[];

    for (final doc in docs) {
      final data = doc.data();
      final pharmacyLat = _readDouble(data['lat']);
      final pharmacyLng = _readDouble(data['lng']);

      if (!hasValidCoordinates(pharmacyLat, pharmacyLng)) continue;

      final distanceKm = calculateDistanceInKm(
        fromLat: _userLat!,
        fromLng: _userLng!,
        toLat: pharmacyLat!,
        toLng: pharmacyLng!,
      );

      if (distanceKm > nearbyPharmacyRadiusKm) continue;

      pharmacies.add(
        _NearbyPharmacy(
          id: (data['uId'] ?? doc.id).toString(),
          name: (data['pharmacyName'] ?? 'صيدلية غير معروفة').toString(),
          distanceKm: distanceKm,
        ),
      );
    }

    pharmacies.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return pharmacies;
  }

  void _clearInvalidSelectedPharmacyAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedPharmacyId == null) return;
      setState(() {
        _selectedPharmacyId = null;
        _selectedPharmacyName = null;
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _pickedImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب روشتة جديدة'), centerTitle: true),
      body: SingleChildScrollView(
        // أضفنا سكرول لتجنب مشاكل المساحة مع الكيبورد
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "1. اختر الصيدلية:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // --- الدروب داون ليست مرتبطة بـ Firestore ---
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(BackendPoints.pharmacies)
                  .where('status', isEqualTo: 'approved')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("خطأ في تحميل الصيدليات");
                }
                if (!snapshot.hasData) return const LinearProgressIndicator();

                if (_isLoadingLocation) {
                  return const LinearProgressIndicator();
                }

                if (!_hasUserLocation) {
                  return _buildPharmacyMessage(
                    'لم يتم تحديد موقعك بعد، فعّل الموقع أو حدّث عنوانك لعرض أقرب الصيدليات.',
                  );
                }

                final pharmacies = _filterNearbyPharmacies(
                  snapshot.data!.docs,
                );

                if (pharmacies.isEmpty) {
                  return _buildPharmacyMessage(
                    'لا توجد صيدليات قريبة داخل نطاق ${nearbyPharmacyRadiusKm.toStringAsFixed(0)} كم.',
                  );
                }

                final selectedValue = pharmacies.any(
                  (pharmacy) => pharmacy.id == _selectedPharmacyId,
                )
                    ? _selectedPharmacyId
                    : null;

                if (_selectedPharmacyId != null && selectedValue == null) {
                  _clearInvalidSelectedPharmacyAfterBuild();
                }

                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    hintText: 'اختر الصيدلية من القائمة',
                  ),
                  initialValue: selectedValue,
                  items: pharmacies.map((pharmacy) {
                    return DropdownMenuItem<String>(
                      value: pharmacy.id,
                      child: Text(
                        '${pharmacy.name} - ${pharmacy.distanceKm.toStringAsFixed(1)} كم',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    final selectedPharmacy = pharmacies.firstWhere(
                      (pharmacy) => pharmacy.id == value,
                    );
                    setState(() {
                      _selectedPharmacyId = value;
                      _selectedPharmacyName = selectedPharmacy.name;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 30),
            const Text(
              "2. صورة الروشتة:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // منطقة عرض الصورة
            GestureDetector(
              onTap: () => _showImageSourceDialog(),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_pickedImage!, fit: BoxFit.contain),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 60,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "اضغط هنا لالتقاط أو رفع الصورة",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 40),

            CustomButtn(
              text: 'تأكيد وإضافة للسلة',
              onPressed: () {
                if (_selectedPharmacyId == null) {
                  showBar(
                    context,
                    'من فضلك اختر الصيدلية أولاً',
                    color: Colors.orange,
                  );
                  return;
                }
                if (_pickedImage == null) {
                  showBar(
                    context,
                    'من فضلك ارفع صورة الروشتة',
                    color: Colors.orange,
                  );
                  return;
                }

                // إضافة للسلة عبر الكيوبت
                context.read<CartCubit>().setPrescriptionImage(
                  XFile(_pickedImage!.path),
                );
                context.read<CartCubit>().addPrescriptionToCart(
                  _pickedImage!,
                  _selectedPharmacyId!,
                  _selectedPharmacyName!,
                );

                showBar(
                  context,
                  'تمت الإضافة بنجاح لصيدلية $_selectedPharmacyName',
                  color: Colors.green,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPharmacyMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.camera_alt)),
              title: const Text('استخدام الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.photo_library)),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyPharmacy {
  final String id;
  final String name;
  final double distanceKm;

  const _NearbyPharmacy({
    required this.id,
    required this.name,
    required this.distanceKm,
  });
}
