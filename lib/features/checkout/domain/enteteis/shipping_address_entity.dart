class ShippingAddressEntity {
  String? name;
  String? phone;
  String? address;
  String? city;
  String? email;
  String? floor;

  ShippingAddressEntity({
    this.name,
    this.phone,
    this.address,
    this.floor,
    this.city,
    this.email,
  });

  String toStrings() {
    final parts = [
      address,
      floor,
      city,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
    return parts.isNotEmpty ? parts : 'لم يتم تحديد العنوان بعد';
  }
}
