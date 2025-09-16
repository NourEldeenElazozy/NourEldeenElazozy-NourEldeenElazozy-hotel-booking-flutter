import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/common_widgets/appbar.dart';
import 'package:hotel_booking/presentation/screen/helpCenter/help_center_import.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactPage extends StatefulWidget {
  ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // استدعاء الكونترولر
  final HelpCenterController controller = Get.put(HelpCenterController());

  // Controllers للحقل
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  // دالة مساعدة لفتح الروابط
  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendMessage() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String message = messageController.text.trim();

    if (name.isEmpty || phone.isEmpty || message.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء تعبئة جميع الحقول ✋',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    setState(() {
      isLoading = true;
    });

    await controller.sendMessage(name: name, phone: phone, message: message);

    setState(() {
      isLoading = false;
    });

    // إذا أردت مسح الحقول بعد الإرسال الناجح فقط، تأكد من الحالة في sendMessage أو أضف من هنا:
    // nameController.clear();
    // phoneController.clear();
    // messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: homeAppBar(context, MyString.helpCentre, false, false, showBackButton: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'تواصل معنا',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // خدمة العملاء
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.orange.shade700),
                        title: Text(
                          '092-8058860',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          _launchUrl('tel:0928058860');
                        },
                      ),

                      Divider(),

                      // Facebook
                      ListTile(
                        leading: Icon(Icons.facebook, color: Colors.blueAccent),
                        title: Text(
                          'صفحتنا على Facebook',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          _launchUrl('https://www.facebook.com/share/16bG86XEad/?mibextid=wwXIfr');
                        },
                      ),

                      Divider(),

                      // Instagram
                      ListTile(
                        leading: Icon(Icons.camera_alt_outlined, color: Colors.pinkAccent),
                        title: Text(
                          'صفحتنا على Instagram',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          _launchUrl('https://www.instagram.com/esteraha_electronic_marketing/');
                        },
                      ),

                      Divider(),

                      // TikTok
                      ListTile(
                        leading: Icon(Icons.play_circle_fill, color: Colors.black),
                        title: Text(
                          'صفحتنا على TikTok',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          _launchUrl('https://www.tiktok.com/@esterah_marketing?_t=ZM-8x1wuYlbtv6&_r=1');
                        },
                      ),

                      Divider(height: 32),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'ارسل لنا رسالة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // حقل الاسم
                      TextField(
                        style: TextStyle( // ✅ لون النص
                          color: Colors.black, // في الوضع الفاتح
                        ),
                        controller: nameController,
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
                      SizedBox(height: 12),

                      // حقل رقم الهاتف
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle( // ✅ لون النص
                          color: Colors.black, // في الوضع الفاتح
                        ),
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتف',
                          hintStyle: TextStyle(
                            color: Colors.grey, // ✅ لون النص الوهمي (Hint)
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // حقل الرسالة
                      TextField(
                        style: TextStyle( // ✅ لون النص
                          color: Colors.black, // في الوضع الفاتح
                        ),
                        controller: messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك هنا...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // زر إرسال مع Loading
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _sendMessage,
                          icon: isLoading ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ) : Icon(Icons.send),
                          label: Text(
                            isLoading ? 'جاري الإرسال...' : 'إرسال',
                            style: TextStyle(fontFamily: 'Tajawal'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                'شكراً لتواصلكم معنا ❤️',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
