import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/user_model.dart';

final allServiceCategoriesProvider = FutureProvider<List<UserModel>>(
  (ref) async {
    List<UserModel> serviceModel = [];
    try {
      await supabase
          .from('users')
          .select('*, services(*), user_profiles(*, domains(*))')
          .eq('role_id', '34986ce7-03c7-4da4-acd5-acc5181652f8')
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(UserModel.fromJson(item));
          }
        },
      );
      return serviceModel;
    } catch (e) {
      return serviceModel;
    }
  },
);

final allFilterConsultantsProvider =
    FutureProvider.family<List<UserModel>, String>(
  (ref, domainName) async {
    List<UserModel> serviceModel = [];
    try {
      await supabase
          .from('users')
          .select('*, services(*), user_profiles(*, domains(*))')
          .eq('role_id', '34986ce7-03c7-4da4-acd5-acc5181652f8')
          // .eq('user_profiles.domains.name', 'Technology')
          .then(
        (value) {
          for (var item in value) {
            final user = UserModel.fromJson(item);
            if (user.userProfiles?.domains?.name == domainName) {
              serviceModel.add(user);
            }
          }
        },
      );
      return serviceModel;
    } catch (e) {
      return serviceModel;
    }
  },
);

final searchedConsultantByNameProvider =
    FutureProvider.family<List<UserModel>, String>(
  (ref, search) async {
    List<UserModel> serviceModel = [];
    try {
      await supabase
          .from('users')
          .select('*, services(*), user_profiles(*, domains(*))')
          .eq('role_id', '34986ce7-03c7-4da4-acd5-acc5181652f8')
          .ilike('name', '%$search%')
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(UserModel.fromJson(item));
          }
        },
      );
      return serviceModel;
    } catch (e) {
      return serviceModel;
    }
  },
);
