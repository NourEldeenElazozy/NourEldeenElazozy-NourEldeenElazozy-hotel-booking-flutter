part of 'home_import.dart';

class HomeController extends GetxController {
   final ThemeController themeController = Get.put(ThemeController());
   var sliderValue = const RangeValues(0, 100).obs; // القيم الافتراضية لشريط التمرير
   var priceMin = 0.obs; // الحد الأدنى للسعر
   var priceMax = 0.obs; // الحد الأقصى للسعر

   RxInt selectedButton = 0.obs;
   RxBool bookMark = false.obs;
   RxInt selectedItem = 0.obs;
   RxBool isLoading = true.obs;
   RxString passingStatus = 'Recommended'.obs;
   var reservations = [].obs; // متغير لتخزين الحجوزات
   RxList<Detail> homeDetails = <Detail>[].obs;
   List<Detail> filterListView = <Detail>[].obs;
   var selectedGeoArea = "وسط البلاد".obs; // قيمة افتراضية
   var recentlyBooked = [].obs;
   var recently = [].obs;
   RxList<bool> selectedFacilities = List.generate(MyString.facilities.length, (index) => false).obs;
   var restAreas = [].obs; // تخزين البيانات هنا
    @override
    void onInit() {
        //getRecentlyBooked();
        fetchRecentlyBooked(); // جلب البيانات عند بدء التطبيق
        getReservations();
        getRestAreas();
      super.onInit();
   }
   static Map<String, String> facilitiesMap = {
     "واي فاي": "free_wifi",
     "مسبح": "pool",
     "موقف سيارات": "garage",
     "مطعم": "restaurant",
     "تدفئة وتكييف": "has_ac_heating",
     "شاشات تلفزيون": "tv_screens",
     "مطبخ متاح": "kitchen_available",
     "حمام خارجي": "outdoor_bathroom",
     "مساحة خارجية": "outdoor_space",
     "مساحة عشب": "grass_space",
     "تدفئة للمسبح": "pool_heating",
     "فلتر للمسبح": "pool_filter",
     "أماكن جلوس خارجية": "outdoor_seating",
     "ألعاب للأطفال": "children_games",
     "مطبخ خارجي": "outdoor_kitchen",
     "مكان للذبح": "slaughter_place",
     "بئر": "well",
     "مولد كهربائي": "power_generator",
   };
   void filterList(String status) {
     filterListView.clear();
     //filterListView.addAll(homeDetails.where((element) => element.status == status));
   }

   Future<List<Detail>> getHomeDetail() async {

     isLoading.value = true;
     try{
       String jsonData = await rootBundle.loadString("assets/data/homeDetails.json");
       dynamic data = json.decode(jsonData);
       List<dynamic> jsonArray = data['details'];
       homeDetails.clear();

       for (int i = 0; i < jsonArray.length; i++) {
         homeDetails.add(Detail.fromJson(jsonArray[i]));
       }
       filterList(passingStatus.value);
       isLoading.value = false;
       return homeDetails;
     } catch(e) {
       isLoading.value = false;
       return [];
     }
   }

  /*
   Future<List<RecentlyBook>> getRecentlyBooked() async {
      String jsonData = await rootBundle.loadString("assets/data/recentlyBookHotel.json");
      dynamic data = json.decode(jsonData);
      List<dynamic> jsonArray = data['recentlyBook'];
      for (int i = 0 ; i < jsonArray.length ; i++) {
         recentlyBooked.add(RecentlyBook.fromJson(jsonArray[i]));
      }
      return recentlyBooked;
   }
   */
   Future<void> getReservations() async {
     try {
       isLoading.value = true;


       final response = await Dio().get('http://10.0.2.2:8000/api/reservations');

       if (response.statusCode == 200) {
         reservations.value = response.data['reservations']; // تخزين البيانات في المتغير
         print( reservations.value);

       } else {
         Get.snackbar('خطأ', 'فشل في جلب البيانات') ;
       }
     } catch (e) {
       Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: $e');
      print('حدث خطأ أثناء جلب البيانات: $e');
     } finally {
       isLoading.value = false;
     }
   }





   Future<void> getRestAreas({
     String? areaTypes,
     int? priceMin,
     int? priceMax,
     int? cityId,
     int? rating,
     String? sortBy,
     String? geoArea ,
     int? maxGuests, // إضافة معامل عدد الأفراد
     List<String>? selectedFacilities, // إضافة هذا المعامل
   }) async {
     try {
       isLoading.value = true;

       // إعداد معلمات الطلب
       final queryParameters = <String, dynamic>{};

       // إضافة area_type إذا كان موجودًا
       if (areaTypes != "" && areaTypes!=null) {
         print("areaTypes $areaTypes");
         queryParameters['area_type[]'] = areaTypes;
       }

       // إضافة price_min إذا كان موجودًا
       if (priceMin != null && priceMin > 0) {
         queryParameters['price_min'] = priceMin;
       }

       // إضافة price_max إذا كان موجودًا
       if (priceMax != null && priceMax > 0) {
         queryParameters['price_max'] = priceMax;
       }

       // إضافة city_id إذا كان موجودًا
       if (cityId != null && cityId >= 0) {
         queryParameters['city_id'] = cityId;
       }

       // إضافة rating إذا كان موجودًا
       if ( rating != -1 && rating!=null && rating != 0) {
         queryParameters['rating'] = rating;
       }
       // إضافة max_guests إذا كان موجودًا
       if (maxGuests != null && maxGuests > 0) {
         queryParameters['max_guests'] = maxGuests; // إضافة معامل عدد الأفراد
       }

       // إضافة نوع الترتيب إذا كان موجودًا
       if (sortBy != null) {
         queryParameters["sort_by"] = sortBy;
       }
       if (geoArea != null) {
         queryParameters["geo_area"] = geoArea;
       }

       // إضافة المرافق المختارة
       if (selectedFacilities != null) {
         for (String facility in selectedFacilities) {
           if (facilitiesMap.containsKey(facility)) {
             queryParameters[facilitiesMap[facility].toString()] = 1; // أو يمكنك استخدام القيمة المناسبة
           }
         }
       }

       // طباعة المعاملات
       print("Query Parameters: $queryParameters");

       // إجراء الطلب
       final response = await Dio().get(
         'http://10.0.2.2:8000/api/rest-areas/filter',
         queryParameters: queryParameters,
       );
       restAreas.clear();
       if (response.statusCode == 200) {
         restAreas.value = response.data; // تخزين البيانات في المتغير
         print(restAreas.value);
       } else {
         restAreas.clear();

       }
     } catch (e) {
       Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: $e');
       print('حدث خطأ أثناء جلب البيانات: $e');
     } finally {
       isLoading.value = false;
     }
   }
   Future<void> fetchRecentlyBooked({String? filter}) async {
     isLoading.value = true;

     try {
       String url = 'http://10.0.2.2:8000/api/most-booked';
       final response = await Dio().get(url);

       // تحويل البيانات إلى كائنات RestArea
       print("done $response");
       recently.value =response.data;

       print("recently booked: $recently");
       print(recently[0]['name']);
     } catch (e) {
       print("Error fetching recently booked: $e");
     } finally {
       isLoading.value = false;
     }
   }
}
