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
   //var filteredReservations = [].obs;
   List<dynamic> _allReservations = []; // استخدم underscore لجعلها خاصة بالكنترولر
   RxList<dynamic> hostRestAreas = <dynamic>[].obs; // قائمة استراحات المضيف
   Rxn<int> selectedRestAreaIdFilter = Rxn<int>(null); // لتخزين ID الاستراحة المختارة للفرز
   RxString selectedDateSortOrder = 'newest'.obs; // 'newest' (الأقرب) أو 'oldest' (الأقدم)
   RxList<dynamic> filteredReservations = <dynamic>[].obs;
   RxList<Detail> homeDetails = <Detail>[].obs;
   var filterListView = [].obs; // القائمة التي ستُعرض في واجهة المستخدم
   var selectedGeoArea = "".obs; // قيمة افتراضية
   var recentlyBooked = [].obs;
   var recently = [].obs;
   String? token;

   var favoriteIds = <int>{}.obs; // Set قابل للملاحظة (Rx)

   //Map<int, bool> paymentStatusMap = {};
   RxList<bool> selectedFacilities = List.generate(MyString.facilities.length, (index) => false).obs;
   var restAreas = [].obs; // تخزين البيانات هنا
   var fav = [].obs; // تخزين البيانات هنا
    @override
    void onInit() {
        //getRecentlyBooked();
        fetchRecentlyBooked(); // جلب البيانات عند بدء التطبيق
        getReservations();
        getRestAreas();
        loadFavoritesFromPrefs();
      super.onInit();
   }
   void toggleFavorite(int id) {
     if (favoriteIds.contains(id)) {
       favoriteIds.remove(id);
     } else {
       favoriteIds.add(id);
     }
     favoriteIds.refresh();  // ضروري لإشعار الواجهة بالتغيير
     _saveFavoritesToPrefs(); // تحفظ التغييرات على الجهاز
     print(favoriteIds);
   }


   Future<void> _saveFavoritesToPrefs() async {
     final prefs = await SharedPreferences.getInstance();
     // SharedPreferences لا يدعم List<int> مباشرة، فنحولها إلى List<String>
     List<String> favsAsString = favoriteIds.map((e) => e.toString()).toList();
     await prefs.setStringList('favorite_ids', favsAsString);
     print("donee");
   }

   Future<void> loadFavoritesFromPrefs() async {
     final prefs = await SharedPreferences.getInstance();
     List<String>? favsAsString = prefs.getStringList('favorite_ids');
     if (favsAsString != null) {
       favoriteIds.value = favsAsString.map((e) => int.tryParse(e) ?? 0).where((e) => e != 0).toSet();
     }
     print("favorite_ids ${favoriteIds.value}");
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
   Future<Map<String, dynamic>> addOfflineBooking({
     required int restAreaId,
     required String checkIn,
     required String checkOut,
   }) async {
     try {
       // **لا نُغير isLoading.value هنا لأننا سنتحكم في مؤشر التحميل من الواجهة الأمامية (الـ Dialog)**
       final SharedPreferences prefs = await SharedPreferences.getInstance(); // <--- تم استعادة هذا السطر
       token = prefs.getString('token'); // <--- تم استعادة هذا السطر
       String? userType = prefs.getString('user_type'); // <--- تم استعادة هذا السطر

       // التحقق المسبق: هل المستخدم مسجل دخول وهل هو مضيف؟
       if (token == null || token!.isEmpty) {
         Get.snackbar("خطأ", "الرجاء تسجيل الدخول أولاً لإضافة حجز.",
             backgroundColor: Colors.red, colorText: Colors.white); // <--- Snackbar هنا
         return {'success': false, 'message': "الرجاء تسجيل الدخول أولاً لإضافة حجز."};
       }
       if (userType != 'host') {
         Get.snackbar("خطأ", "ليس لديك الصلاحية لإضافة حجوزات خارجية.",
             backgroundColor: Colors.red, colorText: Colors.white); // <--- Snackbar هنا
         return {'success': false, 'message': "ليس لديك الصلاحية لإضافة حجوزات خارجية."};
       }

       final response = await Dio().post(
         'https://esteraha.ly/api/reservations/offline',
         options: Options(
           headers: {
             'Authorization': 'Bearer $token',
             'Accept': 'application/json',
           },
         ),
         data: {
           'rest_area_id': restAreaId,
           'check_in': checkIn,
           'check_out': checkOut,
           // يمكن إضافة حقول أخرى هنا إذا كان الـ API يتطلبها
           // 'adults_count': 1, 'children_count': 0, 'deposit_amount': 0,
         },
       );

       if (response.statusCode == 200 || response.statusCode == 201) {
         print("success ${response.data} ");
         // تحديث قائمة الحجوزات بعد النجاح
         getReservations(isHost: true);
         Get.snackbar("نجاح", "تم إدراج الحجز خارج التطبيق بنجاح!",
             backgroundColor: MyColors.successColor, colorText: Colors.white); // <--- Snackbar هنا
         return {'success': true, 'message': "تم إدراج الحجز خارج التطبيق بنجاح!"};
       } else {
         // هذا الجزء لن يتم الوصول إليه عادةً إذا كان Dio يرمي DioException لغير 2xx
         Get.snackbar("خطأ", response.data['message'] ?? 'خطأ غير معروف',
             backgroundColor: Colors.red, colorText: Colors.white); // <--- Snackbar هنا
         return {'success': false, 'message': response.data['message'] ?? 'خطأ غير معروف'};
       }
     } on DioException catch (e) {
       String errorMessage = "حدث خطأ غير متوقع.";
       if (e.response != null) {
         print("API Error Status: ${e.response!.statusCode}");
         print("API Error Data: ${e.response!.data}");

         if (e.response!.statusCode == 401) {
           errorMessage = "جلسة المستخدم منتهية الصلاحية. الرجاء تسجيل الدخول مرة أخرى.";
         } else if (e.response!.statusCode == 403) {
           errorMessage = "ليس لديك الصلاحية لإجراء هذا الإجراء.";
         } else if (e.response!.statusCode == 400 || e.response!.statusCode == 422) { // 400 Bad Request, 422 Unprocessable Entity (Validation)
           errorMessage = e.response!.data['message'] ?? e.response!.statusMessage ?? "خطأ في البيانات المدخلة.";
           if (e.response!.data['errors'] != null) {
             // عرض أخطاء التحقق من الصحة المفصلة
             e.response!.data['errors'].forEach((key, value) {
               errorMessage += "\n- ${value.join(', ')}";
             });
           }
         } else if (e.response!.statusCode == 409) { // Conflict (مثلاً تداخل في التواريخ)
           errorMessage = e.response!.data['message'] ?? "الفترة المختارة محجوزة بالفعل.";
         } else {
           errorMessage = e.response!.data['message'] ?? e.response!.statusMessage ?? errorMessage;
         }
       } else {
         errorMessage = e.message ?? "تأكد من اتصالك بالإنترنت.";
       }
       Get.snackbar("خطأ", errorMessage,
           backgroundColor: Colors.red, colorText: Colors.white); // <--- Snackbar هنا
       return {'success': false, 'message': errorMessage};
     } catch (e) {
       Get.snackbar("خطأ", "حدث خطأ: ${e.toString()}",
           backgroundColor: Colors.red, colorText: Colors.white); // <--- Snackbar هنا
       return {'success': false, 'message': "حدث خطأ: ${e.toString()}"};
     } finally {
       // **مهم:** لا نُغير isLoading.value = false; هنا أيضًا لأنها للتحكم في مؤشر اللودينغ العام للشاشة.
       // مؤشر التحميل الخاص بزر التأكيد يتم التحكم فيه في الـ UI
     }
   }

   void oldfilterList(String status) {
     filteredReservations.value = reservations.where((element) {
       return element['status'].toString().toLowerCase() == status.toLowerCase();
     }).toList();
   }
   void filterList(String status) {
     List<dynamic> tempFilteredList = _allReservations.where((reservation) {
       bool matchesStatus = reservation['status'].toString().toLowerCase() == status.toLowerCase();
       bool matchesRestArea = true;


       if (selectedRestAreaIdFilter.value != null && selectedRestAreaIdFilter.value != -1) {
         // تأكد من أن rest_area و id موجودين
         matchesRestArea = reservation['rest_area']?['id'] == selectedRestAreaIdFilter.value;
       }
       return matchesStatus && matchesRestArea;
     }).toList();

     // تطبيق فرز التاريخ بعد الفلترة حسب الحالة والاستراحة

     if (selectedDateSortOrder.value == 'oldest') {
       tempFilteredList.sort((a, b) {
         // الترتيب حسب check_in (أقرب تاريخ أولاً)
         DateTime dateA = DateTime.tryParse(a['check_in'] ?? '') ?? DateTime(2100);
         DateTime dateB = DateTime.tryParse(b['check_in'] ?? '') ?? DateTime(2100);
         return dateA.compareTo(dateB);
       });
     } else if (selectedDateSortOrder.value == 'newest') {
       tempFilteredList.sort((a, b) {
         // الترتيب حسب created_at (أحدث طلب أولاً)
         DateTime dateA = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1900);
         DateTime dateB = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1900);
         return dateB.compareTo(dateA);
       });
     }

     filteredReservations.value = tempFilteredList;
     print("filteredReservations ${filteredReservations.value}");
     print("Filtered list updated for status: $status, count: ${filteredReservations.length}");
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


   void processPaymentStatusResponse(Map<String, dynamic> json) {
     if (json['status'] == 'success' && json['data'] is List) {
       for (var item in json['data']) {
         final id = int.tryParse(item['rest_area_id'].toString());
         final paid = item['paid'] == true;

         if (id != null) {
           paymentStatusMap[id] = paid;
         }
       }
     }
   }

   bool hasUnpaidRestAreas() {

     return paymentStatusMap.values.any((paid) => paid == false);
   }
   Future<Map<int, bool>> checkPaymentStatus(List<int> restAreaIds) async {
     try {
       final response = await Dio().post(
         'https://esteraha.ly/api/check-payment-status',
         data: {
           'rest_area_ids': restAreaIds,
         },
       );

       if (response.statusCode == 200) {
         final List data = response.data['data'];
         print("✅ استجابة فحص الدفع: $data");
         print("🔍 معرفات الاستراحات المطلوب فحصها: $restAreaIds");

         if (data.isEmpty) {
           print("⚠️ لم يتم إرجاع بيانات لحالة الدفع.");
           return {};
         }

         // ✅ التحويل الآمن باستخدام int.tryParse
         return {
           for (var item in data)
             if (int.tryParse(item['rest_area_id'].toString()) != null)
               int.parse(item['rest_area_id'].toString()): item['paid'] == true,
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
   Future<void> getReservations({bool isHost = false}) async {
     try {
       isLoading.value = true;
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       token = prefs.getString('token');
       String? userType = prefs.getString('user_type');

       if (userType == "host") {
         isHost = true;
         print("isHost $userType");
       }

       print("tokenss $token");
       final response = await Dio().get(
         'https://esteraha.ly/api/reservations',
         options: Options(
           headers: {
             'Authorization': 'Bearer $token',
             'Accept': 'application/json',
           },
         ),

         queryParameters: {
           'type': isHost ? 'host' : 'user',
         },
       );
       print("Request Query: ${{
         'type': isHost ? 'host' : 'user'
       }}");
       if (response.statusCode == 200) {
         print("response.data5");
         print(response.data);
         print("response.data5");

         _allReservations = response.data['reservations']; // تخزين في القائمة الأصلية

         // **الجزء المعدل: استخراج الاستراحات الفريدة من الحجوزات باستخدام Map**
         if (isHost) {
           Map<int, Map<String, dynamic>> uniqueRestAreasMap = {}; // استخدم Map لضمان التفرد بالـ ID
           for (var reservation in _allReservations) {
             if (reservation['rest_area'] != null && reservation['rest_area']['id'] != null) {
               int restAreaId = reservation['rest_area']['id'];
               String restAreaName = reservation['rest_area']['name'] ?? 'اسم غير معروف';
               // إضافة الاستراحة إلى الـ Map باستخدام ID كـ key. إذا كان الـ ID موجودًا، فلن يتم استبداله.
               uniqueRestAreasMap[restAreaId] = {
                 'id': restAreaId,
                 'name': restAreaName,
               };
             }
           }
           hostRestAreas.value = uniqueRestAreasMap.values.toList(); // تحويل القيم إلى قائمة
           print("Host rest areas (from reservations): ${hostRestAreas.value}");
         }

         print("All reservations fetched: ${_allReservations.length} items");
         filterList('pending'); // فلترة أولية بعد الجلب على القائمة الأصلية
         print("filteredReservations after initial filter: ${filteredReservations.length} items");
       } else {
         print('فشل في جلب البيانات: ${response.statusCode}');
       }
     } catch (e) {
       print('حدث خطأ أثناء جلب البيانات: $e');
     } finally {
       isLoading.value = false;
     }
   }




   Future<List<dynamic>> getFavorites({



     List<int>? favoriteIds,
   }) async {
     try {
       isLoading.value = true;

       final queryParameters = <String, dynamic>{};
       if (favoriteIds != null && favoriteIds.isNotEmpty) {
         queryParameters['ids[]'] = favoriteIds;
       }


       print("Query Parameters fav: $queryParameters");

       final response = await Dio().get(
         'https://esteraha.ly/api/rest-areas/filter',
         queryParameters: queryParameters,
       );

       fav.clear();
       if (response.statusCode == 200) {
         fav.value = response.data; // تخزين البيانات في المتغير
         print(fav.value);
         print("Query all fav: ${fav.value}");
         // print("Query all: ${restAreas[0]['google_maps_location']}");
         print("response fav : ${response}");
         return response.data;
       } else {
         fav.clear();
         return response.data;
       }
     } catch (e) {
       Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: ');
       print('حدث خطأ أثناء جلب س: $e');
       return [];
     } finally {
       print("response.data fav");

       isLoading.value = false;
     }
   }

   Future<List<dynamic>> getRestAreas({
     String? areaTypes,
     int? priceMin,
     int? priceMax,
     int? cityId,
     int? hostId,
     int? rating,
     String? sortBy,
     String? geoArea,
     int? maxGuests,
     List<String>? selectedFacilities,

   }) async {
     try {
       isLoading.value = true;

       final queryParameters = <String, dynamic>{};

       if (areaTypes != "" && areaTypes != null) {
         queryParameters['area_type[]'] = areaTypes;
       }
       if (priceMin != null && priceMin > 0) {
         queryParameters['price_min'] = priceMin;
       }
       if (priceMax != null && priceMax > 0) {
         queryParameters['price_max'] = priceMax;
       }
       if (cityId != null && cityId > 0) {
         queryParameters['city_id'] = cityId;
       }
       if (hostId != null && hostId >= 0) {
         queryParameters['host_id'] = hostId;
       }
       if (rating != -1 && rating != null && rating != 0) {
         queryParameters['rating'] = rating;
       }
       if (maxGuests != null && maxGuests > 0) {
         queryParameters['max_guests'] = maxGuests;
       }
       if (sortBy != null) {
         queryParameters["sort_by"] = sortBy;
       }
       if (geoArea != null && geoArea!="") {
         queryParameters["geo_area"] = geoArea;
       }

       if (selectedFacilities != null) {
         for (String facility in selectedFacilities) {
           if (facilitiesMap.containsKey(facility)) {
             queryParameters[facilitiesMap[facility].toString()] = 1;
           }
         }
       }

       print("Query Parameters: $queryParameters");

       final response = await Dio().get(
         'https://esteraha.ly/api/rest-areas/filter',
         queryParameters: queryParameters,
       );

       restAreas.clear();
       if (response.statusCode == 200) {
         restAreas.value = response.data; // تخزين البيانات في المتغير
         print(restAreas.value);
         print("Query all: ${restAreas.value}");
         // print("Query all: ${restAreas[0]['google_maps_location']}");
         print("response: ${response}");
         return response.data;
       } else {
         restAreas.clear();
         return response.data;
       }
     } catch (e) {
       Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: ');
       print('حدث خطأ أثناء جلب س: $e');
       return [];
     } finally {
       print("response.data");

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
         'https://esteraha.ly/api/most-booked',
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
