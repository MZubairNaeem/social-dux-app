import 'package:scp/model/available_day_model.dart';

class AvailableSlotModel {
  final String? id;
  final String startTime;
  final String endTime;
  final bool status;
  final List<AvailableDayModel> availableDays;

  // Constructor
  AvailableSlotModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.availableDays,
  });

  // fromJson factory method
  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      id: json['id'] as String?,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'],
      availableDays: (json['available_days'] as List<dynamic>)
          .map((day) => AvailableDayModel.fromJson(day))
          .toList(),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'available_days': availableDays.map((day) => day.toJson()).toList(),
    };
  }
}
