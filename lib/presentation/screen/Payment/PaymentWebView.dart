import 'package:flutter/material.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/presentation/screen/Payment/PaymentController.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;

  final double price;
  List<Map<String, dynamic>> unpaidData = [];
   PaymentWebViewScreen({Key? key, required this.url, required this.price, required this.unpaidData}) : super(key: key);

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  final PaymentsController _paymentController = Get.put(PaymentsController());

  @override
  Widget build(BuildContext context) {
    print("ssss${widget.unpaidData}");
    return Scaffold(
      appBar: AppBar(
        title: Text('سداد الفاتورة'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _paymentController.transaction().then((value) async {
                if (value.data["result"] == "incomplete") {
                  Get.snackbar(
                    "فشل العملية",
                    "لم يتم سداد القيمة ",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (value.data["data"]['notes_to_shop']['payment_status'].toString().trim() == "تم استكمال سداد القيمة"
                ) {
                  print("تم استكمال سداد القيمة s");
                  //ربط الباكج مع المستخدم
                  final now = DateTime.now();
                  final durationInDays = MyString.duration ?? 0;
                  final startDate = now;
                  final endDate = now.add(Duration(days: durationInDays));
                  await _paymentController.storeUserPackage(
                    packageId: MyString.packageId,
                    restAreaIds: widget.unpaidData.map<int>((item) => item['id'] as int).toList(),
                    startDate: startDate.toString(),
                    endDate: endDate.toString(),
                    commissionRate: widget.price,
                  ).then((value) {
                    Get.snackbar(
                      "نجاح العملية",
                      "تم سداد القيمة بنجاح",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }, );

                }

                // بعد عرض النتيجة، اغلق الصفحة
                Navigator.of(context).pop();
                /*
                .catchError((e) {
                Get.snackbar(
                  "خطأ",
                  "حدث خطأ أثناء التحقق من العملية",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              });
                 */
              });
            },
          ),

        ],
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(widget.url))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'Flutter',
            onMessageReceived: (JavaScriptMessage message) {
              if (message.message == 'pay') {
                print("قيمة الدفع: 100.00");
              }
            },
          ),
      ),
    );
  }
}
