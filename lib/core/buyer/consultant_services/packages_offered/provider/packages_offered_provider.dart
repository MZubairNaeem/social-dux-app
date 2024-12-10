import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_package_model.dart';

final packagesOfferedProvider =
    FutureProvider.family<List<ServicePackageModel>, String>(
  (ref, id) async {
    List<ServicePackageModel> serviceModel = [];
    try {
      await supabase
          .from('service_packages')
          .select(
              '*, users(*), one_to_one_session_service_id(*, available_slots(*, available_days(*))), digital_product_service_id(*), priority_dm_service_id(*)')
          .eq('user_id', id)
          .then(
        (value) {
          for (var item in value) {
            log(item.toString());
            serviceModel.add(ServicePackageModel.fromJson(item));
          }
        },
      );
      return serviceModel;
    } catch (e) {
      return serviceModel;
    }
  },
);
