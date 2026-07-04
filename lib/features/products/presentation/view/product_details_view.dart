import 'package:e_commerce/Features/cart/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/Features/products/domain/entityes/product_enteti.dart';
import 'package:e_commerce/Features/products/presentation/controllers/nearby_pharmacy_offers_controller.dart';
import 'package:e_commerce/Features/products/presentation/models/pharmacy_offer.dart';
import 'package:e_commerce/Features/products/presentation/widgets/product_bottom_action_bar.dart';
import 'package:e_commerce/Features/products/presentation/widgets/product_description_section.dart';
import 'package:e_commerce/Features/products/presentation/widgets/product_header_section.dart';
import 'package:e_commerce/Features/products/presentation/widgets/product_image_carousel.dart';
import 'package:e_commerce/Features/products/presentation/widgets/pharmacy_offers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final NearbyPharmacyOffersController _offersController;
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isLoading = true; // ابدأ بـ true لتحميل البيانات أول مرة

  PharmacyOffer? _selectedOffer;
  List<PharmacyOffer> _offers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _offersController =
        NearbyPharmacyOffersController(
            productCode: widget.product.code,
            onOffersUpdated: _handleOffersUpdated,
          )
          ..start();
  }

  // نفس المنطق الأصلي بالظبط: الاستماع المباشر بيحط أول عرض تلقائي، أما
  // إعادة الحساب بعد تغيير الموقع المحفوظ فبيحافظ على العرض المختار لو
  // لسه موجود فى القائمة الجديدة.
  void _handleOffersUpdated(
    List<PharmacyOffer> offers, {
    required bool preserveSelection,
  }) {
    if (!mounted) return;
    setState(() {
      _offers = offers;
      if (preserveSelection && _selectedOffer != null) {
        final selectedStillExists = offers.any(
          (offer) => offer.id == _selectedOffer!.id,
        );
        _selectedOffer = selectedStillExists
            ? offers.firstWhere((offer) => offer.id == _selectedOffer!.id)
            : (offers.isNotEmpty ? offers.first : null);
      } else if (offers.isNotEmpty) {
        _selectedOffer = offers.first;
      }
      _isLoading = false;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("هذه الصيدلية نفذت الكمية")));
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
    _offersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final bool hasDiscount = _selectedOffer?.hasDiscount ?? false;
    final double price =
        _selectedOffer?.originalPrice ?? widget.product.price.toDouble();
    final double discountedPrice = _selectedOffer?.discountedPrice ?? price;
    final int discountPercentage = hasDiscount && _selectedOffer != null
        ? ((price - discountedPrice) / price * 100).round()
        : 0;
    final bool canAdd = _selectedOffer != null && _selectedOffer!.isAvailable;

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
                            ProductImageCarousel(
                              imageUrl: widget.product.imageurl,
                              pageController: _pageController,
                              isMobile: isMobile,
                              onPageChanged: (index) =>
                                  setState(() => _currentImageIndex = index),
                            ),
                            const SizedBox(height: 16),
                            ProductHeaderSection(
                              product: widget.product,
                              hasDiscount: hasDiscount,
                              price: price,
                              discountedPrice: discountedPrice,
                              discountPercentage: discountPercentage,
                            ),
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
                            PharmacyOffersList(
                              offers: _offers,
                              selectedOffer: _selectedOffer,
                              onOfferSelected: (offer) =>
                                  setState(() => _selectedOffer = offer),
                            ),
                            const SizedBox(height: 24),
                            ProductDescriptionSection(
                              description: widget.product.description,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ProductBottomActionBar(
                    quantity: _quantity,
                    canAdd: canAdd,
                    selectedOfferName: _selectedOffer?.name,
                    onIncrement: () => setState(() => _quantity++),
                    onDecrement: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    onAddToCart: canAdd ? _addToCart : null,
                  ),
                ],
              ),
      ),
    );
  }
}
