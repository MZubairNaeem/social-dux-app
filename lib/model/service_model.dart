import 'package:scp/model/available_slot_model.dart';
import 'package:scp/model/bookings_model.dart';
import 'package:scp/model/user_model.dart';

class ServiceModel {
  final String? id;
  final String title;
  final String? description;
  final String? file;
  final dynamic price;
  final String? duration;
  final UserModel? users;
  final ServiceType? serviceType;
  final List<AvailableSlotModel>? availableSlots;
  final List<BookingsModel>? bookings;

  const ServiceModel({
    this.id,
    required this.title,
    this.description,
    this.file,
    required this.price,
    this.duration,
    this.users,
    this.serviceType,
    this.availableSlots,
    this.bookings,
  });

  // Factory constructor to create an instance from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      price: json['price'],
      duration: json['duration'],
      availableSlots: json['available_slots'] != null
          ? (json['available_slots'] as List<dynamic>)
              .map((slot) => AvailableSlotModel.fromJson(slot))
              .toList()
          : null,
      bookings: json['bookings'] != null
          ? (json['bookings'] as List<dynamic>)
              .map((slot) => BookingsModel.fromJson(slot))
              .toList()
          : null,
      users: json['users'] != null ? UserModel.fromJson(json['users']) : null,
      serviceType: ServiceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['service_type'],
        orElse: () => ServiceType.oneToOneSession,
      ), // Enum parsing from string
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file': file,
      'price': price,
      'duration': duration,
      'users': users?.toJson(),
      'service_type': serviceType.toString().split('.').last, // Enum to string
      'available_slots': availableSlots?.map((e) => e.toJson()).toList(),
      'bookings': bookings?.map((e) => e.toJson()).toList(),
    };
  }
}

enum ServiceType {
  oneToOneSession,
  priorityDM,
  digitalProduct,
}

String serviceTypeToString(ServiceType serviceType) {
  return serviceType.toString().split('.').last;
}
