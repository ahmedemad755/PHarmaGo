import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class ProductImageCarousel extends StatelessWidget {
  const ProductImageCarousel({
    super.key,
    required this.imageUrl,
    required this.pageController,
    required this.onPageChanged,
    required this.isMobile,
  });

  final String? imageUrl;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 250 : 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              Center(
                child: imageUrl != null
                    ? CustomNetworkImage(imageUrl: imageUrl!)
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
}
