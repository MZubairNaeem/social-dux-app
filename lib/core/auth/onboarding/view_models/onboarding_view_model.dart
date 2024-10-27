import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/model/role_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoleSelectViewModel extends StateNotifier<AsyncValue<AuthUserModel?>> {
  RoleSelectViewModel() : super(const AsyncData(null));

  Future<void> roleSelect(bool isBuyer) async {
    try {
      state = const AsyncLoading();
      try {
        final roleId = isBuyer
            ? '2cc7cbae-291e-4e6d-9efb-1c547b21bb34'
            : '34986ce7-03c7-4da4-acd5-acc5181652f8';

        final onboardingStep = isBuyer
            ? OnboardingSteps.completed.name
            : OnboardingSteps.roleSelected.name;

        final user = await supabase
            .from('users')
            .update({
              'role_id': roleId,
              'onboarding_step': onboardingStep, // Convert enum to string
            })
            .eq('id', supabase.auth.currentUser!.id)
            .select('*, roles(*)')
            .single();

        state = AsyncData(
          AuthUserModel(
            id: supabase.auth.currentUser!.id,
            name: user['name'],
            email: user['email'],
            role: RoleModel.fromJson(user['roles']),
            onboardingStep: OnboardingSteps.values.firstWhere(
              (e) => e.toString().split('.').last == user['onboarding_step'],
              orElse: () => OnboardingSteps.registered, // Default step
            ),
          ),
        );
      } on PostgrestException catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    } on AuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final roleSelectViewModelProvider =
    StateNotifierProvider<RoleSelectViewModel, AsyncValue<AuthUserModel?>>(
  (ref) => RoleSelectViewModel(),
);
