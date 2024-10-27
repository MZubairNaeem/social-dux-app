import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PriorityDmServiceViewModel
    extends StateNotifier<AsyncValue<List<ServiceModel>>> {
  PriorityDmServiceViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<ServiceModel> serviceModel = [];
      await supabase
          .from('services')
          .select('*, user_id(*)')
          .eq('service_type', serviceTypeToString(ServiceType.priorityDM))
          .eq('user_id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(ServiceModel.fromJson(item));
          }
          state = AsyncData(serviceModel);
        },
      );
    } on PostgrestException catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  // Create a service (Create)
  Future<void> create(ServiceModel serviceModel, WidgetRef ref) async {
    // Cache the current state before loading
    final previousSessions = state.value ?? [];
    try {
      state = const AsyncLoading(); // Set to loading

      final List<Map<String, dynamic>> res =
          await supabase.from('services').insert({
        'title': serviceModel.title,
        'description': serviceModel.description,
        'price': serviceModel.price,
        'duration': '${serviceModel.duration!} days',
        'service_type': serviceTypeToString(ServiceType.priorityDM),
      }).select('*, user_id(*)');

      var newSession = ServiceModel.fromJson(res.first);
      List<ServiceModel> updatedList = [
        ...previousSessions, // Retain previous jobs
        newSession, // Add the new member
      ];
      // Update the state with the new list
      state = AsyncData(updatedList);
      // Pop the screen and show a success message
      ref.read(createPriorityDmServiceSuccessMsgProvider.notifier).state =
          'Priority DM Service Created Successful!';
    } on PostgrestException catch (e) {
      state = AsyncData(previousSessions);
      ref.read(createPriorityDmServiceErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Update a service (Update)
  Future<void> update(ServiceModel serviceModel, WidgetRef ref) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();

      final List<Map<String, dynamic>> res = await supabase
          .from('services')
          .update({
            'title': serviceModel.title,
            'description': serviceModel.description,
            'price': serviceModel.price,
            'duration': '${serviceModel.duration!} days',
            'service_type': serviceTypeToString(ServiceType.priorityDM),
          })
          .eq('id', serviceModel.id!)
          .select('*, user_id(*)');

      ServiceModel serviceFromResponse = ServiceModel.fromJson(res.first);
      List<ServiceModel> updatedList = (previousServices).map((service) {
        return service.id == serviceModel.id ? serviceFromResponse : service;
      }).toList();
      ref.read(updatePriorityDmServiceSuccessMsgProvider.notifier).state =
          'Priority DM Service Updated Successful!';
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(updatePriorityDmServiceErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Delete a service (Delete)
  Future<void> delete(WidgetRef ref, String id) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();

      await supabase
          .from('services')
          .delete()
          .eq('id', id)
          .select('*, user_id(*)');

      final updatedList =
          (previousServices).where((member) => member.id != id).toList();

      state = AsyncData(updatedList);
      ref.read(deletePriorityDmServiceSuccessMsgProvider.notifier).state =
          'Priority DM Service deleted successfully!';
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(deletePriorityDmServiceErrorMsgProvider.notifier).state =
          e.toString();
    }
  }
}

final priorityDmServiceViewModelProvider = StateNotifierProvider<
    PriorityDmServiceViewModel, AsyncValue<List<ServiceModel>>>(
  (ref) => PriorityDmServiceViewModel(),
);

final deletePriorityDmServiceErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final deletePriorityDmServiceSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final updatePriorityDmServiceErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final updatePriorityDmServiceSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final createPriorityDmServiceErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final createPriorityDmServiceSuccessMsgProvider =
    StateProvider<String?>((ref) => null);
