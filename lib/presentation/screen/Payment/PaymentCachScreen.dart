import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/core/constants/my_strings.dart';
import 'package:hotel_booking/presentation/screen/Payment/PaymentController.dart';

class PaymentCachScreen extends StatelessWidget {
  final PaymentsController controller = Get.put(PaymentsController());

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final args = Get.arguments as Map;

  @override
  Widget build(BuildContext context) {
    print("unpaidData ${args['unpaidData']}");
    amountController.text = double.parse(args['data'].toString()).toString();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إتمام عملية الدفع',
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height* 0.20,


                  child: ClipOval(
                    child: Image.asset(
                      MyImages.money,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "المبلغ",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'يرجى إدخال المبلغ';
                    if (double.tryParse(value) == null) return 'يرجى إدخال رقم صحيح';
                    return null;
                  },
                ),
                SizedBox(height: 16),


                SizedBox(height: 24),
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (args != null && args['unpaidData'] != null) {
                        controller.unpaidData =
                        List<Map<String, dynamic>>.from(args['unpaidData']);
                        print('Received unpaid data: ${controller.unpaidData}');
                      }

                      controller.initiateCashPayment(
                        amount: double.parse(amountController.text),
                        packageId: MyString.packageId,
                      ).then((_) {
                        // ✅ عرض سناك بار بعد الإرسال
                        Get.snackbar(
                          "تم إرسال الطلب",
                          "تم إرسال طلب الدفع النقدي، يرجى التواصل مع الدعم الفني.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green.shade600,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 10,
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                          duration: const Duration(seconds: 4),
                        );
                      });
                    }
                  },
                  label: const Text(
                    "ادفع الآن",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
