import 'package:scp/model/service_model.dart';
import 'package:scp/model/user_model.dart';

class TestimonialModel {
  final String? id;
  final String? review;
  final int? rating;
  final String? videoUrl;
  final UserModel? userId;
  final ServiceModel? serviceId;

  // Constructor
  TestimonialModel({
    this.id,
    this.review,
    this.rating,
    this.videoUrl,
    this.userId,
    this.serviceId,
  });

  // From JSON
  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json['id'] as String?,
      review: json['review'] as String?,
      rating: json['rating'] as int?,
      videoUrl: json['video_url'] as String?,
      userId: json['user_id'] != null ? UserModel.fromJson(json['user_id']) : null,
      serviceId: json['service_id'] != null
          ? ServiceModel.fromJson(json['service_id'])
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review': review,
      'rating': rating,
      'video_url': videoUrl,
      'user_id': userId?.toJson(),
      'service_id': serviceId?.toJson(),
    };
  }
}
