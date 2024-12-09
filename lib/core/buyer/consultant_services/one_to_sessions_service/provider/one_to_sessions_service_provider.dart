import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';

final oneToOneSeesionServiceProvider =
    FutureProvider.family<List<ServiceModel>, String>(
  (ref, id) async {
    List<ServiceModel> serviceModel = [];
    try {
      await supabase
          .from('services')
          .select('*, users(*)')
          .eq('user_id', id)
          .eq('service_type', serviceTypeToString(ServiceType.oneToOneSession))
          .then(
        (value) {
          for (var item in value) {
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
