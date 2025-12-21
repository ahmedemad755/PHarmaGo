import 'dart:convert';

import 'package:e_commerce/core/enteties/product_enteti.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/repos/cart_repo/cart_repo.dart';
import 'package:e_commerce/core/services/shared_prefs_singelton.dart';

class CartRepoImpl extends CartRepo {
  static const String kCartKey = 'cart_items';

  @override
  Future<void> addProductToCart(AddProductIntety product) async {
    // 1. جلب القائمة الحالية
    List<AddProductIntety> currentCart = getCartProducts();
    
    // 2. إضافة المنتج الجديد (يمكنك هنا إضافة منطق التأكد إذا كان المنتج موجود مسبقاً)
    currentCart.add(product);
    
    // 3. تحويل الـ Entities إلى Models ثم إلى JSON
    List<String> jsonData = currentCart.map((e) {
      // نحول الـ Entity لموديل عشان نستخدم toJson
      return jsonEncode(AddProductModel.fromentity(e).toJson());
    }).toList();

    await Prefs.setString(kCartKey, jsonData as String);
  }

  @override
  List<AddProductIntety> getCartProducts() {
    String? jsonData = Prefs.getString(kCartKey);
    
    if (jsonData != null) {
      return jsonDecode(jsonData).map<AddProductIntety>((e) {
        return AddProductModel.fromJson(e).toEntity();
      }).toList();
    }
    return [];
  }

  @override
  Future<void> clearCart() async {
    await Prefs.remove(kCartKey);
  }
}