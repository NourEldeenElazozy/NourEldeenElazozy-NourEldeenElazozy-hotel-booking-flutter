class Images {
  String? url;

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['url'] = url;
    return data;
  }
}