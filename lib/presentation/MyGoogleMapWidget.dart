import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart'; // لاستخدام GetX Snackbar والتنقل
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'dart:ui' as ui;

import 'package:hotel_booking/presentation/screen/home/home_model.dart'; // 🔴🔴🔴 استيراد جديد لـ dart:ui للرسم 🔴🔴🔴

// 🔴🔴🔴 ملاحظات هامة جداً قبل استخدام هذا الودجت 🔴🔴🔴
// ===========================================================================
// 1. أضف الحزم إلى pubspec.yaml وقم بتشغيل 'flutter pub get':
//    افتح ملف 'pubspec.yaml' في جذر مشروعك، وأضف السطرين التاليين ضمن قسم 'dependencies':
//
//    dependencies:
//      flutter:
//        sdk: flutter
//      google_maps_flutter: ^2.x.x # استخدم أحدث إصدار متاح من pub.dev
//      geolocator: ^11.x.x # استخدم أحدث إصدار متاح من pub.dev
//      get: ^4.6.x # تأكد من وجود هذه الحزمة لاستخدام GetX
//
//    بعد إضافة هذه الأسطر، افتح Terminal (أو موجه الأوامر) في جذر مشروعك وشغل الأمر التالي:
//    flutter pub get
//
// 2. أضف مفتاح Google Maps API في إعدادات مشروعك الأصلي (مهم جداً):
//    أ) لأجهزة Android (ملف android/app/src/main/AndroidManifest.xml):
//       داخل وسم <application>، أضف السطر التالي:
//       <meta-data android:name="com.google.android.geo.API_KEY" android:value="AIzaSyDC9WFXg8tjm5UlquX9IVSb2Mkv1wiQjFk"/>
//       ملاحظة: هذا هو المفتاح الذي ذكرته. تأكد من تفعيل خدمات Maps و Places و Geocoding APIs له في Google Cloud Console.
//
//    ب) لأجهزة iOS (ملف ios/Runner/AppDelegate.swift أو ios/Runner/AppDelegate.m):
//       لـ Swift (AppDelegate.swift):
//       import GoogleMaps // أضف هذا الاستيراد في الأعلى
//       ...
//       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOfptionsKey: Any]?) -> Bool {
//         GMSServices.provideAPIKey("AIzaSyDC9WFXg8tjm5UlquX9IVSb2Mkv1wiQjFk") // أضف هذا السطر
//         GeneratedPluginRegistrant.register(with: self)
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//       }
//
//       لـ Objective-C (AppDelegate.m):
//       #import "AppDelegate.h"
//       #import "GeneratedPluginRegistrant.h"
//       @import GoogleMaps; // إضافة هذا السطر
//       ...
//       - (BOOL)application:(UIApplication *)application
//           didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//         [GMSServices provideAPIKey:@"AIzaSyDC9WFXg8tjm5UlquX9IVSb2Mkv1wiQjFk"]; // استبدل بالمفتاح الخاص بك
//         [GeneratedPluginRegistrant registerWithRegistry:self];
//         return [super application:application didFinishLaunchingWithOptions:launchOptions];
//       }
//
// 3. أضف الأذونات إلى ملفات Android و iOS الأصلية (مهم جداً):
//    أ) لأجهزة Android (ملف android/app/src/main/AndroidManifest.xml):
//       داخل وسم <manifest> (قبل وسم <application>)، أضف:
//       <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
//       <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
//
//    ب) لأجهزة iOS (ملف ios/Runner/Info.plist):
//       أضف المفاتيح والقيم التالية داخل وسم <dict>:
//       <key>NSLocationWhenInUseUsageDescription</key>
//       <string>This app needs access to your location to show it on the map and allow you to select a point.</string>
//       <key>NSLocationAlwaysUsageDescription</key>
//       <string>This app needs access to your location to provide location-based services even when closed.</string>
// ===========================================================================


class MapPickerScreen extends StatefulWidget {
  var restAreas = [].obs; // تخزين البيانات هنا

   MapPickerScreen({Key? key, required this.restAreas}) : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentCameraPosition;
  LatLng? _pickedLocation;
  bool _isLoadingLocation = true;
  String _errorMessage = '';
  final Set<Marker> _markers = {};

  // 🔴🔴🔴 ملاحظة: استبدل هذا بعنوان URL الأساسي لصور الاستراحات الخاصة بك 🔴🔴🔴
  // على سبيل المثال: 'http://your-backend-api.com/storage/' أو 'http://10.0.2.2:8000/storage/'
  static const String _imageBaseUrl = 'http://10.0.2.2:8000/storage/'; // مثال، يجب تغييره ليناسب backend الخاص بك

  @override
  void initState() {
    super.initState();
    // 🔴🔴🔴 دالة جديدة للتحكم في تسلسل التحميل 🔴🔴🔴
    _loadMarkersAndDeterminePosition();
  }


  // 🔴🔴🔴 دالة مساعدة جديدة لإنشاء BitmapDescriptor من نص وشكل دبوس مخصص 🔴🔴🔴
  Future<BitmapDescriptor> _getMarkerIcon(String text, {
    Color textColor = Colors.white, // لون النص داخل الأيقونة
    double fontSize = 45.0, // 🔴🔴🔴 تم تكبير حجم الخط هنا من 18.0 إلى 22.0 🔴🔴🔴
    Color backgroundColor = Colors.orange, // لون خلفية الأيقونة (سعر)
    double padding = 8.0, // المسافة الداخلية (padding) حول النص
    double borderRadius = 8.0, // نصف قطر حواف الجزء العلوي المستطيل
    double pinPointRadius = 6.0, // نصف قطر الدائرة السفلية (نقطة الدبوس)
    double pinPointOffset = 5.0, // المسافة التي يبتعدها الدبوس عن المستطيل
  }) async {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr, // اتجاه النص، مهم للغات مثل العربية
      maxLines: 1,
    );

    textPainter.layout(); // حساب حجم النص

    // حساب أبعاد الجزء العلوي المستطيل من الدبوس
    final double rectWidth = textPainter.width + padding * 2;
    final double rectHeight = textPainter.height + padding * 2;

    // حساب الارتفاع الكلي للدبوس (الجزء المستطيل + المسافة + نقطة الدبوس)
    final double totalHeight = rectHeight + pinPointOffset + pinPointRadius;
    final double totalWidth = rectWidth; // العرض الكلي هو عرض المستطيل

    // إنشاء مسجل للرسم
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    // 1. رسم الجزء العلوي المستطيل من الدبوس بحواف دائرية
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, rectWidth, rectHeight),
      Radius.circular(borderRadius),
    );
    final Paint rectPaint = Paint()..color = backgroundColor;
    canvas.drawRRect(rRect, rectPaint);

    // 2. رسم نقطة الدبوس السفلية (دائرة)
    final Paint circlePaint = Paint()..color = backgroundColor; // نفس لون الخلفية
    final Offset circleCenter = Offset(rectWidth / 2, rectHeight + pinPointOffset);
    canvas.drawCircle(circleCenter, pinPointRadius, circlePaint);

    // 3. رسم النص في منتصف الجزء المستطيل
    textPainter.paint(canvas, Offset(padding, padding));

    // تحويل الرسم إلى صورة
    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  LatLng? _extractLatLngFromGoogleMapsUrl(String url) {
    RegExp regex = RegExp(r'@(-?\d+\.?\d*),(-?\d+\.?\d*)');
    Match? match = regex.firstMatch(url);

    if (match != null && match.groupCount == 2) {
      try {
        final double lat = double.parse(match.group(1)!);
        final double lng = double.parse(match.group(2)!);
        return LatLng(lat, lng);
      } catch (e) {
        debugPrint('Error parsing LatLng from @ pattern: $e');
      }
    }

    regex = RegExp(r'!3d(-?\d+\.?\d*)!4d(-?\d+\.?\d*)');
    match = regex.firstMatch(url);
    if (match != null && match.groupCount == 2) {
      try {
        final double lat = double.parse(match.group(1)!);
        final double lng = double.parse(match.group(2)!);
        return LatLng(lat, lng);
      } catch (e) {
        debugPrint('Error parsing LatLng from !3d!4d pattern: $e');
      }
    }

    debugPrint('Could not extract LatLng from URL: $url');
    return null;
  }

  // 🔴🔴🔴 دالة _addRestAreaMarkers أصبحت async 🔴🔴🔴
  void _addRestAreaMarkers() async {
    _markers.clear(); // مسح العلامات الموجودة قبل الإضافة لتجنب التكرار
    for (final item in widget.restAreas) {
      final String? googleMapsUrl = item['google_maps_location'];
      final String? name = item['name'];
      final int id = item['id'];
      final String? areaType = item['area_type'];
      final int? totalSpace = item['total_space'];
      final int? maxGuests = item['max_guests'];
      final String? mainImageRelativePath = item['main_image'];
      final String? price = item['price'];

      debugPrint("googleMapsUrl for ID $id: $googleMapsUrl");

      if (googleMapsUrl != null && googleMapsUrl.isNotEmpty) {
        final LatLng? location = _extractLatLngFromGoogleMapsUrl(googleMapsUrl);
        if (location != null) {
          final String priceText = price != null && price.isNotEmpty ? '$price د.ل' : 'السعر؟';
          // 🔴🔴🔴 استخدام الأيقونة المخصصة للسعر (شكل دبوس) 🔴🔴🔴
          final BitmapDescriptor customPriceIcon = await _getMarkerIcon(priceText);

          _markers.add(
            Marker(
              markerId: MarkerId('rest_area_$id'),
              position: location,
              icon: customPriceIcon, // 🔴🔴🔴 استخدام الأيقونة المخصصة للسعر هنا 🔴🔴🔴
              onTap: () {
                _showRestAreaDetailsBottomSheet(
                  restAreaDetails: item, // تمرير جميع بيانات الاستراحة
                );
              },
            ),
          );
        }
      }
    }
    setState(() {}); // تحديث الواجهة لعرض العلامات بعد إضافة جميع الأيقونات
  }

  // 🔴🔴🔴 دالة جديدة للتحكم في تسلسل التحميل 🔴🔴🔴
  Future<void> _loadMarkersAndDeterminePosition() async {
    setState(() {
      _isLoadingLocation = true; // بدء التحميل
      _errorMessage = '';
    });

     _addRestAreaMarkers(); // أولاً، قم بتوليد علامات المواقع الثابتة

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('خدمات الموقع معطلة. يرجى تفعيلها.', isError: true);
      _errorMessage = 'خدمات الموقع معطلة.';
      _currentCameraPosition = _getDefaultCameraPosition(); // استخدام موقع افتراضي
      _pickedLocation = _currentCameraPosition;
      setState(() { _isLoadingLocation = false; }); // إنهاء التحميل
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('تم رفض أذونات الموقع. لن تتمكن من تحديد موقعك الحالي.', isError: true);
        _errorMessage = 'تم رفض أذونات الموقع.';
        _currentCameraPosition = _getDefaultCameraPosition(); // استخدام موقع افتراضي
        _pickedLocation = _currentCameraPosition;
        setState(() { _isLoadingLocation = false; }); // إنهاء التحميل
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar('تم رفض أذونات الموقع بشكل دائم. لا يمكن الوصول إلى الموقع.', isError: true);
      _errorMessage = 'تم رفض أذونات الموقع بشكل دائم.';
      _currentCameraPosition = _getDefaultCameraPosition(); // استخدام موقع افتراضي
      _pickedLocation = _currentCameraPosition;
      setState(() { _isLoadingLocation = false; }); // إنهاء التحميل
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentCameraPosition = LatLng(position.latitude, position.longitude);
        _pickedLocation = _currentCameraPosition;
        _isLoadingLocation = false; // إنهاء التحميل بنجاح
      });
      // حرك الكاميرا فوراً إلى الموقع الحالي إذا كانت الخريطة جاهزة
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentCameraPosition!,
            zoom: 15.0,
          ),
        ),
      );
      debugPrint('Current location obtained: $_currentCameraPosition');
    } catch (e) {
      _showSnackbar('تعذر الحصول على الموقع الحالي: $e', isError: true);
      debugPrint('Error getting current location: $e');
      setState(() {
        _errorMessage = 'تعذر الحصول على الموقع الحالي.';
        _isLoadingLocation = false; // إنهاء التحميل بخطأ
        _currentCameraPosition = _getDefaultCameraPosition(); // استخدام موقع افتراضي
        _pickedLocation = _currentCameraPosition;
      });
    }
  }


  // 🔴🔴🔴 دالة لعرض النافذة المنبثقة (BottomSheet) بتفاصيل الاستراحة 🔴🔴🔴
  void _showRestAreaDetailsBottomSheet({required Map<String, dynamic> restAreaDetails}) {
    final String? name = restAreaDetails['name'];
    final String? mainImageRelativePath = restAreaDetails['main_image'];
    final String? price = restAreaDetails['price'];
    final String? description = restAreaDetails['description'];
    final String? areaType = restAreaDetails['area_type']; // تغيير من widget.restAreasData إلى restAreaDetails
    final int? maxGuests = restAreaDetails['max_guests'];

    String imageUrl = '';
    if (mainImageRelativePath != null && mainImageRelativePath.isNotEmpty) {
      // بناء رابط الصورة الكامل. تأكد أن _imageBaseUrl صحيح.
      imageUrl = _imageBaseUrl + mainImageRelativePath;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // للسماح للـ BottomSheet بأخذ ارتفاع متغير
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, // للتعامل مع لوحة المفاتيح
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // صورة الاستراحة
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('لا توجد صورة متاحة', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              const SizedBox(height: 15),
              // اسم الاستراحة
              Text(
                name ?? 'اسم الاستراحة غير متوفر',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // سعر الاستراحة
              Text(
                'السعر: ${price ?? 'غير متوفر'} دينار ليبي / الليلة',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              // بعض البيانات الإضافية
              if (areaType != null && areaType.isNotEmpty)
                Text(
                  'النوع: $areaType',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              if (maxGuests != null)
                Text(
                  'الضيوف: $maxGuests كحد أقصى',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              const SizedBox(height: 10),
              // زر لعرض المزيد من التفاصيل (يمكنك ربطه بشاشة تفاصيل الاستراحة)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Detail detail = Detail.fromJson(restAreaDetails);

                    // إضافة الكائن إلى homeDetails إذا كان ذلك مطلوبًا
                    //controller.homeDetails.add(detail);


                    Get.toNamed("/hotelDetail", arguments: {'data': restAreaDetails});
                    print("reservation");
                    print(restAreaDetails);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'عرض التفاصيل الكاملة',
                    style: TextStyle(fontSize: 16, color: Colors.white,fontFamily: 'Tajawal'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _determineInitialPosition() async {
    // هذه الدالة الآن يتم استدعاؤها من _loadMarkersAndDeterminePosition
    // وتتولى فقط منطق الحصول على الموقع دون تغيير حالة التحميل الكلية
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('خدمات الموقع معطلة. يرجى تفعيلها.', isError: true);
      _errorMessage = 'خدمات الموقع معطلة.';
      _currentCameraPosition = _getDefaultCameraPosition();
      _pickedLocation = _currentCameraPosition;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('تم رفض أذونات الموقع. لن تتمكن من تحديد موقعك الحالي.', isError: true);
        _errorMessage = 'تم رفض أذونات الموقع.';
        _currentCameraPosition = _getDefaultCameraPosition();
        _pickedLocation = _currentCameraPosition;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar('تم رفض أذونات الموقع بشكل دائم. لا يمكن الوصول إلى الموقع.', isError: true);
      _errorMessage = 'تم رفض أذونات الموقع بشكل دائم.';
      _currentCameraPosition = _getDefaultCameraPosition();
      _pickedLocation = _currentCameraPosition;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() { // setState هنا فقط لتحديث _currentCameraPosition و _pickedLocation
        _currentCameraPosition = LatLng(position.latitude, position.longitude);
        _pickedLocation = _currentCameraPosition;
      });
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentCameraPosition!,
            zoom: 15.0,
          ),
        ),
      );
      debugPrint('Current location obtained: $_currentCameraPosition');
    } catch (e) {
      _showSnackbar('تعذر الحصول على الموقع الحالي: $e', isError: true);
      debugPrint('Error getting current location: $e');
      setState(() { // setState هنا فقط لتحديث _currentCameraPosition و _pickedLocation
        _errorMessage = 'تعذر الحصول على الموقع الحالي.';
        _currentCameraPosition = _getDefaultCameraPosition();
        _pickedLocation = _currentCameraPosition;
      });
    }
  }

  // 🔴🔴🔴 دالة مساعدة للحصول على موقع افتراضي 🔴🔴🔴
  LatLng _getDefaultCameraPosition() {
    if (widget.restAreas.isNotEmpty) {
      for (final item in widget.restAreas) {
        final String? googleMapsUrl = item['google_maps_location'];
        if (googleMapsUrl != null && googleMapsUrl.isNotEmpty) {
          final LatLng? location = _extractLatLngFromGoogleMapsUrl(googleMapsUrl);
          if (location != null) {
            return location; // استخدم موقع أول استراحة كافتراضي
          }
        }
      }
    }
    return const LatLng(30.033333, 31.233334); // القاهرة كموقع احتياطي
  }


  void _showSnackbar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطأ' : 'معلومة',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentCameraPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentCameraPosition!,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentCameraPosition = position.target;
  }

  void _onCameraIdle() {
    setState(() {
      _pickedLocation = _currentCameraPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(

          title: Text('الإستراحات القريبة',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Tajawal',
              )),
          centerTitle: true,
          backgroundColor: MyColors.primaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: MyColors.white),
        ),
        body: Stack(
          children: [
            _isLoadingLocation || _currentCameraPosition == null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(_errorMessage.isNotEmpty
                      ? _errorMessage
                      : 'جاري تحديد موقعك الحالي...'),
                ],
              ),
            )
                : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentCameraPosition!,
                zoom: 15.0,
              ),
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              markers: _markers,
            ),
            if (!_isLoadingLocation && _currentCameraPosition != null)
              const Center(
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    if (_pickedLocation != null)
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'الموقع الحالي: خط عرض: ${_pickedLocation!.latitude.toStringAsFixed(6)}, خط طول: ${_pickedLocation!.longitude.toStringAsFixed(6)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                 //   ElevatedButton.icon(
                    //                     onPressed: _pickedLocation == null
                    //                         ? null
                    //                         : () {
                    //                       Get.back(result: _pickedLocation);
                    //                     },
                    //                     icon: const Icon(Icons.check, color: Colors.white),
                    //                     label: const Text(
                    //                       'تأكيد الموقع',
                    //                       style: TextStyle(fontSize: 18, color: Colors.white),
                    //                     ),
                    //                     style: ElevatedButton.styleFrom(
                    //                       backgroundColor: Colors.blueAccent,
                    //                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    //                       shape: RoundedRectangleBorder(
                    //                         borderRadius: BorderRadius.circular(10),
                    //                       ),
                    //                     ),
                    //                   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}