import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterViewModel extends StateNotifier<AsyncValue<AuthUserModel?>> {
  RegisterViewModel() : super(const AsyncData(null));

  Future<void> regitser(String name, String email, String password) async {
    try {
      state = const AsyncLoading();
      final response =
          await supabase.auth.signUp(email: email, password: password);
      try {
        await supabase.from('users').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
        });
        state = AsyncData(
          AuthUserModel(
            id: response.user!.id,
            name: name,
            email: email,
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

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, AsyncValue<AuthUserModel?>>(
  (ref) => RegisterViewModel(),
);
