class CountryPicker {
  String? name;
  String? flag;
  String? code;
  String? dialCode;

  CountryPicker({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
  });

  CountryPicker.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    flag = json['flag'];
    code = json['code'];
    dialCode = json['dialCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['name'] = name;
    data['flag'] = flag;
    data['code'] = code;
    data['dialCode'] = dialCode;
    return data;
  }
}