import 'package:scp/model/service_model.dart';
import 'package:scp/model/user_model.dart';

class BookingsModel {
  final String? id;
  final String startTime;
  final String? endTime;
  final ServiceModel? serviceId;
  final UserModel? buyerId;

  const BookingsModel({
    this.id,
    required this.startTime,
    this.endTime,
    this.serviceId,
    this.buyerId,
  });

  factory BookingsModel.fromJson(Map<String, dynamic> json) {
    return BookingsModel(
      id: json['id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      serviceId: json['service_id'] != null
          ? ServiceModel.fromJson(json['service_id'])
          : null,
      buyerId: json['buyer_id'] != null
          ? UserModel.fromJson(json['buyer_id'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
      'service_id': serviceId?.toJson(),
      'buyer_id': buyerId?.toJson(),
    };
  }
}
