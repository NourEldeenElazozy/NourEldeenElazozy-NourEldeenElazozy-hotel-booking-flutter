part of 'date_time_select_import.dart';

class DateTimeSelectController extends GetxController {

  ThemeController themeController = Get.put(ThemeController());
  var isLoading = false.obs; // حالة التحميل
  RxBool isSubmitted = false.obs;
  final GlobalKey<FormState> dateTimeKey = GlobalKey<FormState>();
  var reservedDates = <DateTime>[].obs;
  var isTermsAccepted = false.obs;
  Rx<TextEditingController> checkInDateController = TextEditingController().obs;
  Rx<TextEditingController> checkOutDateController = TextEditingController().obs;

  /*DateTime selectCheckInDate = DateTime.now();
  DateTime selectCheckOutDate = DateTime.now();*/
  RxString selectedType = ''.obs;

  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  Future<void> fetchReservedDates(int restAreaId) async {
    try {
      final response = await Dio.Dio().get('https://esteraha.ly/api/reservations/$restAreaId/reserved-dates');

      if (response.statusCode == 200 && response.data != null) {
        // تحويل التواريخ المستلمة من JSON إلى قائمة من DateTime
        print("reservedDates.value ${restAreaId}");
        reservedDates.value = List<DateTime>.from(
            (response.data['reserved_dates'] as List).map((date) => DateTime.parse(date))
        );


      } else {
        // التعامل مع حالة عدم النجاح

        Get.snackbar('Error', 'No reserved dates found');
      }
    } catch (e) {
      // التعامل مع الأخطاء
      print("Errors${e.toString()}");
      Get.snackbar('Error', e.toString());
    }
  }
  Future<void> makeReservation(int restAreaId) async {
    try {
      loading();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await Dio.Dio().post(
        'https://esteraha.ly/api/reservations',
        options: Dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: {
          'rest_area_id': restAreaId,
          'check_in': checkInDateController.value.text,
          'check_out': checkOutDateController.value.text,
          'adults_count': adult.value,
          'children_count': children.value,
          "accommodation_type": selectedType.value
        },
      );

      dismissLoading();
      Get.snackbar("نجاح", "تم الحجز بنجاح", backgroundColor: Colors.green);
      Get.offAllNamed("/bottomBar");

    } catch (e) {
      dismissLoading();

      if (e is Dio.DioError) {
        if (e.response != null) {
          final errorData = e.response?.data;
          print("Dio Error Response Data: $errorData");

          // ✅ إذا السيرفر رجع reserved_dates
          if (errorData is Map && errorData.containsKey('reserved_dates')) {
            final List reservedDates = errorData['reserved_dates'];

            // تحويل التواريخ لسطر نصي مرتب
            final formattedDates = reservedDates.join("\n");

            Get.defaultDialog(
              title: "هذه المده غير متاحه بالكامل",
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // ✅ النصوص في المنتصف
                  children: [
                    Text(
                      "خلال  فترة الحجز يوجد ايام محجوزة.\n\nالتواريخ المشغولة:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),

                    // ✅ كونتينر مرن مع حد أقصى
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200, // أقصى ارتفاع
                        maxWidth: 250,  // أقصى عرض
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text(
                              formattedDates,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center, // ✅ النص في المنتصف
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                    Text(
                      "اعد تعيين ايام الحجز في هذه الإستراحة او في اخري.",
                      style: TextStyle(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // ✅ زر حسناً يغلق النافذة
              textConfirm: "حسناً",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back(); // يغلق النافذة
              },
            );

          } else {
            Get.snackbar(
              "خطأ",
              "${errorData['message'] ?? 'فشل في إرسال الحجز'}",
              backgroundColor: Colors.red,
            );
          }
        } else {
          Get.snackbar("خطأ", "تعذر الاتصال بالخادم", backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar("خطأ", "حدث خطأ غير متوقع", backgroundColor: Colors.red);
      }
    }
  }

  void setFromDate(DateTime date) {
    fromDate.value = date;
    checkInDateController.value.text=  intl.DateFormat('yyyy-MM-dd').format(fromDate.value);
  }

  void setToDate(DateTime date) {
    toDate.value = date;
    checkOutDateController.value.text=  intl.DateFormat('yyyy-MM-dd').format(toDate.value);
  }

  bool isToDateSelectable(DateTime day) {
    return day.isAfter(fromDate.value.subtract(const Duration(days: 1))) || day.isAtSameMomentAs(fromDate.value);
  }
  void loading() {
    isLoading.value = true; // تعيين حالة التحميل إلى true
  }

  void dismissLoading() {
    isLoading.value = false; // تعيين حالة التحميل إلى false
  }
 /* Future<void> checkInDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectCheckInDate,
      firstDate:  DateTime.now(), // Sets minimum date selection to today
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != selectCheckInDate) {
      selectCheckInDate = pickedDate;
      checkInDateController.value.text = DateFormat('MMMd').format(selectCheckInDate);
    }
  }

  Future<void> checkOutDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectCheckOutDate,
      firstDate:  DateTime.now(), // Sets minimum date selection to today
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != selectCheckOutDate) {
      selectCheckOutDate = pickedDate;
      checkOutDateController.value.text = DateFormat('MMMd').format(selectCheckOutDate);
    }
  }*/

//--------------------------------- Time Picker ---------------------------------
  Rx<TextEditingController> checkInTimeController = TextEditingController().obs;
  Rx<TextEditingController> checkOutTimeController = TextEditingController().obs;

  TimeOfDay selectCheckInTime = TimeOfDay.now();
  TimeOfDay selectCheckOutTime = TimeOfDay.now();

  Future<void> checkInTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectCheckInTime,

    );
    if (pickedTime != null) {
      selectCheckInTime = pickedTime;
      String period = selectCheckInTime.period == DayPeriod.am ? 'am' : 'pm';
      String formattedTime = '${selectCheckInTime.hourOfPeriod.toString().padLeft(2,'0')} : ${selectCheckInTime.minute.toString().padLeft(2,'0')} $period';
      checkInTimeController.value.text = formattedTime;
    }
  }

  Future<void> checkOutTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectCheckOutTime,
    );
    if (pickedTime != null) {
        selectCheckOutTime = pickedTime;
        String period = selectCheckOutTime.period == DayPeriod.am ? 'am' : 'pm';
        String formattedTime = '${selectCheckOutTime.hourOfPeriod.toString().padLeft(2,'0')} : ${selectCheckOutTime.minute.toString().padLeft(2,'0')} $period';
        checkOutTimeController.value.text = formattedTime;
      }
  }
//--------------------------------- Adult - Children ---------------------------------
  RxInt adult = 0.obs;
  RxInt children = 0.obs;

  void adultIncrement() async {
    adult.value ++;
  }

  void adultDecrement() async {
    if(adult.value != 0 ) {
      adult.value --;
    }
  }

  void childrenIncrement() async {
    children.value ++;
  }

  void childrenDecrement() async {
    if(children.value != 0 ) {
      children.value --;
    }
  }

  void dateTimeValidation(BuildContext context) {
    if(checkInDateController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check In Date");
    } else if(checkOutDateController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check Out Date");
    } else if(checkInTimeController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check In Time");
    } else if(checkOutTimeController.value.text.isEmpty) {
      showErrorMsg(context: context, message: "Select Check Out Time");

    } else {
      Get.toNamed("/selectRoom");
    }
  }
}