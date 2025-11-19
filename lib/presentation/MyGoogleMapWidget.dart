import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart'; // لاستخدام GetX Snackbar والتنقل
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'dart:ui' as ui;

import 'package:hotel_booking/presentation/screen/home/home_model.dart'; // 🔴🔴🔴 استيراد جديد لـ dart:ui للرسم 🔴🔴🔴


class MapPickerScreen extends StatefulWidget {
  var restAreas = [].obs; // تخزين البيانات هنا

  MapPickerScreen({Key? key, required this.restAreas}) : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {


  // 🔴🔴🔴 ملاحظة: استبدل هذا بعنوان URL الأساسي لصور الاستراحات الخاصة بك 🔴🔴🔴
  // على سبيل المثال: 'http://your-backend-api.com/storage/' أو 'https://esteraha.ly/storage/'
  static const String _imageBaseUrl = 'https://esteraha.ly/public/'; // مثال، يجب تغييره ليناسب backend الخاص بك

  @override
  void initState() {
    super.initState();
    // 🔴🔴🔴 دالة جديدة للتحكم في تسلسل التحميل 🔴🔴🔴

  }


  // 🔴🔴🔴 دالة مساعدة جديدة لإنشاء BitmapDescriptor من نص وشكل دبوس مخصص 🔴🔴🔴





  // 🔴🔴🔴 دالة _addRestAreaMarkers أصبحت async 🔴🔴🔴
  void _addRestAreaMarkers() async {// مسح العلامات الموجودة قبل الإضافة لتجنب التكرار
    for (final item in widget.restAreas) {
      final String? googleMapsUrl = item['google_maps_location'];
      final String? name = item['name'];
      final int id = item['id'];
      final String? areaType = item['area_type'];
      final int? totalSpace = int.tryParse(item['total_space'].toString());
      final int? maxGuests = int.tryParse(item['max_guests'].toString());
      final String? mainImageRelativePath = item['main_image'];
      final String? price = item['price'];

      debugPrint("googleMapsUrl for ID $id: $googleMapsUrl");


    }
    setState(() {}); // تحديث الواجهة لعرض العلامات بعد إضافة جميع الأيقونات
  }

  // 🔴🔴🔴 دالة جديدة للتحكم في تسلسل التحميل 🔴🔴🔴



  // 🔴🔴🔴 دالة لعرض النافذة المنبثقة (BottomSheet) بتفاصيل الاستراحة 🔴🔴🔴
  void _showRestAreaDetailsBottomSheet({required Map<String, dynamic> restAreaDetails}) {
    final String? name = restAreaDetails['name'];
    final String? mainImageRelativePath = restAreaDetails['main_image'];
    final String? price = restAreaDetails['price'];
    final String? description = restAreaDetails['description'];
    final String? areaType = restAreaDetails['area_type']; // تغيير من widget.restAreasData إلى restAreaDetails
    final int? maxGuests = int.tryParse(restAreaDetails['max_guests'].toString());

    String imageUrl = '';
    if (mainImageRelativePath != null && mainImageRelativePath.isNotEmpty) {
      // بناء رابط الصورة الكامل. تأكد أن _imageBaseUrl صحيح.
      imageUrl = _imageBaseUrl + mainImageRelativePath;
    }
    print(" imageUrl $imageUrl");
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

      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('تم رفض أذونات الموقع. لن تتمكن من تحديد موقعك الحالي.', isError: true);

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar('تم رفض أذونات الموقع بشكل دائم. لا يمكن الوصول إلى الموقع.', isError: true);

      return;
    }


  }

  // 🔴🔴🔴 دالة مساعدة للحصول على موقع افتراضي 🔴🔴🔴



  void _showSnackbar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطأ' : 'معلومة',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }





  @override
  Widget build(BuildContext context) {

    return Container();
  }
}