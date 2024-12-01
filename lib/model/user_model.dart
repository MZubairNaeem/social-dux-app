import 'package:scp/model/service_model.dart';
import 'package:scp/model/user_profile_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? dp;
  final String? emailVerifiedAt;
  final UserProfileModel? userProfiles;
  final List<ServiceModel>? services;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dp,
    this.services,
    this.emailVerifiedAt,
    this.userProfiles,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      dp: json['dp'],
      userProfiles: (json['user_profiles'] != null &&
              (json['user_profiles'] as List).isNotEmpty)
          ? UserProfileModel.fromJson((json['user_profiles'] as List).first)
          : null,
      services:
          (json['services'] != null && (json['services'] as List).isNotEmpty)
              ? (json['services'] as List)
                  .map((e) => ServiceModel.fromJson(e))
                  .toList()
              : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'dp': dp,
      'email_verified_at': emailVerifiedAt,
      'user_profiles': userProfiles?.toJson(),
      'services': services?.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
