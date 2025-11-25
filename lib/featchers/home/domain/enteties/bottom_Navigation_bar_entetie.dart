class BottomNavigationbarEntety {
  final String activimag;
  final String inactivimag;
  final String name;

  BottomNavigationbarEntety({
    required this.activimag,
    required this.inactivimag,
    required this.name,
  });
}

List<BottomNavigationbarEntety> get bottomNavigationbarEntetie => [
  BottomNavigationbarEntety(
    activimag: "assets/active_home.svg",
    inactivimag: "assets/inactive_home.svg",
    name: "الرئيسيه",
  ),
  BottomNavigationbarEntety(
    activimag: "assets/active_product.svg",
    inactivimag: "assets/inactive_product.svg",
    name: "المنتجات",
  ),
  BottomNavigationbarEntety(
    activimag: "assets/active_shopping-cart.svg",
    inactivimag: "assets/inactive_shopping-cart.svg",
    name: "سلة التسوق",
  ),
  BottomNavigationbarEntety(
    activimag: "assets/active_user.svg",
    inactivimag: "assets/inactive_user.svg",
    name: "الشخصيه",
  ),
];
