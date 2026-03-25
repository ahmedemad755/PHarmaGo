// import 'package:e_commerce/core/location_service/data/location_service.dart';
// import 'package:e_commerce/core/location_service/domain/models/user_location_model.dart';
// import 'package:flutter/material.dart';


// class MapPickerWidget extends StatefulWidget {
//   final Function(UserLocationModel) onLocationSelected;

//   const MapPickerWidget({super.key, required this.onLocationSelected});

//   @override
//   State<MapPickerWidget> createState() => _MapPickerWidgetState();
// }

// class _MapPickerWidgetState extends State<MapPickerWidget> {
//   LatLng _currentCenter = const LatLng(30.0444, 31.2357); // القاهرة كافتراضي
//   String _addressDisplay = "حرك الخريطة لاختيار الموقع";
//   bool _isLoading = false;

//   void _onCameraMove(CameraPosition position) {
//     _currentCenter = position.target;
//   }

//   // يتم استدعاؤها عند توقف حركة الخريطة لجلب العنوان الجديد
//   void _onCameraIdle() async {
//     setState(() => _isLoading = true);
//     String addr = await LocationService.getAddressFromCoords(
//         _currentCenter.latitude, _currentCenter.longitude);
//     setState(() {
//       _addressDisplay = addr;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       app_body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(target: _currentCenter, zoom: 15),
//             onCameraMove: _onCameraMove,
//             onCameraIdle: _onCameraIdle,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//           ),
//           // دبوس في منتصف الشاشة ثابت
//           const Center(
//             child: Icon(Icons.location_on, size: 50, color: Color(0xFF007BBB)),
//           ),
//           // بطاقة عرض العنوان في الأعلى
//           Positioned(
//             top: 50, left: 20, right: 20,
//             child: Container(
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//               child: Text(_isLoading ? "جاري التحديد..." : _addressDisplay, textAlign: TextAlign.center),
//             ),
//           ),
//           // زر التأكيد في الأسفل
//           Positioned(
//             bottom: 30, left: 20, right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 widget.onLocationSelected(UserLocationModel(
//                   latitude: _currentCenter.latitude,
//                   longitude: _currentCenter.longitude,
//                   address: _addressDisplay,
//                 ));
//                 Navigator.pop(context);
//               },
//               child: const Text("تأكيد العنوان"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }