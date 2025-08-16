class AllReviews {
  final int? id; // قد يكون معرف التقييم موجوداً في API
  final String? reviewerName;
  final double? rating;
  final String? comment;
  final String? imageUrl; // قد يكون اسم الحقل مختلفاً في الـ API
  final String? reviewDate; // قد يكون اسم الحقل مختلفاً في الـ API

  AllReviews({
    this.id,
    this.reviewerName,
    this.rating,
    this.comment,
    this.imageUrl,
    this.reviewDate,
  });

  factory AllReviews.fromJson(Map<String, dynamic> json) {
    return AllReviews(
      id: json['id'] as int?,
      reviewerName: json['user']['name'] as String?, // افترض أن اسم المراجع يأتي من كائن User nested
      rating: double.tryParse(json['rating'].toString()) ?? 0.0, // <-- تحويل String الى double
      comment: json['comment'] as String?,
      imageUrl: json['user']['image_url'] as String?, // افترض أن الصورة تأتي من كائن User nested
      reviewDate: json['created_at'] as String?, // تاريخ الإنشاء من Laravel
    );
  }
}
