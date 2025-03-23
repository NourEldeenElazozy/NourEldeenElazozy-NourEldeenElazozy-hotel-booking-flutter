import 'dart:convert';

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  List<NotificationElement> notification;

  Notification({
    required this.notification,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    notification: List<NotificationElement>.from(json["notification"].map((x) => NotificationElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notification": List<dynamic>.from(notification.map((x) => x.toJson())),
  };
}

class NotificationElement {
  DateTime date;
  List<Datum> data;

  NotificationElement({
    required this.date,
    required this.data,
  });

  factory NotificationElement.fromJson(Map<String, dynamic> json) => NotificationElement(
    date: DateTime.parse(json["date"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String image;
  String heading;
  String description;

  Datum({
    required this.image,
    required this.heading,
    required this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    image: json["image"],
    heading: json["heading"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "heading": heading,
    "description": description,
  };
}
