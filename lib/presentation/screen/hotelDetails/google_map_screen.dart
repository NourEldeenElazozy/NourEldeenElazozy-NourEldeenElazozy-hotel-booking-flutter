part of 'hotel_detail_import.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  String? coords;




  @override
  void initState() {
    super.initState();

    coords = Get.arguments;


  }

  /// 🟢 دالة لتحويل النص "lat,lng" إلى LatLng


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

