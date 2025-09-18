part of 'hotel_detail_import.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  String? coords;
  LatLng? markerPosition;
  String? errorMessage;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();

    coords = Get.arguments;

    if (coords == null || coords!.isEmpty) {
      errorMessage = "الموقع غير موجود.";
    } else {
      try {
        markerPosition = parseLatLng(coords!);
        if (markerPosition == null) {
          errorMessage = "الإحداثيات غير صالحة.";
        }
      } catch (e) {
        errorMessage = "حدث خطأ في معالجة الإحداثيات.";
      }
    }
  }

  /// 🟢 دالة لتحويل النص "lat,lng" إلى LatLng
  LatLng? parseLatLng(String value) {
    final parts = value.split(",");
    if (parts.length == 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
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
              return Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (markerPosition == null) {
              return const Center(child: CircularProgressIndicator());
            }

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

