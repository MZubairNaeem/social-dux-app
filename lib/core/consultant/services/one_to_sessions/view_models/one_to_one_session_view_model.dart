import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OneToOneSessionViewModel
    extends StateNotifier<AsyncValue<List<ServiceModel>>> {
  OneToOneSessionViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<ServiceModel> serviceModel = [];
      await supabase
          .from('services')
          .select('*, user_id(*), available_slots(*, available_days(*))')
          .eq('service_type', serviceTypeToString(ServiceType.oneToOneSession))
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

  // Create a new job (Create)
  Future<void> create(
      ServiceModel serviceModel, WidgetRef ref, String slotId) async {
    // Cache the current state before loading
    final previousSessions = state.value ?? [];
    try {
      state = const AsyncLoading(); // Set to loading

      final List<Map<String, dynamic>> res =
          await supabase.from('services').insert({
        'title': serviceModel.title,
        'description': serviceModel.description,
        'price': serviceModel.price,
        'duration': '${serviceModel.duration!} mins',
        'service_type': serviceTypeToString(ServiceType.oneToOneSession),
      }).select('*, user_id(*)');

      var newSession = ServiceModel.fromJson(res.first);
      await supabase
          .from('available_slots')
          .update({'service_id': newSession.id}).eq('id', slotId);
      List<ServiceModel> updatedList = [
        ...previousSessions, // Retain previous jobs
        newSession, // Add the new member
      ];
      // Update the state with the new list
      state = AsyncData(updatedList);
      // Pop the screen and show a success message
      ref.read(createoneToOneSessionSuccessMsgProvider.notifier).state =
          'One to One Session Created Successful!';
    } on PostgrestException catch (e) {
      state = AsyncData(previousSessions);
      ref.read(createoneToOneSessionErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Update a role (Update)
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
            'duration': '${serviceModel.duration!} mins',
            'service_type': serviceTypeToString(ServiceType.oneToOneSession),
          })
          .eq('id', serviceModel.id!)
          .select('*, user_id(*)');

      ServiceModel serviceFromResponse = ServiceModel.fromJson(res.first);
      List<ServiceModel> updatedList = (previousServices).map((service) {
        return service.id == serviceModel.id ? serviceFromResponse : service;
      }).toList();
      ref.read(updateoneToOneSessionSuccessMsgProvider.notifier).state =
          'One to One Session Updated Successful!';
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(updateoneToOneSessionErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Delete a role (Delete)
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
      ref.read(deleteoneToOneSessionSuccessMsgProvider.notifier).state =
          'One to One Session deleted successfully!';
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(deleteoneToOneSessionErrorMsgProvider.notifier).state =
          e.toString();
    }
  }
}

final oneToOneSessionViewModelProvider = StateNotifierProvider<
    OneToOneSessionViewModel, AsyncValue<List<ServiceModel>>>(
  (ref) => OneToOneSessionViewModel(),
);

final deleteoneToOneSessionErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final deleteoneToOneSessionSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final updateoneToOneSessionErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final updateoneToOneSessionSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final createoneToOneSessionErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final createoneToOneSessionSuccessMsgProvider =
    StateProvider<String?>((ref) => null);
