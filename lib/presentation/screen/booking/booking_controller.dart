part of 'booking_import.dart';

class BookingController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  RxInt selectedItem = 0.obs;
  RxBool isLoading = true.obs;
  RxString passingStatus = 'paid'.obs;

  List<RecentlyBook> myBooking = <RecentlyBook>[].obs;
  List<RecentlyBook> filterListView = <RecentlyBook>[].obs;

  // void onInit() {
  //   getMyBooking();
  //   super.onInit();
  // }

  void filterList(String status) {
    filterListView.clear();
    filterListView.addAll(myBooking.where((element) => element.status == status));
  }

  Future<List<RecentlyBook>> getMyBooking() async {
    isLoading.value = true; // Set isLoading to true before loading data
    try {
      String jsonData = await rootBundle.loadString("assets/data/myBooking.json");
      dynamic data = json.decode(jsonData);
      List<dynamic> jsonArray = data['myBooking'];
      myBooking.clear();
      for (int i = 0; i < jsonArray.length; i++) {
        myBooking.add(RecentlyBook.fromJson(jsonArray[i]));
      }
      filterList(passingStatus.value);
      isLoading.value = false; // Set isLoading to false after data is loaded
      return myBooking;
    } catch (e) {
      isLoading.value = false; // Set isLoading to false in case of error
      return [];
    }
  }

//--------------------------------------- cancelBooking ---------------------------------

  RxInt selectPayment = 0.obs;

  void cancelContinue(BuildContext context) {
    if(selectPayment.value == 0) {
      showErrorMsg(context: context, message: "Select any Refund Type");
    }
    else {
      showDialog(
        context: context,
        builder: (context) {
          return CongratulationDialog(
            onpressed: () {
              Get.offNamedUntil("/bottomBar", (route) => false);
            },
            status: false,
            title: MyString.successFull,
            subTitle: MyString.successFullDescription,
            shadowColor: Colors.transparent,
            buttonName: 'Ok',
            onpressed2: () {},
          );
        },
      );
    }
  }
}