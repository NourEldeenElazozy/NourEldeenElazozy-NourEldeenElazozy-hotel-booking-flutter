part of 'gallery_photo_import.dart';

class GalleryPhotoScreen extends StatefulWidget {
  const GalleryPhotoScreen({super.key});

  @override
  State<GalleryPhotoScreen> createState() => _GalleryPhotoScreenState();
}

class _GalleryPhotoScreenState extends State<GalleryPhotoScreen> {
  late List<String> photos;

  @override
  void initState() {
    super.initState();
    photos = List<String>.from(Get.arguments['galleryPhoto'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomFullAppBar(
          title: MyString.galleryHotelPhotos,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            itemCount: photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 140,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        backgroundColor: Colors.black,
                        body: Stack(
                          children: [
                            PhotoViewGallery.builder(
                              itemCount: photos.length,
                              builder: (context, i) {
                                return PhotoViewGalleryPageOptions(
                                  imageProvider: NetworkImage(
                                    "https://esteraha.ly/public/${photos[i]}",
                                  ),
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale: PhotoViewComputedScale.covered * 2,
                                );
                              },
                              pageController: PageController(initialPage: index),
                              backgroundDecoration:
                              const BoxDecoration(color: Colors.black),
                            ),
                            Positioned(
                              top: 40,
                              right: 20,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://esteraha.ly/public/${photos[index]}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

