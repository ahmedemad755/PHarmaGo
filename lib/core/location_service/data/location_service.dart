

// import 'package:introduction_screen/introduction_screen.dart';

// class LocationService {
//   // 1. التحقق من الصلاحيات وجلب الموقع الحالي
//   static Future<Position?> getCurrentPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return null;

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return null;
//     }
    
//     return await Geolocator.getCurrentPosition();
//   }

//   // 2. تحويل الإحداثيات إلى عنوان نصي (Reverse Geocoding)
//   static Future<String> getAddressFromCoords(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng, localeIdentifier: "ar");
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         return "${place.street}, ${place.subLocality}, ${place.locality}";
//       }
//       return "عنوان غير معروف";
//     } catch (e) {
//       return "خطأ في تحديد العنوان";
//     }
//   }
// }