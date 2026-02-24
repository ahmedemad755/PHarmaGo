import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/models/pharmacy_model.dart'; // تأكد من صحة المسار
import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/utils/backend_points.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PharmacyOffer {
  final String id;
  final String name;
  final String address; // تم الإبقاء عليه للعرض
  final String status;  // تم الإبقاء عليه للعرض
  final double price;
  final double distanceKm;
  final int deliveryTimeMin;
  final double rating;
  final bool isSponsored;

  PharmacyOffer({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
    required this.price,
    required this.distanceKm,
    required this.deliveryTimeMin,
    required this.rating,
    this.isSponsored = false,
  });
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
  bool _isLoading = false;

  PharmacyOffer? _selectedOffer;
  List<PharmacyOffer> _offers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadPharmacyOffers();
  }

  void _loadPharmacyOffers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(BackendPoints.getProducts)
          .where('code', isEqualTo: widget.product.code)
          .get();

      List<PharmacyOffer> realOffers = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final String pharmacyId = data['pharmacyId'] ?? '';

        // جلب بيانات الصيدلية من كوليكشن pharmacies
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
              price: (data['price'] as num).toDouble(),
              distanceKm: 1.2,
              deliveryTimeMin: 20,
              rating: 4.5,
            ),
          );
        } else {
          // حالة احتياطية إذا لم يوجد مستند للصيدلية
          realOffers.add(
            PharmacyOffer(
              id: pharmacyId,
              name: data['pharmacyName'] ?? 'صيدلية غير معروفة',
              address: 'العنوان غير متوفر',
              status: 'unknown',
              price: (data['price'] as num).toDouble(),
              distanceKm: 1.2,
              deliveryTimeMin: 20,
              rating: 4.5,
            ),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _offers = realOffers;

        if (_offers.isNotEmpty) {
          _selectedOffer = _offers.firstWhere(
            (element) =>
                element.id == widget.product.pharmacyId ||
                element.id == "${widget.product.code}_${widget.product.pharmacyId}",
            orElse: () => _offers.first,
          );
        } else {
          _selectedOffer = null;
        }

        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ في تحميل العروض: $e")),
        );
      }
    }
  }

  void _addToCart() {
    if (_selectedOffer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اختر صيدلية أولاً")),
      );
      return;
    }

    context.read<CartCubit>().addProduct(
          widget.product,
          quantity: _quantity,
          pharmacyId: _selectedOffer!.id,
          pharmacyName: _selectedOffer!.name,
          priceAtSelection: _selectedOffer!.price,
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return BlocListener<CartCubit, CartState>(
      listenWhen: (p, c) => c is CartItemAdded,
      listener: (context, state) {},
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
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
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
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                1,
                (index) => Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007BBB),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          widget.product.category,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
        final isCheapest = _offers.every(
          (element) => offer.price <= element.price,
        );

        return GestureDetector(
          onTap: () => setState(() => _selectedOffer = offer),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF007BBB) : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.store, color: Color(0xFF007BBB)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              offer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCheapest)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'أفضل سعر',
                                style: TextStyle(fontSize: 10, color: Colors.green),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.address,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 2),
                          Text(
                            '${offer.distanceKm} كم',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.timer, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 2),
                          Text(
                            '${offer.deliveryTimeMin} دقيقة',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${offer.price} ريال',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCheapest ? Colors.green : const Color(0xFF007BBB),
                      ),
                    ),
                    Radio<String>(
                      value: offer.id,
                      groupValue: _selectedOffer?.id,
                      activeColor: const Color(0xFF007BBB),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedOffer = offer);
                        }
                      },
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
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildBottomActionArea() {
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
                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                onPressed: _selectedOffer != null ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BBB),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'إضافة للسلة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (_selectedOffer != null)
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