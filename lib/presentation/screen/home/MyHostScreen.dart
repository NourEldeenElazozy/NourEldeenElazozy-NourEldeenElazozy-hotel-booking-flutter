import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/Model/RestAreas.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/screen/home/home_import.dart';
import 'package:hotel_booking/presentation/screen/home/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/RestArea.dart';


class MySotingScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  Future<int> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
            print("user_id ${userId}");
            controller.getRestAreas(hostId: userId);
            print("controller.restAreas.length");
            print( controller.restAreas.length);


            return Obx(() {
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

                        /*
                          Get.toNamed("/hotelDetail", arguments: {'data' : controller.homeDetails[index]});
                           */

                        Detail detail = Detail.fromJson(restArea);

                        // إضافة الكائن إلى homeDetails إذا كان ذلك مطلوبًا
                        controller.homeDetails.add(detail);


                        Get.toNamed("/hotelDetail", arguments: {'data': restArea});
                        print("reservation");
                        print(restArea);

                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
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
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/logo/logo.png', // مسار الصورة الافتراضية
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
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Get.toNamed("/AddRestAreaScreen", arguments: {
                                        'isEdit': true,
                                        'restAreaData': restArea,
                                      });
                                    },
                                    tooltip: 'تعديل',
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      restArea["is_active"] == true
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      color: restArea["is_active"] == true
                                          ? MyColors.tealColor
                                          : Colors.grey,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      controller.toggleRestAreaActiveStatus(restArea["id"]);
                                    },
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
            });
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
}