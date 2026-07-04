import 'package:e_commerce/Features/products/presentation/models/pharmacy_offer.dart';
import 'package:e_commerce/Features/products/presentation/widgets/pharmacy_offer_card.dart';
import 'package:flutter/material.dart';

class PharmacyOffersList extends StatelessWidget {
  const PharmacyOffersList({
    super.key,
    required this.offers,
    required this.selectedOffer,
    required this.onOfferSelected,
  });

  final List<PharmacyOffer> offers;
  final PharmacyOffer? selectedOffer;
  final ValueChanged<PharmacyOffer> onOfferSelected;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offers.length,
      separatorBuilder: (c, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final offer = offers[index];
        return PharmacyOfferCard(
          offer: offer,
          isSelected: selectedOffer?.id == offer.id,
          onSelected: () => onOfferSelected(offer),
        );
      },
    );
  }
}
