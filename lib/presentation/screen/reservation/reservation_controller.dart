part of 'reservation_import.dart';

class ReservationController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  final GlobalKey<FormState> reservationKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  String? selectedGender;
  RxString countryCode = "+93".obs;
  RxList<Map<String, dynamic>> countryCodes = <Map<String, dynamic>>[].obs;
  // RxList<CountryPicker> countryPicker = <CountryPicker>[].obs;

  void reservationSubmit() {
    final isValid = reservationKey.currentState!.validate();
    Get.focusScope!.unfocus();
    if (!isValid) {
    } else {
      Get.toNamed("/paymentChoice");
    }
    reservationKey.currentState!.save();
  }

  Rx<DateTime> selectedDate = DateTime.now().obs;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime oldestDateAllowed = DateTime(today.year - 12, today.month, today.day);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      if (pickedDate.isAfter(oldestDateAllowed) || pickedDate.isAtSameMomentAs(oldestDateAllowed)) {
        Get.defaultDialog(
          title: "Error",
          middleText: "Adults must be over 12 years old",
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Close"),
            ),
          ],
        );
      } else {
        selectedDate.value = pickedDate;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      }
    }
  }
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime today = DateTime.now();
  //   final DateTime oldestDateAllowed = DateTime(today.year - 12, today.month, today.day);
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     // initialDate: selectedDate.value,
  //     firstDate: DateTime(1950),
  //     lastDate: today,
  //   );
  //   if (pickedDate != null) {
  //     if(pickedDate != today) {
  //       selectedDate.value = pickedDate;
  //       dateController.text = "${selectedDate.value.toLocal()}".split(" ")[0];
  //       print(dateController.text);
  //     } else {
  //       Get.defaultDialog(
  //         title: "Error",
  //         middleText: "Adults must be over 12 years old",
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: const Text("Close"),
  //           ),
  //         ],
  //       );
  //     }
  //   }
  // }

  @override
  void onInit() {
    _loadCountryCodes();
    super.onInit();
  }

  Future<void> _loadCountryCodes() async {
    String data = await rootBundle.loadString('assets/data/countryPicker.json');
    countryCodes.value = List<Map<String, dynamic>>.from(json.decode(data));
    countryCodes.value = countryCodes.toSet().toList();
  }
}