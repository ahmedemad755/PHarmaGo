import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/models/pharmacy_model.dart';
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async'; // تم إضافة هذا للـ StreamSubscription

// ✅ تم تحديث الموديل ليشمل بيانات الخصم والسعر النهائي
class PharmacyOffer {
  final String id;
  final String name;
  final String address;
  final String status;
  final double originalPrice; // السعر الأصلي
  final double discountedPrice; // السعر بعد الخصم
  final double distanceKm;
  final int deliveryTimeMin;
  final double rating;
  final bool isSponsored;
  final int unitAmount; // الكمية المتاحة
  final bool hasDiscount; // حالة الخصم

  PharmacyOffer({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
    required this.originalPrice,
    required this.discountedPrice,
    required this.distanceKm,
    required this.deliveryTimeMin,
    required this.rating,
    this.isSponsored = false,
    required this.unitAmount,
    required this.hasDiscount,
  });

  bool get isAvailable => unitAmount > 0;
  double get finalPrice => hasDiscount ? discountedPrice : originalPrice;
}

class DetailsScreen extends StatefulWidget {
  final AddProductIntety product;
  final bool isLoading;
  const DetailsScreen({
    super.key,
    required this.product,
    this.isLoading = false,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isLoading = true; // ابدأ بـ true لتحميل البيانات أول مرة

  PharmacyOffer? _selectedOffer;
  List<PharmacyOffer> _offers = [];
  
  // ✅ إضافة subscription للاستماع المباشر
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _offersSubscription;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _listenToPharmacyOffers(); // ✅ تغيير الدالة للاستماع
  }

  // ✅ الدالة المحدثة للاستماع المباشر (Live Updates)
  void _listenToPharmacyOffers() {
    _offersSubscription = FirebaseFirestore.instance
        .collection(BackendPoints.getProducts)
        .where('code', isEqualTo: widget.product.code)
        .snapshots()
        .listen((querySnapshot) async {
      
      List<PharmacyOffer> realOffers = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final String pharmacyId = data['pharmacyId'] ?? '';

        // حساب الخصم
        final double price = (data['price'] as num).toDouble();
        final bool hasDiscount = data['hasDiscount'] ?? false;
        final int discountPercentage = (data['discountPercentage'] as num? ?? 0).toInt();
        double discountedPrice = price;
        if (hasDiscount && discountPercentage > 0) {
          discountedPrice = price - (price * (discountPercentage / 100));
        }

        // جلب بيانات الصيدلية (يفضل كاشينج هنا لاحقاً لتحسين الأداء)
        final pharmacyDoc = await FirebaseFirestore.instance
            .collection(BackendPoints.pharmacies)
            .doc(pharmacyId)
            .get();

        if (pharmacyDoc.exists) {
          final pharmacyInfo = PharmacyModel.fromJson(pharmacyDoc.data()!);

          realOffers.add(
            PharmacyOffer(
              id: pharmacyId,
              name: pharmacyInfo.pharmacyName,
              address: pharmacyInfo.address,
              status: pharmacyInfo.status,
              originalPrice: price,
              discountedPrice: discountedPrice,
              distanceKm: 1.2,
              deliveryTimeMin: 20,
              rating: 4.5,
              unitAmount: (data['unitAmount'] as num? ?? 0).toInt(),
              hasDiscount: hasDiscount,
            ),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _offers = realOffers;
        // تحديث الاختيار بناءً على البيانات الجديدة
        if (_selectedOffer != null) {
          // محاولة الإبقاء على نفس الصيدلية المختارة إذا كانت لا تزال موجودة
          final stillExists = _offers.any((o) => o.id == _selectedOffer!.id);
          if (stillExists) {
            _selectedOffer = _offers.firstWhere((o) => o.id == _selectedOffer!.id);
          } else {
            _selectedOffer = _offers.isNotEmpty ? _offers.first : null;
          }
        } else {
          _selectedOffer = _offers.isNotEmpty ? _offers.first : null;
        }
        
        _isLoading = false;
      });
    });
  }

  void _addToCart() {
    if (_selectedOffer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اختر صيدلية أولاً")),
      );
      return;
    }

    if (!_selectedOffer!.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("هذه الصيدلية نفذت الكمية")),
      );
      return;
    }

    context.read<CartCubit>().addProduct(
          widget.product,
          quantity: _quantity,
          pharmacyId: _selectedOffer!.id,
          pharmacyName: _selectedOffer!.name,
          priceAtSelection: _selectedOffer!.finalPrice,
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _offersSubscription?.cancel(); // ✅ إلغاء الاستماع عند الخروج
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return BlocListener<CartCubit, CartState>(
      listenWhen: (p, c) => c is CartItemAdded,
      listener: (context, state) {
        if (state is CartItemAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تمت الإضافة للسلة بنجاح")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "تفاصيل المنتج",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageCarousel(isMobile),
                            const SizedBox(height: 16),
                            _buildProductHeader(),
                            const SizedBox(height: 24),
                            Text(
                              _offers.isEmpty
                                  ? 'المنتج غير متوفر حالياً'
                                  : 'متوفر في ${_offers.length} صيدليات قريبة منك',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildPharmacyList(),
                            const SizedBox(height: 24),
                            _buildDescription(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomActionArea(),
                ],
              ),
      ),
    );
  }

  Widget _buildImageCarousel(bool isMobile) {
    return Container(
      height: isMobile ? 250 : 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) =>
                setState(() => _currentImageIndex = index),
            children: [
              Center(
                child: widget.product.imageurl != null
                    ? CustomNetworkImage(imageUrl: widget.product.imageurl!)
                    : const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    // ✅ هنا أيضاً يجب تحديث الأسعار بناءً على الـ _selectedOffer المباشر
    // بدلاً من الاعتماد على بيانات widget.product الثابتة
    
    final bool hasDiscount = _selectedOffer?.hasDiscount ?? false;
    final double price = _selectedOffer?.originalPrice ?? widget.product.price.toDouble();
    final double discountedPrice = _selectedOffer?.discountedPrice ?? price;
    final int discountPercentage = hasDiscount && _selectedOffer != null 
        ? ((price - discountedPrice) / price * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.product.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            if (hasDiscount)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "خصم $discountPercentage%",
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              )
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.product.category,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              "${discountedPrice.toStringAsFixed(2)} ريال",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BBB),
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                "${price.toStringAsFixed(2)} ريال",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPharmacyList() {
    if (_offers.isEmpty) return const SizedBox();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _offers.length,
      separatorBuilder: (c, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final offer = _offers[index];
        final isSelected = _selectedOffer?.id == offer.id;
        final bool isAvailable = offer.isAvailable;
        final double displayPrice = offer.finalPrice;

        return GestureDetector(
          onTap: isAvailable ? () => setState(() => _selectedOffer = offer) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAvailable
                    ? (isSelected ? const Color(0xFF007BBB) : Colors.transparent)
                    : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.blue[50] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.store,
                      color: isAvailable ? const Color(0xFF007BBB) : Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isAvailable ? Colors.black : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.address,
                        style: TextStyle(
                            fontSize: 11,
                            color: isAvailable ? Colors.grey[600] : Colors.grey[400]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${displayPrice.toStringAsFixed(2)} ريال',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isAvailable
                            ? const Color(0xFF007BBB)
                            : Colors.grey,
                      ),
                    ),
                    Radio<String>(
                      value: offer.id,
                      groupValue: _selectedOffer?.id,
                      activeColor: const Color(0xFF007BBB),
                      onChanged: isAvailable
                          ? (val) {
                              if (val != null) {
                                setState(() => _selectedOffer = offer);
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوصف',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description,
          style:
              TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildBottomActionArea() {
    final bool canAdd = _selectedOffer != null && _selectedOffer!.isAvailable;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: canAdd ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canAdd ? const Color(0xFF007BBB) : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      canAdd ? 'إضافة للسلة' : 'غير متوفر',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (_selectedOffer != null && canAdd)
                      Text(
                        'من صيدلية: ${_selectedOffer!.name}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}