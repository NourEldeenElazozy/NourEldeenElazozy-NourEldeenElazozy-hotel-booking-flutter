import 'package:flutter/material.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';

class Package {
  final String name;
  final String duration;
  final double price;
  final int restAreasCount;
  final String percentage;

  Package({
    required this.name,
    required this.duration,
    required this.price,
    required this.restAreasCount,
    required this.percentage,
  });
}

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  int? selectedIndex;
  final List<Package> packages = [
    Package(name: 'الباقة المجانية', duration: 'free', price: 0, restAreasCount: 1, percentage: '0%'),
    Package(name: 'باقة شهرية', duration: '1_month', price: 49.99, restAreasCount: 5, percentage: '10%'),
    Package(name: 'باقة نصف سنوية', duration: '6_months', price: 199.99, restAreasCount: 15, percentage: '15%'),
    Package(name: 'باقة سنوية', duration: '12_months', price: 349.99, restAreasCount: 30, percentage: '20%'),
  ];

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
      body: Padding(
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
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [Color(0xFFCBD5E1), Color(0xFFE2E8F0)]
                              : [Color(0xFFF1F5F9), Color(0xFFFAFAFA)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: Colors.blueGrey, width: 2)
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
                              color: isSelected ? Colors.blueGrey : Colors.black54,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 6),
                          Text('السعر: \$${pkg.price.toStringAsFixed(2)}'),
                          Text('المدة: ${_getDurationText(pkg.duration)}'),
                          Text('الاستراحات: ${pkg.restAreasCount}'),
                          Text('النسبة: ${pkg.percentage}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: selectedIndex != null
          ? FloatingActionButton.extended(
        onPressed: () {
          final selectedPkg = packages[selectedIndex!];
          // تنفيذ الدفع أو الانتقال للخطوة التالية
          print('تم اختيار الباقة: ${selectedPkg.name}');
        },
        label: const Text(
          'متابعة الدفع',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
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
            _buildInfoRow(Icons.attach_money, 'السعر: \$${pkg.price.toStringAsFixed(2)}'),
            _buildInfoRow(Icons.calendar_today, 'المدة: ${_getDurationText(pkg.duration)}'),
            _buildInfoRow(Icons.house, 'عدد الاستراحات: ${pkg.restAreasCount}'),
            _buildInfoRow(Icons.percent, 'النسبة: ${pkg.percentage}'),
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

