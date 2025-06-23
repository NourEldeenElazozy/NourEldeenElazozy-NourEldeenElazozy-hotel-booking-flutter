import 'package:flutter/material.dart';

class PointsPage extends StatelessWidget {
  const PointsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Text(
            'نقاط الولاء',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            SizedBox(height: 16),

            // Card النقاط القابلة للتحويل
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, size: 48, color: Colors.orange),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'النقاط القابلة للتحويل!',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '166',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'بيانات النقطة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // قائمة النقاط
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildPointItem(
                    date: '2025-05-25 03:32 PM',
                    points: '98+',
                    orderNumber: '130433',
                  ),
                  _buildPointItem(
                    date: '2025-02-24 09:08 PM',
                    points: '68+',
                    orderNumber: '129239',
                  ),
                ],
              ),
            ),

            // زر تحويل إلى المحفظة
      /*
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // تنفيذ التحويل
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم تحويل النقاط إلى المحفظة ✅'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'تحويل إلى المحفظة',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
       */
          ],
        ),
      ),
    );
  }

  Widget _buildPointItem({
    required String date,
    required String points,
    required String orderNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Text(
              '$points من النقاط',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.add_circle, color: Colors.orange, size: 18),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'حجز إسنراحة',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontFamily: 'Tajawal',
          ),
        ),
        Divider(height: 24),
      ],
    );
  }
}
