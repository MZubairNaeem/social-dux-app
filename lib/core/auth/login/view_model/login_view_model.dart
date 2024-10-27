import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/model/role_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginViewModel extends StateNotifier<AsyncValue<AuthUserModel?>> {
  LoginViewModel() : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        state = AsyncError(
          'Email and password must not be empty.',
          StackTrace.current,
        );
        return;
      }

      state = const AsyncLoading();
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      final user = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .select('*,roles(*)')
          .single()
          .then((value) => value);
      state = AsyncData(
        AuthUserModel(
          id: response.user!.id,
          name: user['name'],
          email: response.user!.email!,
          role: RoleModel.fromJson(user['roles']),
          onboardingStep: OnboardingSteps.values.firstWhere(
            (e) => e.toString().split('.').last == user['onboarding_step'],
            orElse: () => OnboardingSteps.registered, // Default step
          ),
        ),
      );
    } on AuthException catch (e) {
      if (e.message == 'Email not confirmed') {
        state = AsyncError(
          'Email not confirmed. Please check your email for the confirmation link.',
          StackTrace.current,
        );
      } else {
        state = AsyncError(e.message, StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  Future<void> logout() async {
    try {
      state = const AsyncLoading();
      // final url = Uri.parse(Api.logout);
      // final prefs = await SharedPreferences.getInstance();

      // // final response = await http.get(
      // //   url,
      // //   headers: {
      // //     'Content-Type': 'application/json',
      // //     'Authorization': 'Bearer ${prefs.getString('token')}'
      // //   },
      // // );

      // final responseData = jsonDecode(response.body);
      // if (responseData['success'] == true) {
      //   await prefs.remove('token');
      //   state = const AsyncData(null);
      // } else {
      //   state = AsyncError(
      //     'An error occurred while logging out. Please try again.',
      //     StackTrace.current,
      //   );
      // }
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<AuthUserModel?>>(
  (ref) => LoginViewModel(),
);
