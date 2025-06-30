part of 'date_time_select_import.dart';

class DateTimeSelectController extends GetxController {

  ThemeController themeController = Get.put(ThemeController());
  var isLoading = false.obs; // حالة التحميل
  RxBool isSubmitted = false.obs;
  final GlobalKey<FormState> dateTimeKey = GlobalKey<FormState>();
  var reservedDates = <DateTime>[].obs;
  Rx<TextEditingController> checkInDateController = TextEditingController().obs;
  Rx<TextEditingController> checkOutDateController = TextEditingController().obs;

  /*DateTime selectCheckInDate = DateTime.now();
  DateTime selectCheckOutDate = DateTime.now();*/
  RxString selectedType = ''.obs;

  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  Future<void> fetchReservedDates(int restAreaId) async {
    try {
      final response = await Dio.Dio().get('http://10.0.2.2:8000/api/reservations/$restAreaId/reserved-dates');

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
      // استرجاع التوكن من SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final checkInText = checkInDateController.value.text;
      final checkOutText = checkOutDateController.value.text;
/*
      final DateTime checkInDate = intl.DateFormat("dd MMM yyyy", "en").parse(checkInText);
      final DateTime checkOutDate = intl.DateFormat("dd MMM yyyy", "en").parse(checkOutText);

      final String formattedCheckIn = intl.DateFormat("yyyy-MM-dd").format(checkInDate);
      final String formattedCheckOut = intl.DateFormat("yyyy-MM-dd").format(checkOutDate);
 */

      final response = await Dio.Dio().post(
        'http://10.0.2.2:8000/api/reservations',
        options: Dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: {
          'rest_area_id':restAreaId ,
          'check_in': checkInDateController.value.text,
          'check_out': checkOutDateController.value.text,
          'adults_count': adult.value,
          'children_count': children.value,
          "accommodation_type":selectedType.value
        },
      );
      print("response.data");
      print(response.data);
      dismissLoading();
      Get.snackbar("نجاح", "تم الحجز بنجاح", backgroundColor: Colors.green);
      Get.offAllNamed("/bottomBar"); // أو Get.toNamed إذا كانت الصفحة غير موجودة مسبقاً
    } catch (e) {
      dismissLoading();

      if (e is Dio.DioError) {
        // خطأ من Dio (شبكة، استجابة، timeout، إلخ)
        if (e.response != null) {
          print('Dio Error Response Data: ${e.response?.data}');
          print('Dio Error Response Status Code: ${e.response?.statusCode}');
          print('Dio Error Response Headers: ${e.response?.headers}');
        } else {
          print('Dio Error without response: ${e.message}');
        }
      } else {
        // أي خطأ آخر غير DioError
        print('Unexpected error: $e');
      }

      // طباعة بيانات الحجز لمراجعتها
      print("RestAreaId: $restAreaId");
      print("CheckIn: ${checkInDateController.value.text}");
      print("CheckOut: ${checkOutDateController.value.text}");
      print("Adults: ${adult.value}");
      print("Children: ${children.value}");

      Get.snackbar("خطأ", "فشل في إرسال الحجز", backgroundColor: Colors.red);
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