// lib/core/force_update/force_update_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/force_update/force_update_utils.dart';


class ForceUpdateScreen extends StatefulWidget {
  final String appId;

  const ForceUpdateScreen({super.key, required this.appId});

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  @override
  void initState() {
    super.initState();
    // تأجيل إظهار الحوار حتى يتم بناء الواجهة الرسومية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // إظهار حوار التحديث الإجباري بشكل دائم
      ForceUpdateUtils.showUpdateDialog(widget.appId, dismissible: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // يمكن أن تكون هذه الشاشة فارغة أو تحتوي على شعار التطبيق فقط
    // الأهم أنها تمنع المستخدم من تجاوزها
    return GetMaterialApp(
      // يمكن أن يكون لديك هنا بعض الإعدادات الأساسية مثل اللوكال والموضوع
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'), // أو قم بجلب اللوكال من AppLocalization
      fallbackLocale: const Locale('ar', 'SA'),
      title: 'zakat', // أو اسم التطبيق
      home: Scaffold(
        backgroundColor: Colors.white, // أو أي لون خلفية تفضله
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // يمكنك إضافة شعار أو مؤشر تحميل هنا
              // Image.asset('assets/images/app_logo.png', height: 100),
              // const SizedBox(height: 20),
              // const CircularProgressIndicator(),
              // const SizedBox(height: 20),
              // const Text('يتم التحقق من التحديثات...'),
            ],
          ),
        ),
      ),
    );
  }
}