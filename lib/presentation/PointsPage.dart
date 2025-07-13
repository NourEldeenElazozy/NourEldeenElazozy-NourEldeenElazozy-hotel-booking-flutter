import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/PointsController.dart';


class PointsPage extends StatelessWidget {
  const PointsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PointsController controller = Get.put(PointsController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'نقاط الولاء',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 48, color: Colors.orange),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'النقاط القابلة للتحويل!',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return Text(
                              '${controller.totalPoints.value}',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // يمكنك إضافة المزيد من الواجهات حسب الحاجة
              // مثلاً زر تحويل النقاط أو شرح إضافي
            ],
          ),
        ),
      ),
    );
  }
}
