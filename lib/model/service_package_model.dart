import 'package:scp/model/service_model.dart';
import 'package:scp/model/user_model.dart';

class ServicePackageModel {
  final String? id;
  final String title;
  final int price;
  final UserModel? users;
  final ServiceModel? oneToOneSessionServiceId;
  final String? oneToOneSessionServiceid;
  final ServiceModel? digitalProductServiceId;
  final String? digitalProductServiceid;
  final ServiceModel? priorityDmServiceId;
  final String? priorityDmServiceid;

  // Constructor
  ServicePackageModel({
    this.id,
    required this.title,
    required this.price,
    this.users,
    this.oneToOneSessionServiceid,
    this.oneToOneSessionServiceId,
    this.digitalProductServiceid,
    this.digitalProductServiceId,
    this.priorityDmServiceid,
    this.priorityDmServiceId,
  });

  // Convert from JSON
  factory ServicePackageModel.fromJson(Map<String, dynamic> json) {
    return ServicePackageModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      price: json['price'] as int,
      users: json['users'] != null ? UserModel.fromJson(json['users']) : null,
      oneToOneSessionServiceId: json['one_to_one_session_service_id'] != null
          ? ServiceModel.fromJson(json['one_to_one_session_service_id'])
          : null,
      oneToOneSessionServiceid:
          json['one_to_one_session_service_Id'] as String?,
      digitalProductServiceId: json['digital_product_service_id'] != null
          ? ServiceModel.fromJson(json['digital_product_service_id'])
          : null,
      digitalProductServiceid: json['digital_product_service_Id'] as String?,
      priorityDmServiceId: json['priority_dm_service_id'] != null
          ? ServiceModel.fromJson(json['priority_dm_service_id'])
          : null,
      priorityDmServiceid: json['priority_dm_service_Id'] as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'users': users?.toJson(),
      'one_to_one_session_service_id': oneToOneSessionServiceId?.toJson(),
      'one_to_one_session_service_Id': oneToOneSessionServiceId,
      'digital_product_service_id': digitalProductServiceId?.toJson(),
      'digital_product_service_Id': digitalProductServiceId,
      'priority_dm_service_id': priorityDmServiceId?.toJson(),
      'priority_dm_service_Id': priorityDmServiceId,
    };
  }
}
