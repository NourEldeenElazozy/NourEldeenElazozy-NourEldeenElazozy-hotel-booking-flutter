import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';
import '../../../Model/RestArea.dart';


class MySotingScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // استدعاء الدالة لجلب البيانات عند بناء الشاشة
    controller.getRestAreas();

    return Directionality(
      textDirection: TextDirection.rtl, // لجعل التخطيط من اليمين لليسار
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
          ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.restAreas.length,
            itemBuilder: (context, index) {
              final restArea = controller.restAreas[index];
              return InkWell(
                onTap: () {
                  // يمكنك إضافة منطق التنقل لتفاصيل الاستراحة هنا
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "http://10.0.2.2:8000/storage/${restArea["main_image"]}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
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
                              const SizedBox(height: 4),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.getRestAreas();
          },
          backgroundColor: MyColors.primaryColor,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}
