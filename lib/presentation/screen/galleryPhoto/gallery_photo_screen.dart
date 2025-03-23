part of 'gallery_photo_import.dart';

class GalleryPhotoScreen extends StatefulWidget {
  const GalleryPhotoScreen({super.key});

  @override
  State<GalleryPhotoScreen> createState() => _GalleryPhotoScreenState();
}

class _GalleryPhotoScreenState extends State<GalleryPhotoScreen> {

  late GalleryPhotoController controller;

  @override
  void initState() {
    controller = Get.put(GalleryPhotoController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomFullAppBar(
          title: MyString.galleryHotelPhotos,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            itemCount: controller.photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                mainAxisExtent: 140
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: NetworkImage("${controller.photos[index].url}"), fit: BoxFit.cover),
                ),
              );
            },
          ),
        )
    );
  }
}
