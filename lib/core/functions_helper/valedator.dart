class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الاسم الكامل';
    }
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF ]+$').hasMatch(value)) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$').hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صالح';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال العنوان';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال المدينة';
    }
    return null;
  }

  static String? validateFloor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الطابق أو الشقة';
    }
    return null;
  }
}
