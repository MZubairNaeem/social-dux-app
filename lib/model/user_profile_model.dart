import 'package:scp/model/domain_model.dart';

class UserProfileModel {
  final String? id;
  final String domainId;
  final String? userId;
  final String? tagline;
  final String? about;
  final DomainModel? domains;
  final String? pageLink;

  // Constructor
  UserProfileModel({
    this.id,
    required this.domainId,
    this.userId,
    this.tagline,
    this.about,
    this.pageLink,
    this.domains,
  });

  // Create a UserProfileModel object from a map (JSON) with snake_case keys
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      domainId: json['domain_id'],
      userId: json['user_id'],
      tagline: json['tagline'],
      about: json['about'],
      pageLink: json['page_link'],
      domains: json['domains'] != null
          ? DomainModel.fromJson(json['domains'])
          : null,
    );
  }

  // Convert a UserProfileModel object into a map (JSON) with snake_case keys
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain_id': domainId,
      'user_id': userId,
      'tagline': tagline,
      'about': about,
      'page_link': pageLink,
      'domains': domains!.toJson(),
    };
  }
}
