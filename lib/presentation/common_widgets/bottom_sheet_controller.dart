import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/City.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/core/themes/themes_controller.dart';
import 'package:dio/dio.dart';
class BottomSheetController extends GetxController {
   final ThemeController themeController = Get.put(ThemeController());

   var cities = [].obs; // متغير لتخزين الحجوزات
   var selectedCityIndex = (-1).obs; // لا يوجد اختيار افتراضيًا
   var selectedCityId = (-1).obs; // تخزين رقم المدينة الفعلي
   var isLoading = false.obs;
   RxInt selectedCountry = 99.obs;
   RxInt selectedResult = 99.obs;
   RxInt selectedTime = 99.obs;
   RxString selectedTimeString = "".obs;
   RxInt selectedRate = (-1).obs;
   RxBool selectedCheckBox = false.obs;
   Rx<RangeValues> sliderValue = const RangeValues(30,70).obs;
   final Dio dio = Dio();

   @override
   void onInit() {
      fetchCities();
      super.onInit();
   }

   RxList<bool> selectedAccommodationName = List.generate(MyString.accommodationName.length, (index) => false).obs;
   RxList<bool> selectedFacilities = List.generate(MyString.facilitiesName.length, (index) => false).obs;

   void changeSliderValue(RangeValues values) {
      sliderValue.value = values;
   }
   // جلب المدن من API
   Future<void> fetchCities() async {
      try {
         isLoading.value = true;


         final response = await Dio().get('http://10.0.2.2:8000/api/cities');

         if (response.statusCode == 200) {
            cities.value = (response.data['cities'] as List)
                .map((cityJson) => City.fromJson(cityJson))
                .toList();
            print("cities");
            print(cities.value);  // ستظهر قائمة من كائنات City

         } else {
            Get.snackbar('خطأ', 'فشل في جلب البيانات');
         }
      } catch (e) {
         Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: $e');
         print('حدث خطأ أثناء جلب البيانات: $e');
      } finally {
         isLoading.value = false;
      }
   }
}