part of 'select_room_import.dart';

class SelectRoomController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());
  HomeDetailController homeDetailController = HomeDetailController();

  RxInt selectedButton = 0.obs;
  RxInt selectRoomIndex = 0.obs;

  List<RecentlyBook> selectRoom = <RecentlyBook>[].obs;

  @override
  void onInit() {
    getSelectRoom();
    super.onInit();
  }

  Future<List<RecentlyBook>> getSelectRoom() async {
    String jsonData = await rootBundle.loadString("assets/data/selectRoom.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['selectRoom'];
    for (int i = 0 ; i < jsonArray.length ; i++) {
      selectRoom.add(RecentlyBook.fromJson(jsonArray[i]));
    }
    return selectRoom;
  }
}