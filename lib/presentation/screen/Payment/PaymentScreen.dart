import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/core/constants/my_images.dart';
import 'package:hotel_booking/presentation/screen/Payment/PaymentController.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentsController controller = Get.put(PaymentsController());
  final args = Get.arguments as Map;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    amountController.text = double.parse(args['data'].toString()).toString();


    print("pricex ${args['data']}");
    print("unpaidData ${args['unpaidData']}");

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
                  height: MediaQuery.of(context).size.height* 0.25,

                  child: ClipOval(
                    child: Image.asset(
                      MyImages.tlync,
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
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "رقم الجوال",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'يرجى إدخال رقم الجوال';
                    if (!RegExp(r'^09\d{8}$').hasMatch(value)) return 'رقم الجوال غير صالح';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                SizedBox(height: 24),
                Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  icon: Icon(Icons.payment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (args != null && args['unpaidData'] != null) {
                        controller.unpaidData = List<Map<String, dynamic>>.from(args['unpaidData']);
                        print('Received unpaid dataw: ${ controller.unpaidData}');
                      }
                      controller.initiatePayment(
                        amount: double.parse(amountController.text),
                        phone: phoneController.text,
                      );
                    }
                  },
                  label: Text(
                    "ادفع الآن",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',

                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
