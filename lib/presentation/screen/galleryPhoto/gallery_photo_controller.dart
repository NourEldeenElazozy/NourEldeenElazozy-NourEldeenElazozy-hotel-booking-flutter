part of 'gallery_photo_import.dart';

class GalleryPhotoController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());
  HomeController homeController = Get.put(HomeController());

   List<GalleryPhoto> photos=[];

  @override
  void onInit() {
    // getGalleryPhoto();
    photos = Get.arguments['galleryPhoto'] ?? [];
    super.onInit();
  }
}