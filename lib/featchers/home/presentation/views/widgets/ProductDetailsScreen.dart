import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- 1. NEW MODEL: Represents a pharmacy selling this specific product ---
class PharmacyOffer {
  final String id;
  final String name;
  final double price;
  final double distanceKm;
  final int deliveryTimeMin;
  final double rating;
  final bool isSponsored;

  PharmacyOffer({
    required this.id,
    required this.name,
    required this.price,
    required this.distanceKm,
    required this.deliveryTimeMin,
    required this.rating,
    this.isSponsored = false,
  });
}

class DetailsScreen extends StatefulWidget {
  final AddProductIntety product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  int _quantity = 1;

  // State for the selected pharmacy logic
  PharmacyOffer? _selectedOffer;
  List<PharmacyOffer> _offers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadPharmacyOffers(); // Simulate fetching data
  }

  // --- 2. LOGIC: Fetch pharmacies selling this item ---
  void _loadPharmacyOffers() {
    // In a real app, you would fetch this from API based on User Lat/Long + Product ID
    final basePrice = widget.product.price.toDouble();

    List<PharmacyOffer> mockOffers = [
      PharmacyOffer(
        id: '1',
        name: 'صيدلية النهدي',
        price: basePrice,
        distanceKm: 0.5,
        deliveryTimeMin: 15,
        rating: 4.8,
      ),
      PharmacyOffer(
        id: '2',
        name: 'صيدلية الدواء',
        price: basePrice - 2,
        distanceKm: 1.2,
        deliveryTimeMin: 25,
        rating: 4.5,
      ), // Cheaper but further
      PharmacyOffer(
        id: '3',
        name: 'صيدلية المجتمع',
        price: basePrice + 5,
        distanceKm: 0.2,
        deliveryTimeMin: 10,
        rating: 4.2,
      ), // Expensive but very close
      PharmacyOffer(
        id: '4',
        name: 'أورانج فارمسي',
        price: basePrice,
        distanceKm: 3.5,
        deliveryTimeMin: 45,
        rating: 4.0,
      ),
    ];

    // Auto-sort by Distance (Nearest First) - The core requirement
    mockOffers.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    setState(() {
      _offers = mockOffers;
      // Default select the nearest one (first in list)
      _selectedOffer = mockOffers.first;
    });
  }

  void _addToCart() {
    if (_selectedOffer == null) return;

    // You might need to update your CartCubit to accept the Pharmacy ID/Price
    // For now, we use the existing method but visually we know it came from a specific pharmacy
    context.read<CartCubit>().addProduct(widget.product, quantity: _quantity);
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
      listener: (context, state) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       '✓ تم إضافة المنتج من ${_selectedOffer?.name} إلى السلة!',
        //       textDirection: TextDirection.rtl,
        //     ),
        //     backgroundColor: Colors.green,
        //     behavior: SnackBarBehavior.floating,
        //   ),
        // );
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
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
        ),
        body: Column(
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

                      // --- 3. UI: The Pharmacy Comparison List ---
                      Text(
                        'متوفر في ${_offers.length} صيدليات قريبة منك',
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

  // --- WIDGETS ---

  Widget _buildImageCarousel(bool isMobile) {
    return Container(
      height: isMobile
          ? 250
          : 350, // Reduced height slightly to fit more content
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
              // Assuming generic image placeholder logic for brevity, replace with your loop
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
                  // Simulating 1 dot
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

  // 4. NEW WIDGET: Logic for selecting pharmacy
  Widget _buildPharmacyList() {
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
                color: isSelected
                    ? const Color(0xFF007BBB)
                    : Colors.transparent,
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
                // Pharmacy Icon/Logo
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

                // Pharmacy Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            offer.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (isCheapest)
                            Container(
                              margin: const EdgeInsets.only(
                                right: 8,
                              ), // RTL support needed
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'أفضل سعر',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${offer.distanceKm} كم',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.timer, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 2),
                          Text(
                            '${offer.deliveryTimeMin} دقيقة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${offer.price} ريال',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCheapest
                            ? Colors.green
                            : const Color(0xFF007BBB),
                      ),
                    ),
                    Radio<String>(
                      value: offer.id,
                      groupValue: _selectedOffer?.id,
                      activeColor: const Color(0xFF007BBB),
                      onChanged: (val) =>
                          setState(() => _selectedOffer = offer),
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

  // --- 5. UI: Bottom Sheet for Action ---
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
            // Quantity
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Add to Cart Button (Updates based on selection)
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedOffer != null ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BBB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
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
                        'من ${_selectedOffer!.name}',
                        style: TextStyle(
                          fontSize: 11,
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
