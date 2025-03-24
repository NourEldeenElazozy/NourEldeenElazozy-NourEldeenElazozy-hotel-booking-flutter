class RestArea {
  final String name;
  final String location;
  final String areaType;
  final double price;
  final String mainImage;
  final double rating;


  RestArea({
    required this.name,
    required this.location,
    required this.areaType,
    required this.price,
    required this.mainImage,
    required this.rating,

  });

  // دالة لتحويل البيانات من JSON إلى كائن RestArea
  factory RestArea.fromJson(Map<String, dynamic> json) {
    return RestArea(
      name: json['name'],
      location: json['location'],
      areaType: json['area_type'],
      price: json['price'].toDouble(),
      mainImage: json['main_image'],
      rating: json['rating'].toDouble(),

    );
  }
}