import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/user_model.dart';

final userProvider = FutureProvider<UserModel>(
  (ref) async {
    UserModel? userModel;
    try {
      final data = await supabase.auth.getUser();
      if (data.user != null) {
        await supabase
            .from('users')
            .select('*, roles(id,name)')
            .eq('id', data.user!.id)
            .single()
            .then(
          (value) {
            userModel = UserModel.fromJson(value);
          },
        );
      } else {
        return userModel!;
      }
      return userModel!;
    } catch (e) {
      return userModel!;
    }
  },
);
