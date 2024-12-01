import 'package:scp/model/available_slot_model.dart';

class AvailableDayModel {
  final String? id;
  final String day;
  final AvailableSlotModel? availableSlot;

  // Constructor
  AvailableDayModel({
    required this.id,
    required this.day,
    required this.availableSlot,
  });

  // fromJson factory method
  factory AvailableDayModel.fromJson(Map<String, dynamic> json) {
    return AvailableDayModel(
      id: json['id'] as String?,
      day: json['day'] as String,
      availableSlot: json['availableSlot'] != null
          ? AvailableSlotModel.fromJson(json['availableSlot'])
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'availableSlot': availableSlot?.toJson(),
    };
  }
}
