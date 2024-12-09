import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/available_slot_model.dart';

final availableSlotById =
    FutureProvider.family<List<AvailableSlotModel>, String>(
  (ref, id) async {
    List<AvailableSlotModel> serviceModel = [];
    try {
      await supabase
          .from('available_slots')
          .select('*, available_days(*)')
          .eq('user_id', id)
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(AvailableSlotModel.fromJson(item));
          }
        },
      );
      serviceModel =
          serviceModel.where((slot) => slot.serviceId == null).toList();
      return serviceModel;
    } catch (e) {
      return serviceModel;
    }
  },
);
