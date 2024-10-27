// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:scp/core/auth/login/view/login_page.dart';
import 'package:scp/core/auth/onboarding/view/onboarding_page.dart';
import 'package:scp/core/auth/onboarding/view/onboarding_user_profile_page.dart';
import 'package:scp/core/buyer/buyer_dashboard/view/buyer_dashboard_page.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/consultant_dashboard.dart';
import 'package:scp/main.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/model/role_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: primaryColor,
            body: Center(
              child: Image.asset('lib/assets/logo/social_dux_logo.png'),
            ),
          );
        }

        if (snapshot.hasData) {
          final session = snapshot.data!.session;

          if (session != null) {
            // Use a FutureBuilder to fetch the user data
            return FutureBuilder(
              future: supabase
                  .from('users')
                  .select('*,roles(*)')
                  .eq('id', session.user.id)
                  .single(),
              builder: (context, resSnapshot) {
                if (resSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: primaryColor,
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (resSnapshot.hasData) {
                  final res = resSnapshot.data as Map<String, dynamic>;

                  // Extracting user fields
                  final user = AuthUserModel(
                    id: res['id'], // User ID
                    name: res['name'], // User Name
                    email: res['email'], // User Email
                    role: res['roles'] != null
                        ? RoleModel.fromJson(res['roles'])
                        : null, // Convert to RoleModel if not null
                    onboardingStep: OnboardingSteps.values.firstWhere(
                      (e) =>
                          e.toString().split('.').last ==
                          res['onboarding_step'],
                      orElse: () => OnboardingSteps.registered, // Default step
                    ),
                  );

                  // Trigger navigation after build phase
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (user.onboardingStep == OnboardingSteps.registered) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OnboardingPage(),
                        ),
                      );
                    } else if (user.onboardingStep ==
                        OnboardingSteps.roleSelected) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OnboardingUserProfilePage(),
                        ),
                      );
                    } else if (user.onboardingStep ==
                        OnboardingSteps.completed) {
                      if (user.role?.name == 'BUYER') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BuyerDashboardPage(),
                          ),
                        );
                      } else if (user.role?.name == 'CONSULTANT') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConsultantDashboard(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      }
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    }
                  });

                  return Scaffold(
                    backgroundColor: primaryColor,
                    body: Center(
                      child: Image.asset('lib/assets/logo/social_dux_logo.png'),
                    ),
                  );
                } else if (resSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${resSnapshot.error}'),
                    ),
                  );
                }

                return Scaffold(
                  backgroundColor: primaryColor,
                  body: Center(
                    child: Image.asset('lib/assets/logo/social_dux_logo.png'),
                  ),
                );
              },
            );
          } else {
            return const LoginPage();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
