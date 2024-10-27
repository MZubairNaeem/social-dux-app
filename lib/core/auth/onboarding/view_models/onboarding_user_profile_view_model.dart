import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/model/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingUserProfileViewModel extends StateNotifier<AsyncValue<bool>> {
  OnboardingUserProfileViewModel() : super(const AsyncData(false));

  Future<void> createUserProfile(UserProfileModel userProfileModel) async {
    state = const AsyncLoading();
    try {
      await supabase.from('user_profiles').insert({
        'domain_id': userProfileModel.domainId,
        'tagline': userProfileModel.tagline,
        'about': userProfileModel.about,
        'page_link': userProfileModel.pageLink,
      });
      final onboardingStep = OnboardingSteps.completed.name;

      await supabase.from('users').update({
        'onboarding_step': onboardingStep,
      }).eq('id', supabase.auth.currentUser!.id);
      state = const AsyncData(true);
    } on PostgrestException catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final onboardingUserProfileViewModelProvider =
    StateNotifierProvider<OnboardingUserProfileViewModel, AsyncValue<bool>>(
  (ref) => OnboardingUserProfileViewModel(),
);
