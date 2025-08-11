part of 'bookmark_import.dart';

class BookMarkController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());
  HomeController homeController = Get.put(HomeController());
  var restAreas = <dynamic>[].obs;
  RxInt selectedButton = 0.obs;

  // أضف هذا: قائمة المفضلات (مثلاً بيانات الإستراحات المفضلة)
  RxList<dynamic> favorites = <dynamic>[].obs;

  // قائمة الـ ids المفضلة
  RxSet<int> favoriteIds = <int>{}.obs;

  // دالة لجلب بيانات المفضلة من API أو من مكان تخزينها
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favStrings = prefs.getStringList('favorite_ids') ?? [];
    List<int> ids = favStrings.map((e) => int.tryParse(e) ?? 0).where((id) => id > 0).toList();

    favoriteIds.value = ids.toSet();

    if (ids.isNotEmpty) {
      var data = await homeController.getRestAreas(favoriteIds: ids);
      restAreas.value = data;
      favorites.value = data;
    } else {
      restAreas.clear();
      favorites.clear();
    }
  }
  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences لا يدعم List<int> مباشرة، فنحولها إلى List<String>
    List<String> favsAsString = favoriteIds.map((e) => e.toString()).toList();
    await prefs.setStringList('favorite_ids', favsAsString);
    print("donee");
  }

  void toggleFavorite(int id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    favoriteIds.refresh();  // يخبر GetX أن البيانات تغيرت
    _saveFavoritesToPrefs(); // حفظ التغييرات في SharedPreferences
    // قم بتحميل بيانات المفضلة مجددًا لو كنت تحمّل بيانات restAreas من ids
    loadFavorites();
    homeController.loadFavoritesFromPrefs();
  }


}