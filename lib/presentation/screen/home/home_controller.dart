part of 'home_import.dart';

class HomeController extends GetxController {
   final ThemeController themeController = Get.put(ThemeController());
   var sliderValue = const RangeValues(0, 100).obs; // القيم الافتراضية لشريط التمرير
   var priceMin = 0.obs; // الحد الأدنى للسعر
   var priceMax = 0.obs; // الحد الأقصى للسعر
   RxMap<int, bool> paymentStatusMap = <int, bool>{}.obs;
   RxInt selectedButton = 0.obs;
   RxBool bookMark = false.obs;
   RxInt selectedItem = 0.obs;
   RxBool isLoading = true.obs;
   var passingStatus = ''.obs; // لتخزين الفلتر الحالي
   var reservations = [].obs; // متغير لتخزين الحجوزات
   var filteredReservations = [].obs;
   RxList<Detail> homeDetails = <Detail>[].obs;
   var filterListView = [].obs; // القائمة التي ستُعرض في واجهة المستخدم
   var selectedGeoArea = "وسط البلاد".obs; // قيمة افتراضية
   var recentlyBooked = [].obs;
   var recently = [].obs;
   String? token;
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
     filteredReservations.value = reservations.where((element) {
       return element['status'].toString().toLowerCase() == status.toLowerCase();
     }).toList();
   }



   void toggleRestAreaActiveStatus(int id) async {
     // نفّذ هنا طلب HTTP أو تعديل الحالة في القائمة حسب مشروعك
     // مثلاً:
     final index = restAreas.indexWhere((r) => r["id"] == id);
     if (index != -1) {
       final current = restAreas[index]["is_active"] ?? false;
       restAreas[index]["is_active"] = !current;
       restAreas.refresh();
       // ويمكنك استدعاء API لتحديث الحالة في السيرفر
     }
   }
   bool hasUnpaidRestAreas() {
     return paymentStatusMap.values.any((paid) => paid == false);
   }
   Future<Map<int, bool>> checkPaymentStatus(List<int> restAreaIds) async {
     try {
       final response = await Dio().post(
         'http://10.0.2.2:8000/api/check-payment-status',
         data: {
           'rest_area_ids': restAreaIds,
         },
       );

       if (response.statusCode == 200) {
         final List data = response.data['data'];
         print("استجابة فحص الدفع: $data");

         // تأكد أن البيانات ليست فارغة
         if (data.isEmpty) {
           print("⚠️ لم يتم إرجاع بيانات لحالة الدفع.");
           return {};
         }

         // تحويل البيانات إلى خريطة Map: rest_area_id => paid
         return {
           for (var item in data) item['rest_area_id'] as int: item['paid'] == true
         };
       } else {
         print("⚠️ فشل في جلب حالة الدفع. كود الاستجابة: ${response.statusCode}");
         return {};
       }
     } catch (e) {
       print("❌ خطأ في فحص الدفع: $e");
       return {};
     }
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
   Future<void> getReservations({bool isHost=false}) async {
     try {
       isLoading.value = true;
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       token = prefs.getString('token');
       String? userType = prefs.getString('user_type');
       if(userType=="host"){
         isHost=true;
         print("isHost $userType");
       }



       print("tokenss ${token}");
       final response = await Dio().get(
         'http://10.0.2.2:8000/api/reservations',

         options: Options(
           headers: {
             'Authorization': 'Bearer $token',
             'Accept': 'application/json',
           },
         ),
         data: {
           'type': isHost ? 'host' : 'user', // استخدم هذا حسب الحالة
         },
       );
       if (response.statusCode == 200) {
         print("response.data5");
         print(response.data);
         reservations.value = response.data['reservations']; // تخزين البيانات في المتغير
         filteredReservations.value = List.from(reservations); // مبدئياً نعرض الكل
         filterList('pending'); // أول فلتر افتراضي
         print(" reservations.value");
         print(response.statusCode);
         print( reservations.value);

       } else {
         //Get.snackbar('خطأ', 'فشل في جلب البيانات') ;
       }
     } catch (e) {
       //Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البياناتس: $e');
      print('حدث خطأ أثناء جلب البياناsت: $e');
     } finally {
       isLoading.value = false;
     }
   }





   Future<void> getRestAreas({
     String? areaTypes,
     int? priceMin,
     int? priceMax,
     int? cityId,
     int? hostId,
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
       // إضافة host_id إذا كان موجودًا
       if (hostId != null && hostId >= 0) {
         queryParameters['host_id'] = hostId;
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
       print('حدث خطأ أثناء جلب س: $e');
     } finally {
       isLoading.value = false;
     }
   }
   Future<void> fetchRecentlyBooked({String? filter,bool isHost=false}) async {
     isLoading.value = true;
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     String? token = prefs.getString('token');
     String? userType = prefs.getString('user_type');
     if(userType=="host"){
       isHost=true;
       print("isHost $userType");
     }
     try {

       final response = await Dio().get(
         'http://10.0.2.2:8000/api/most-booked',
         options: Options(
           headers: {
             'Authorization': 'Bearer $token',
             'Accept': 'application/json',
           },
         ),
         data: {
           'type': isHost ? 'host' : 'user', // استخدم هذا حسب الحالة
         },
       );
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
