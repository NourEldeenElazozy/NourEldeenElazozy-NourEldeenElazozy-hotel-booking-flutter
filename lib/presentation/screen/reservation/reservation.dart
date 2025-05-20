part of 'reservation_import.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key, required this.reservationData});
  final Map<String, dynamic> reservationData;
  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {

  late ReservationController controller;

  @override
  void initState() {
    controller = Get.put(ReservationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservationData['reservations'][0]; // Assuming only one reservation for this page
    final user = reservation['user'];
    final restArea = reservation['rest_area'];
    final reservationStatus = reservation['status'] ?? 'unknown'; // Get the reservation status

    // Helper to format date
    String formatDate(String dateString) {
      final DateTime dateTime = DateTime.parse(dateString);
      return intl.DateFormat('dd MMMM yyyy').format(dateTime);
    }

    // Determine status color
    Color getStatusColor(String status) {
      switch (status) {
        case 'pending':
          return Colors.orange;
        case 'completed':
          return Colors.green;
        case 'canceled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: homeAppBar(
          showBackButton: true,
            "تفاصيل الحجز", false, controller.themeController.isDarkMode.value),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rest Area Details
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الاستراحة: ${restArea['name']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (restArea['main_image'] != null && restArea['main_image'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                           "http://10.0.2.2:8000/storage/${restArea['main_image']}",

                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 15),
                      _buildDetailRow(
                        icon: Icons.location_on,
                        label: 'الموقع',
                        value: restArea['location'],
                      ),
                      _buildDetailRow(
                        icon: Icons.star_rate,
                        label: 'التقييم',
                        value: '${restArea['rating']}',
                      ),
                      _buildDetailRow(
                        icon: Icons.monetization_on,
                        label: 'السعر اليومي',
                        value: '${restArea['price']} دينار',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Reservation Details
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تفاصيل الحجز',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:  MyColors.primaryColor,
                        ),
                      ),
                      const Divider(height: 25, thickness: 1),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'تاريخ الوصول',
                        value: formatDate(reservation['check_in']),
                      ),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'تاريخ المغادرة',
                        value: formatDate(reservation['check_out']),
                      ),
                      _buildDetailRow(
                        icon: Icons.money,
                        label: 'مبلغ العربون',
                        value: '${reservation['deposit_amount']} دينار',
                      ),
                      _buildDetailRow(
                        icon: Icons.person,
                        label: 'عدد البالغين',
                        value: '${reservation['adults_count']}',
                      ),
                      _buildDetailRow(
                        icon: Icons.child_care,
                        label: 'عدد الأطفال',
                        value: '${reservation['children_count']}',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.black54),
                          const SizedBox(width: 10),
                          const Text(
                            'الحالة:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: getStatusColor(reservationStatus),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              reservationStatus == 'pending'
                                  ? 'معلقة'
                                  : reservationStatus == 'completed'
                                  ? 'مكتملة'
                                  : reservationStatus == 'canceled'
                                  ? 'ملغاة'
                                  : 'غير معروف',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // User Details
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'بيانات المستخدم',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Divider(height: 25, thickness: 1),
                      _buildDetailRow(
                        icon: Icons.person_outline,
                        label: 'الاسم',
                        value: user['name'],
                      ),
                      _buildDetailRow(
                        icon: Icons.phone,
                        label: 'رقم الهاتف',
                        value: user['phone'],
                      ),
                      _buildDetailRow(
                        icon: Icons.location_city,
                        label: 'المدينة',
                        value: user['city'] ?? 'غير متوفر',
                      ),
                      _buildDetailRow(
                        icon: Icons.cake,
                        label: 'تاريخ الميلاد',
                        value: user['date_of_birth'] != null
                            ? formatDate(user['date_of_birth'])
                            : 'غير متوفر',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80), // Add extra space at the bottom to prevent FAB from overlapping content
            ],
          ),
        ),
        // Floating Action Buttons
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
        // Only show buttons if the reservation status is 'pending'
        reservationStatus == 'pending'
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'approve_fab', // Unique tag for each FAB
                  onPressed: () {
                    // Implement approval logic here
                    Get.defaultDialog(
                      title: "تأكيد الموافقة",
                      middleText: "هل أنت متأكد من الموافقة على الحجز؟",
                      textConfirm: "نعم",
                      textCancel: "لا",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.green,
                      cancelTextColor: Colors.black,
                      onConfirm: () {
                        Get.back(); // Close dialog
                        // Call your controller method to approve the reservation
                        // controller.approveReservation(reservation['id']);
                        Get.snackbar('تم', 'تم تأكيد الحجز بنجاح!');
                      },
                      onCancel: () {},
                    );
                  },
                  label: const Text('موافقة', style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.check, color: Colors.white),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 15), // Space between buttons
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'reject_fab', // Unique tag for each FAB
                  onPressed: () {
                    // Implement rejection logic here
                    Get.defaultDialog(
                      title: "تأكيد الرفض",
                      middleText: "هل أنت متأكد من رفض الحجز؟",
                      textConfirm: "نعم",
                      textCancel: "لا",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      cancelTextColor: Colors.black,
                      onConfirm: () {
                        Get.back(); // Close dialog
                        // Call your controller method to reject the reservation
                        // controller.rejectReservation(reservation['id']);
                        Get.snackbar('تم', 'تم رفض الحجز.');
                      },
                      onCancel: () {},
                    );
                  },
                  label: const Text('رفض', style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.close, color: Colors.white),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        )
            : null, // Don't show buttons if status is not 'pending'
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}