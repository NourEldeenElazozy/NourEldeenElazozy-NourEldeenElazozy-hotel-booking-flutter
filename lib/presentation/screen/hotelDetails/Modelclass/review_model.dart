class AllReview {
  int? id;
  String? name;
  String? date;
  String? rate;
  String? description;
  String? image;

  AllReview({
    required this.id,
    required this.name,
    required this.date,
    required this.rate,
    required this.description,
    required this.image,
  });

  AllReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    rate = json['rate'];
    description = json['description'];
    image = json['image'];
  }

  Map<String,dynamic> toJson() {
    final data = <String, dynamic> {};
    data['id'] = id;
    data['name'] = name;
    data['date'] = date;
    data['rate'] = rate;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}