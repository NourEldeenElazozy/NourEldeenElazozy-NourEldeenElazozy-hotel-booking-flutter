part of 'help_center_import.dart';

class HelpCenterController extends GetxController {
  ThemeController themeController = Get.put(ThemeController());

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<FocusNode> searchFocus = FocusNode().obs;
  RxList isExpandedList = [].obs;
  // RxBool isExpanded = true.obs ;
  // RxInt? isExpandedIndex;

  Dio dio = Dio();

  Future<void> sendMessage({
    required String name,
    required String phone,
    required String message,
  }) async {
    final url = 'https://esteraha.ly/api/contact-message'; // عدل الرابط هنا

    try {
      final response = await dio.post(url, data: {
        'name': name,
        'phone': phone,
        'message': message,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('نجاح', response.data['message'],
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('خطأ', 'حدث خطأ أثناء الإرسال',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on DioError catch (e) {
      if (e.response != null && e.response?.statusCode == 422) {
        // Validation error
        final errors = e.response?.data['errors'];
        String errorMessage = '';
        errors?.forEach((key, value) {
          errorMessage += '${value[0]}\n';
        });

        Get.snackbar('خطأ في البيانات', errorMessage.trim(),
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('خطأ', 'فشل في الاتصال بالخادم',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}