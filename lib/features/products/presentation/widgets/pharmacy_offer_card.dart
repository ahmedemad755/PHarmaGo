import 'package:e_commerce/Features/products/presentation/models/pharmacy_offer.dart';
import 'package:flutter/material.dart';

class PharmacyOfferCard extends StatelessWidget {
  const PharmacyOfferCard({
    super.key,
    required this.offer,
    required this.isSelected,
    required this.onSelected,
  });

  final PharmacyOffer offer;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = offer.isAvailable;
    final double displayPrice = offer.finalPrice;

    return GestureDetector(
      onTap: isAvailable ? onSelected : null,
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
              child: Icon(
                Icons.store,
                color: isAvailable ? const Color(0xFF007BBB) : Colors.grey,
              ),
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
                  Text(
                    "${offer.distanceKm.toStringAsFixed(1)} كم بعيداً عنك",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2), // مسافة بسيطة
                  Text(
                    offer.address,
                    style: TextStyle(
                      fontSize: 11,
                      color: isAvailable ? Colors.grey[600] : Colors.grey[400],
                    ),
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
                  '${displayPrice.toStringAsFixed(2)} جنيه ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isAvailable ? const Color(0xFF007BBB) : Colors.grey,
                  ),
                ),
                Radio<String>(
                  value: offer.id,
                  groupValue: isSelected ? offer.id : null,
                  activeColor: const Color(0xFF007BBB),
                  onChanged: isAvailable
                      ? (val) {
                          if (val != null) onSelected();
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
