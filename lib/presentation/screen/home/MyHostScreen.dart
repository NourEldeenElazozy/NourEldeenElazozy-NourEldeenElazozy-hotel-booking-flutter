import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/common_widgets/bottom_navigation_bar.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';
import 'package:hotel_booking/presentation/screen/home/home_model.dart';
import 'package:intl/intl.dart' as intl ;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/RestArea.dart';


class MySotingScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Future<int> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("prefs.getInt('user_id')");
    print(prefs.getInt('user_id'));
    return prefs.getInt('user_id') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'إسترحاتي',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
          backgroundColor: MyColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(() => const BottomBar(initialIndex: 2));
            },
          ),
        ),

        body: FutureBuilder<int>(
          future: _loadUserId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final userId = snapshot.data!;
            print("user_id $userId");

            // تحميل الاستراحات والتحقق من الدفع
            return FutureBuilder(
              future: controller.getRestAreas(hostId: userId).then((_) async {
                final ids = controller.restAreas.map((e) => e["id"] as int).toList();
                controller.paymentStatusMap.value = await controller.checkPaymentStatus(ids);
              }),
              builder: (context, snapshot) {
                if (controller.isLoading2.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Obx(() {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.restAreas.length,
                          itemBuilder: (context, index) {
                            final restArea = controller.restAreas[index]; 
                            // تأكد أن 'price' موجود وتتعامل معه
                            final double restAreaPrice = (double.parse(restArea["price"]))?.toDouble() ?? 0.0; // افتراضي 0.0 إذا null
                            final bool isPaid = controller.paymentStatusMap[restArea["id"]] ?? false; // الافتراضي يكون false إذا غير مدفوع

                            return Card(
                              color: isPaid ? Colors.white : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                              child: InkWell(
                                onTap: () {
                                  if (!isPaid) {
                                    Get.snackbar("تنبيه", "هذه الاستراحة غير مفعلة بسبب عدم الدفع");
                                    return;
                                  }

                                  Detail detail = Detail.fromJson(restArea);
                                  controller.homeDetails.add(detail);

                                  Get.toNamed("/hotelDetail", arguments: {'data': restArea});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          "https://esteraha.ly/public/${restArea["main_image"]}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                            return Image.asset(
                                              'assets/logo/logo.png',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              restArea["name"].toString(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                            const SizedBox(height: 5), // مسافة بين الاسم والأزرار
                                            // هذا هو الجزء الذي سنقوم بتعديله
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: OutlinedButton.icon(
                                                onPressed: () async {
                                                  int restAreaId = restArea["id"];


                                                  try {
                                                    // استدعاء API
                                                    final response = await GetConnect().get(
                                                      "https://esteraha.ly/api/rest-areas/$restAreaId/check-pending",
                                                      headers: {
                                                        "Authorization": "Bearer ${controller.token}", // لو عندك توكن
                                                      },
                                                    );

                                                    if (response.statusCode == 200) {

                                                      bool hasPending = response.body == true; // API يرجع true أو false

                                                      if (hasPending) {
                                                        Get.snackbar(
                                                          "تنبيه",
                                                          "هذه الاستراحة قيد التعديل بالفعل، انتظر الموافقة.",
                                                          snackPosition: SnackPosition.TOP,
                                                          backgroundColor: Colors.orange.shade100,
                                                          colorText: Colors.black,
                                                        );
                                                      } else {
                                                        // لا يوجد تعديل قيد الانتظار → افتح شاشة التعديل
                                                        Get.toNamed("/AddRestAreaScreen", arguments: {
                                                          'isEdit': true,
                                                          'restAreaData': restArea,
                                                        });
                                                      }
                                                    } else {
                                                      Get.snackbar("خطأ", "تعذر التحقق من حالة الاستراحة");
                                                    }
                                                  } catch (e) {
                                                    Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخادم");
                                                  }
                                                },
                                                icon: const Icon(Icons.edit, size: 20),
                                                label: const Text(
                                                  'تعديل',
                                                  style: TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.blue,
                                                  side: const BorderSide(color: Colors.blue),
                                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                ),
                                              ),

                                            ),
                                            const SizedBox(height: 8), // مسافة بين الأزرار
                                            if (!isPaid) // يظهر فقط إذا كانت الاستراحة غير مدفوعة
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    // استدعاء دالة الحذف
                                                    controller.deleteRestArea(restArea["id"] as int);
                                                  },
                                                  icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                                  label: const Text(
                                                    'حذف',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red, // لون أحمر للحذف
                                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                ),
                                              ),
                                            if (isPaid)
                                           /*
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  controller.toggleRestAreaActiveStatus(restArea["id"]);
                                                },
                                                icon: Icon(
                                                  restArea["is_active"] == true ? Icons.toggle_on : Icons.toggle_off,
                                                  size: 20,
                                                ),
                                                label: Text(
                                                  restArea["is_active"] == true ? 'مفعل' : 'معطل',
                                                  style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: restArea["is_active"] == true ? MyColors.tealColor : Colors.grey,
                                                  side: BorderSide(color: restArea["is_active"] == true ? MyColors.tealColor : Colors.grey),
                                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                ),
                                              ),
                                            ),
                                            */
                                            const SizedBox(height: 8),
                                            if (isPaid)
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    _showOfflineBookingDialog(
                                                        context,
                                                        restArea["id"] as int,
                                                        restArea["name"].toString()
                                                    );
                                                  },
                                                  icon: const Icon(Icons.add_task, color: Colors.white, size: 20),
                                                  label: const Text(
                                                    'حجز خارجي',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(

                                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 10), // مسافة بعد الأزرار
                                           /*
                                            Text(
                                              restArea["description"].toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Tajawal',
                                                color: Colors.black54,
                                              ),
                                            ),
                                            */
                                            if (!isPaid)
                                              const Text(
                                                "غير مدفوعة",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Tajawal',
                                                ),
                                              ),


                                            const SizedBox(height: 8), // مسافة بعد الأزرار
                                        /*
                                            Text(
                                              restArea["description"].toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Tajawal',
                                                color: Colors.black54,
                                              ),
                                            ),
                                         */

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (controller.hasUnpaidRestAreas())
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              final unpaidRestAreas = controller.restAreas.where((restArea) {
                                final id = restArea["id"] as int;
                                return controller.paymentStatusMap[id] == false;
                              }).toList();

                              final unpaidData = unpaidRestAreas.map((restArea) {
                                return {
                                  "id": restArea["id"],
                                  "price": restArea["price"] // تأكد أن price موجود هنا
                                };
                              }).toList();

                              print('Unpaid Rest Areas with prices: $unpaidData');

                              Get.toNamed('/PackageCard', arguments: {'unpaidData': unpaidData});
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                              backgroundColor: MyColors.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('إتمام عملية الدفع'),
                          ),
                        ),
                    ],
                  );
                });
              },
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'add_rest_area',
              onPressed: () {
                Get.toNamed("/AddRestAreaScreen");
              },
              backgroundColor: MyColors.tealColor,
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: "إضافة استراحة",
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'refresh',
              onPressed: () {
                _loadUserId().then((userId) {
                  controller.getRestAreas(hostId: userId);
                });
              },
              backgroundColor: MyColors.primaryColor,
              child: const Icon(Icons.refresh, color: Colors.white),
              tooltip: "تحديث القائمة",
            ),
          ],
        ),
      ),
    );
  }

// داخل MySotingScreen.dart - دالة _showOfflineBookingDialog

  // **مهم:** يجب تعريف هذا الـ RxBool خارج الدالة مباشرة ليكون ملاحظاً بواسطة Obx.
  final RxBool _isConfirmingOfflineBooking = false.obs; // <--- متغير جديد للتحكم في مؤشر التحميل لزر التأكيد

  void _showOfflineBookingDialog(BuildContext context, int restAreaId, String restAreaName) {
    DateTime? checkInDate;
    DateTime? checkOutDate;
    TextEditingController checkInController = TextEditingController();
    TextEditingController checkOutController = TextEditingController();

    // Reset loading state when dialog opens, in case it was left true from a previous attempt
    _isConfirmingOfflineBooking.value = false; // <--- إعادة تعيين حالة التحميل

    final HomeController controller = Get.find<HomeController>();

    Get.defaultDialog(
      title: "إدراج حجز خارج التطبيق",
      titleStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.all(20),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min, // مهم للحفاظ على حجم الـ Dialog مناسبًا للمحتوى
          children: [
            Text('استراحة: $restAreaName', style: const TextStyle(fontSize: 16, fontFamily: 'Tajawal')),
            const SizedBox(height: 20),
            TextFormField(
              controller: checkInController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'تاريخ الدخول',
                labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 سنوات للأمام
                );
                if (picked != null) {
                  checkInDate = picked;
                  checkInController.text = intl.DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: checkOutController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'تاريخ الخروج',
                labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onTap: () async {
                DateTime initialCheckoutDate = checkInDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1));
                DateTime firstSelectableDate = initialCheckoutDate;
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: initialCheckoutDate,
                  firstDate: firstSelectableDate,
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) {
                  checkOutDate = picked;
                  checkOutController.text = intl.DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
          ],
        ),
      ),
      // لا تستخدم textConfirm: '...'
      // استخدم confirm: Widget(...) لإنشاء الزر وتضمين مؤشر التحميل
      confirm: Obx(() => ElevatedButton( // <--- زر التأكيد، ملفوف بـ Obx للمراقبة _isConfirmingOfflineBooking
        onPressed: _isConfirmingOfflineBooking.value ? null : () async { // <--- تعطيل الزر أثناء التحميل
          if (checkInDate == null || checkOutDate == null) {
            Get.snackbar("خطأ", "الرجاء إدخال تاريخي الدخول والخروج",
                backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }
          if (checkOutDate!.isBefore(checkInDate!)) {
            Get.snackbar("خطأ", "تاريخ الخروج يجب أن يكون بعد تاريخ الدخول",
                backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }

          _isConfirmingOfflineBooking.value = true; // <--- بدء مؤشر التحميل

          Map<String, dynamic> result = await controller.addOfflineBooking(
            restAreaId: restAreaId,
            checkIn: intl.DateFormat('yyyy-MM-dd').format(checkInDate!),
            checkOut: intl.DateFormat('yyyy-MM-dd').format(checkOutDate!),
          );

          _isConfirmingOfflineBooking.value = false; // <--- إيقاف مؤشر التحميل

          // **عرض Snackbar بناءً على نتيجة عملية الـ API**
          if (result['success']) {
            Get.snackbar("نجاح", result['message'], backgroundColor: MyColors.successColor, colorText: Colors.white);
            Get.back(); // إغلاق الـ Dialog فقط عند النجاح
          } else {
            Get.snackbar("خطأ", result['message'], backgroundColor: Colors.red, colorText: Colors.white);
            // يبقى الـ Dialog مفتوحاً للسماح للمستخدم بتصحيح البيانات عند الفشل
          }
          Get.back(); // إغلاق الـ Dialog فقط عند النجاح
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          foregroundColor: Colors.white, // لون النص والأيقونة
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: _isConfirmingOfflineBooking.value // <--- عرض مؤشر التحميل أو النص
            ? const SizedBox(
          width: 24, // حجم مؤشر التحميل الدائري
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Text(
          'تأكيد الحجز',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
      )),
      // لا تستخدم textCancel: '...'
      // استخدم cancel: Widget(...) لإنشاء زر الإلغاء
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // إغلاق الـ Dialog عند الإلغاء
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black, // لون النص والأيقونة
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: const Text(
          'إلغاء',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}