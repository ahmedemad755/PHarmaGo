import 'dart:async';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/widgets/custom_search_filter_bar_home_products.dart';
import 'package:e_commerce/maps/business_logic/cubit/maps/maps_cubit.dart';
import 'package:e_commerce/maps/data/models/placesugestion.dart';
import 'package:e_commerce/maps/helpers/location_helper.dart';
import 'package:e_commerce/maps/presentation/widgets/place.dart';
import 'package:e_commerce/maps/presentation/widgets/place_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? position;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  
  // 2. استبدال الـ Controller القديم بـ TextEditingController القياسي
  final TextEditingController _searchController = TextEditingController();

  List<PlaceSuggestion> places = [];
  Set<Marker> markers = {};

  // إحداثيات النقطة اللي في نص الشاشة حالياً
  late LatLng _currentMapCenter;

  @override
  void initState() {
    super.initState();
    _getMyCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose(); // تنظيف الـ Controller عند إغلاق الشاشة
    super.dispose();
  }

  Future<void> _getMyCurrentLocation() async {
    try {
      Position p = await LocationHelper.getCurrentLocation();
      setState(() {
        position = p;
        _currentMapCenter = LatLng(p.latitude, p.longitude);
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    final String googleApiKey = "AIzaSyBqylu7OAYPkQC8HfSBTjrg8vDWeHkApvQ";
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey&language=ar';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200 && response.data['results'].isNotEmpty) {
        return response.data['results'][0]['formatted_address'];
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
    return "موقع مجهول";
  }

  // تحريك الكاميرا لمكان البحث
  Future<void> _goToMySelectedPlace(Place place) async {
    final LatLng selectedLatLng = LatLng(place.lat, place.lng);
    final GoogleMapController controller = await _mapControllerCompleter.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLatLng, zoom: 17),
      ),
    );
  }

  Widget buildMap() {
    if (position == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 17,
      ),
      onMapCreated: (controller) {
        if (!_mapControllerCompleter.isCompleted) {
          _mapControllerCompleter.complete(controller);
        }
      },
      onCameraMove: (CameraPosition cameraPosition) {
        _currentMapCenter = cameraPosition.target;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الـ Map في الخلفية
          position != null
              ? buildMap()
              : const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),

          // 3. شريط البحث المخصص مع قائمة الاقتراحات منسدلة تحته
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSearchFilterBar(
                  controller: _searchController,
                  hintText: 'ابحث عن منطقة أو شارع..',
                  onFilterTap: () {
                    // كود الفلترة إذا أردت فتح BottomSheet لاحقاً
                  },
                  onSearchChanged: (query) {
                    final sessionToken = const Uuid().v4();
                    BlocProvider.of<MapsCubit>(context)
                        .emitPlaceSuggestions(query, sessionToken);
                  },
                ),
                const SizedBox(height: 5),
                // عرض الاقتراحات مباشرة أسفل شريط البحث
                buildSuggestionsBloc(),
              ],
            ),
          ),

          // 4. أيقونة الماركر الثابتة في منتصف الشاشة
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Icon(
                Icons.location_on,
                color: Colors.red.shade700,
                size: 50,
              ),
            ),
          ),

          // 5. أزرار التحكم السفلى وزر التأكيد
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    onPressed: () async {
                      await _getMyCurrentLocation();
                      final GoogleMapController controller =
                          await _mapControllerCompleter.future;
                      controller.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(position!.latitude, position!.longitude),
                        ),
                      );
                    },
                    backgroundColor: Colors.white,
                    mini: true,
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      String fullAddress = await _getAddressFromLatLng(
                        _currentMapCenter,
                      );

                      if (mounted) {
                        Navigator.pop(context, {
                          'lat': _currentMapCenter.latitude,
                          'lng': _currentMapCenter.longitude,
                          'address': fullAddress,
                        });
                      }
                    },
                    child: const Text(
                      'تأكيد موقع الصيدلية',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Listener لمراقبة الحالة والانتقال للمكان المحدد
          BlocListener<MapsCubit, MapsState>(
            listener: (context, state) {
              if (state is PlaceLocationLoaded) {
                _goToMySelectedPlace(state.place);
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // 6. عرض قائمة الاقتراحات بناءً على الـ BLoC State الحالي
  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded && state.places.isNotEmpty) {
          return Container(
            constraints: const BoxConstraints(maxHeight: 240), // تحديد أقصى ارتفاع للقائمة
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const ClampingScrollPhysics(),
              itemCount: state.places.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    // إغلاق الكيبورد وتنظيف الاقتراحات عبر إرسال حدث فارغ أو تغيير النص
                    FocusScope.of(context).unfocus();
                    _searchController.text = state.places[index].description;
                    
                    final sessionToken = const Uuid().v4();
                    BlocProvider.of<MapsCubit>(context).emitPlaceLocation(
                      state.places[index].placeId,
                      sessionToken,
                    );
                    
                    // لتصفير القائمة بعد الاختيار
                    setState(() {
                      state.places.clear(); 
                    });
                  },
                  child: PlaceItem(suggestion: state.places[index]),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}