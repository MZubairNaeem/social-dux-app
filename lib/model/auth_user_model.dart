import 'package:scp/model/role_model.dart';

class AuthUserModel {
  final String id;
  final String name;
  final String email;
  final RoleModel? role;
  final OnboardingSteps? onboardingStep;

  AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.onboardingStep,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'])
          : null, // Assuming JobModel has fromJson method
      onboardingStep: OnboardingSteps.values.firstWhere(
        (e) => e.toString().split('.').last == json['onboarding_step'],
        orElse: () => OnboardingSteps.registered,
      ), // Enum parsing from string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role!.toJson(),
      'onboarding_step':
          onboardingStep.toString().split('.').last, // Enum to string
    };
  }
}

enum OnboardingSteps {
  registered,
  roleSelected, // Use camel case for Dart naming conventions
  completed,
}
