import 'package:scp/model/user_model.dart';

class ServiceModel {
  final String? id;
  final String title;
  final String? description;
  final String? file;
  final int price;
  final String? duration;
  final UserModel? users;
  final ServiceType? serviceType;

  const ServiceModel({
    this.id,
    required this.title,
    this.description,
    this.file,
    required this.price,
    this.duration,
    this.users,
    this.serviceType,
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
