// import 'package:e_commerce/core/enteties/product_enteti.dart';
// import 'package:e_commerce/core/widgets/custom_network_image.dart';
// import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:e_commerce/core/di/injection.dart';

// class DetailsScreen extends StatefulWidget {
//   final AddProductIntety product;

//   const DetailsScreen({super.key, required this.product});

//   @override
//   State<DetailsScreen> createState() => _DetailsScreenState();
// }

// class _DetailsScreenState extends State<DetailsScreen> {
//   late PageController _pageController;
//   int _currentImageIndex = 0;
//   int _quantity = 1;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _addToCart() {
//     context.read<CartCubit>().addItemToCart(
//           widget.product,
//           quantity: _quantity,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<CartCubit>(),
//       child: BlocListener<CartCubit, CartState>(
//         listenWhen: (p, c) => c is CartItemAdd,
//         listener: (context, state) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 '✓ تم إضافة ${widget.product.name} بعدد $_quantity إلى السلة!',
//                 textDirection: TextDirection.rtl,
//               ),
//               backgroundColor: Colors.green,
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             title: Text(widget.product.name),
//             centerTitle: true,
//           ),
//           body: _buildBody(context),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text(widget.product.name),
//           const SizedBox(height: 16),

//           // الصورة
//           SizedBox(
//             height: 300,
//             child: CustomNetworkImage(
//               imageUrl: widget.product.imageurl!,
//             ),
//           ),

//           const SizedBox(height: 20),

//           // الكمية
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove),
//                 onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
//               ),
//               Text("$_quantity"),
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () => setState(() => _quantity++),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           // زر الإضافة
//           ElevatedButton(
//             onPressed: _addToCart,
//             child: const Text("إضافة للسلة"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/featchers/home/presentation/cubits/curt_cubit/cart_cubit.dart'; // 💡 استيراد Cubit
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 💡 استيراد Bloc
// تم حذف: import 'package:e_commerce/core/di/injection.dart';
// تم حذف: import 'package:get_it/get_it.dart';
// تم حذف: import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';

class DetailsScreen extends StatefulWidget {
  final AddProductIntety product;
  const DetailsScreen({super.key, required this.product});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  int _quantity = 1; // 💡 الكمية المختارة

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    context.read<CartCubit>().addProduct(widget.product, quantity: _quantity);
    showBar(
      context,
      '✓ تم إضافة ${widget.product.name} بعدد $_quantity إلى السلة!',
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    // 🎯 BlocListener فقط، الاعتماد على CartCubit القادم من BlocProvider في routes.dart
    return BlocListener<CartCubit, CartState>(
      listenWhen: (p, c) => c is CartItemAdded,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✓ تم إضافة ${widget.product.name} بعدد $_quantity إلى السلة!',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        // 👈 الـ Scaffold هو الـ child للـ BlocListener
        backgroundColor: const Color(0xFFF3F5F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.product.name,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Image Carousel with Dot Indicator --- (الكود كما هو)
                Container(
                  height: isMobile ? 300 : 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        children: [
                          // First product image
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: widget.product.imageurl != null
                                    ? CustomNetworkImage(
                                        imageUrl: widget.product.imageurl!,
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          // Second product image (same for demo, can be different)
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: widget.product.imageurl != null
                                    ? CustomNetworkImage(
                                        imageUrl: widget.product.imageurl!,
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Dot Indicator at the bottom
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            2,
                            (index) => Container(
                              width: _currentImageIndex == index ? 12 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index
                                    ? const Color(0xFF007BBB)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Product Details Section --- (الكود كما هو)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.product.price} ريال',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF007BBB),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Rating and Reviews
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.product.averageRating.toStringAsFixed(1)} (${widget.product.ratingcount} تقييم)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'الوصف',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Product Details Grid (الكود كما هو)
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _buildDetailItem(
                            'السعر',
                            '${widget.product.price} ريال',
                          ),
                          _buildDetailItem('الفئة', widget.product.category),

                          _buildDetailItem(
                            'صلاحية',
                            '${widget.product.expirationDate} أيام',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Quantity and Add to Cart --- (مع تحديث في دالة onPressed)
                Row(
                  children: [
                    // Quantity Selector (الكود كما هو)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addToCart, // 🎯 استدعاء الدالة المُعدلة
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BBB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'إضافة إلى السلة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    // ... (دالة بناء عنصر التفاصيل كما هي)
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
