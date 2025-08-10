part of 'hotel_detail_import.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  String? googleMapsUrl;
  LatLng? markerPosition;
  String? errorMessage;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();

    googleMapsUrl = Get.arguments;

    if (googleMapsUrl == null || googleMapsUrl!.isEmpty) {
      errorMessage = "الرابط غير موجود.";
    } else {
      try {
        markerPosition = parseLatLngFromUrl(googleMapsUrl!);
        if (markerPosition == null) {
          errorMessage = "الرابط غير صالح أو لا يحتوي على إحداثيات.";
        }
      } catch (e) {
        errorMessage = "حدث خطأ في معالجة الرابط.";
      }
    }
  }

  LatLng? parseLatLngFromUrl(String url) {
    final regExp = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
    final match = regExp.firstMatch(url);

    if (match != null && match.groupCount >= 2) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomFullAppBar(
        title: "موقع الإستراحة",
        ),
        body: Builder(
          builder: (context) {
            if (errorMessage != null) {
              // عرض رسالة الخطأ
              return Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (markerPosition == null) {
              // عرض لودنق أثناء التحليل
              return const Center(child: CircularProgressIndicator());
            }

            // عرض الخريطة مع الماركر
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: markerPosition!,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('hotelMarker'),
                  position: markerPosition!,
                ),
              },
              onMapCreated: (controller) {
                mapController = controller;
              },
              myLocationButtonEnabled: false,
            );
          },
        ),
      ),
    );
  }
}