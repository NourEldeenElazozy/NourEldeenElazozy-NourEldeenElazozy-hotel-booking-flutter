import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:hotel_booking/core/constants/my_colors.dart';
class MapPickerScreens extends StatefulWidget {
  final LatLng? initialLocation;
  const MapPickerScreens({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<MapPickerScreens> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreens> {
  GoogleMapController? mapController;
  LatLng? pickedLocation;

  @override
  void initState() {
    super.initState();
    pickedLocation = widget.initialLocation;
  }

  void _onTap(LatLng pos) {
    setState(() {
      pickedLocation = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor, // أو أي لون غامق
          title: const Text("اختر الموقع",style: TextStyle(

            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),),

        ),

        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.initialLocation ?? const LatLng(32.8872, 13.1913), // طرابلس كمثال
                  zoom: 14,
                ),
                onMapCreated: (controller) => mapController = controller,
                markers: pickedLocation == null
                    ? {}
                    : {
                  Marker(
                    markerId: const MarkerId("picked"),
                    position: pickedLocation!,
                  )
                },
                onTap: _onTap,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity, // يخلي الزر ياخذ العرض كامل
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: pickedLocation == null
                      ? null
                      : () {
                    Get.back(result: pickedLocation);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("تأكيد الموقع", style: TextStyle(  fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
