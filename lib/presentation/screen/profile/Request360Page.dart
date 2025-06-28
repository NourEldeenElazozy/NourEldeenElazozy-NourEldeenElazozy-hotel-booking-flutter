import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/screen/profile/profile_import.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request360Page extends StatefulWidget {
  const Request360Page({super.key});

  @override
  State<Request360Page> createState() => _Request360PageState();
}

late ProfileController controller;
var userName = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
var userType = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
var userPhone = ''.obs; // استخدام Rx لتحديث الواجهة عند تغيير القيمة
bool isLoading = true;
Future<void> loadUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  userType.value = prefs.getString('user_type') ?? '';
  userName.value = prefs.getString('userName') ?? '';
  userPhone.value = prefs.getString('userPhone') ?? '';

  print("user_type: ${userType.value}");
  print("user_name: ${userName.value}");
  print("user_phone: ${userPhone.value}");
}

class _Request360PageState extends State<Request360Page> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    loadUserInfo().then((_) {
      nameController.text = userName.value;
      phoneController.text = userPhone.value;
      setState(() {
        isLoading = false; // بعد انتهاء التحميل
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: homeAppBar('طلب تصوير استراحة 360', false, false,
            showBackButton: true),
        body: isLoading
            ? const Center(child: CircularProgressIndicator()) // جاري التحميل
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.orange.shade50,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'يرجى تعبئة النموذج لطلب التصوير',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: nameController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'يرجى إدخال الاسم'
                                      : null,
                              decoration: InputDecoration(
                                hintText: 'الاسم',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'يرجى إدخال رقم الهاتف'
                                      : null,
                              decoration: InputDecoration(
                                hintText: 'رقم الهاتف',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: noteController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'بيان الطلب (اختياري)',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await controller.sendResthouseRequest(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        note: noteController.text,
                                      );

                                      nameController.clear();
                                      phoneController.clear();
                                      noteController.clear();
                                    }
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text(
                                    'إرسال',
                                    style: TextStyle(fontFamily: 'Tajawal'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade700,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
