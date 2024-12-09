import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/user_model.dart';

final userProvider = FutureProvider.family<UserModel, String>(
  (ref, id) async {
    UserModel? userModel;
    try {
      await supabase
          .from('users')
          .select('*, roles(id,name)')
          .eq('id', id)
          .single()
          .then(
        (value) {
          userModel = UserModel.fromJson(value);
        },
      );
      return userModel!;
    } catch (e) {
      return userModel!;
    }
  },
);
