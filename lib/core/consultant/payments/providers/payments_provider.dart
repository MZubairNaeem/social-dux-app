import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';

final paymentProvider = FutureProvider<List<ServiceModel>>(
  (ref) async {
    List<ServiceModel> serviceModel = [];
    try {
      await supabase
          .from('services')
          .select('*, bookings(*, buyer_id(*), service_id(*)), users(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            log(item.toString());
            serviceModel.add(ServiceModel.fromJson(item));
          }
        },
      );
      return serviceModel;
    } catch (e) {
      return serviceModel;
    }
  },
);
