import 'package:flutter/material.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
import 'package:hotel_booking/presentation/screen/Package/PackageCardController.dart';
import 'package:get/get.dart';
class Package {
  final int id;
  final String name;
  final String duration;

  final int startRange;
  final int endRange;
  final String percentage;

  Package({
    required this.id,
    required this.name,
    required this.duration,

    required this.startRange,
    required this.endRange,
    required this.percentage,
  });
}

class PackagesScreen extends StatefulWidget {

   PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {


  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  final RxInt selectedIndex = 0.obs; //

  final List<Package> packages = [

  ];
  PackageCardController controller = Get.put(PackageCardController());
  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final currentPage = _pageController.page?.round() ?? 0;
      if (currentPage != _currentPage) {
        setState(() => _currentPage = currentPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchPackages();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'اختر الباقة المناسبة',
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
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'الباقات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.packages.length,
                  itemBuilder: (context, index) {
                    final pkg = controller.packages[index];
                    final isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        selectedIndex.value = index; // تحديث
                        // يمكنك إضافة منطق إضافي هنا عند اختيار باقة
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [MyColors.primaryColor, MyColors.primaryColor]
                                : [MyColors.tealColor, MyColors.tealColor],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(color: MyColors.primaryColor, width: 2)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 0.50,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              pkg.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                                color: isSelected ? Colors.blueGrey : Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 6),
                           // Text('السعر: \$${pkg.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                              Text('المدة: ${_getDurationText(pkg.duration)}', style: TextStyle(color: Colors.white)),
                                const SizedBox(width: 5),
                                Icon(Icons.access_time, color: Colors.white),
                            ],),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('عدد الإستراحات', style: TextStyle(color: Colors.white,fontSize: 16),)),
                                const SizedBox(width: 5),
                                const Icon(Icons.house, color: Colors.white),
                              ],
                            ),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(' الي ${pkg.endRange}', style: TextStyle(color: Colors.white)),
                               Text('  -  ', style: TextStyle(color: Colors.white)),
                               Text('من ${pkg.startRange}', style: TextStyle(color: Colors.white)),



                             ],
                           ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [


                                Text('النسبة: ${pkg.percentage}', style: TextStyle(color: Colors.white)),
                                const SizedBox(width: 5),
                                Icon(Icons.percent, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: selectedIndex.value != null
                    ? () {
                  final selectedPkg = controller.packages[selectedIndex.value!];
                  // تنفيذ الدفع أو الانتقال للخطوة التالية
                  print('تم اختيار الباقة: ${selectedPkg.id}');
                }
                    : null,
                style: ElevatedButton.styleFrom(

                ),
                child: const Text(
                  'متابعة الدفع',
                  style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }),





  floatingActionButton: selectedIndex != null
          ? FloatingActionButton.extended(
        onPressed: () {
          final selectedPkg = controller.packages[selectedIndex.value!];
          // تنفيذ الدفع أو الانتقال للخطوة التالية
          print('تم اختيار الباقة: ${selectedPkg.id}');
        },
        label: const Text(
          'متابعة الدفع',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold,color: MyColors.tealColor),
        ),
        icon: const Icon(Icons.payment),
        backgroundColor: MyColors.primaryColor,
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


  Widget _buildPackageCard(Package pkg, bool isHighlighted) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: isHighlighted ? 10 : 4,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isHighlighted
                ? [Colors.deepOrange.shade300, Colors.orange.shade400]
                : [Colors.orange.shade200, Colors.orange.shade300],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pkg.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),


          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة الأيقونة + النص لليمين
        children: [


          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 20, color: Colors.white),
        ],
      ),
    );
  }


  String _getDurationText(String key) {
    final map = {
      'free': 'مجانية',
      '1_month': 'شهر',
      '2_months': 'شهرين',
      '3_months': '3 أشهر',
      '4_months': '4 أشهر',
      '5_months': '5 أشهر',
      '6_months': '6 أشهر',
      '7_month': '7 أشهر',
      '8_months': '8 أشهر',
      '9_months': '9 أشهر',
      '10_months': '10 أشهر',
      '11_months': '11 أشهر',
      '12_months': 'سنة كاملة',
    };
    return map[key] ?? key;
  }

