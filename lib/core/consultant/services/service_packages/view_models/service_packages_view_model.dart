import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_package_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicePackagesViewModel
    extends StateNotifier<AsyncValue<List<ServicePackageModel>>> {
  ServicePackagesViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<ServicePackageModel> servicePackageModel = [];

      await supabase
          .from('service_packages')
          .select(
              '*, user_id(*), one_to_one_session_service_id(*), digital_product_service_id(*), priority_dm_service_id(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            servicePackageModel.add(ServicePackageModel.fromJson(item));
          }
          state = AsyncData(servicePackageModel);
        },
      );
    } on PostgrestException catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  // Create a service (Create)
  Future<void> create(
      ServicePackageModel servicePackageModel, WidgetRef ref) async {
    // Cache the current state before loading
    final previousSessions = state.value ?? [];
    try {
      state = const AsyncLoading(); // Set to loading

      final List<Map<String, dynamic>> res = await supabase
          .from('service_packages')
          .insert({
            'title': servicePackageModel.title,
            'price': servicePackageModel.price,
            'one_to_one_session_service_id':
                servicePackageModel.oneToOneSessionServiceid,
            'digital_product_service_id':
                servicePackageModel.digitalProductServiceid,
            'priority_dm_service_id': servicePackageModel.priorityDmServiceid,
          })
          .eq('user_id', supabase.auth.currentUser!.id)
          .select(
              '*, user_id(*), one_to_one_session_service_id(*), digital_product_service_id(*), priority_dm_service_id(*)');

      var newSession = ServicePackageModel.fromJson(res.first);
      List<ServicePackageModel> updatedList = [
        ...previousSessions, // Retain previous jobs
        newSession, // Add the new member
      ];
      // Update the state with the new list
      state = AsyncData(updatedList);
      // Pop the screen and show a success message
      ref.read(createServicePackagesSuccessMsgProvider.notifier).state =
          'Service Package Created Successful!';
    } on PostgrestException catch (e) {
      state = AsyncData(previousSessions);
      ref.read(createServicePackagesErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Update a service (Update)
  Future<void> update(
      ServicePackageModel servicePackageModel, WidgetRef ref) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();

      final List<Map<String, dynamic>> res = await supabase
          .from('service_packages')
          .update({
            'title': servicePackageModel.title,
            'price': servicePackageModel.price,
            'one_to_one_session_service_id':
                servicePackageModel.oneToOneSessionServiceid,
            'digital_product_service_id':
                servicePackageModel.digitalProductServiceid,
            'priority_dm_service_id': servicePackageModel.priorityDmServiceid,
          })
          .eq('id', servicePackageModel.id!)
          .select(
              '*, user_id(*), one_to_one_session_service_id(*), digital_product_service_id(*), priority_dm_service_id(*)');

      ServicePackageModel serviceFromResponse =
          ServicePackageModel.fromJson(res.first);
      List<ServicePackageModel> updatedList = (previousServices).map((service) {
        return service.id == servicePackageModel.id
            ? serviceFromResponse
            : service;
      }).toList();
      ref.read(updateServicePackagesSuccessMsgProvider.notifier).state =
          'Service Package Updated Successful!';
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(updateServicePackagesErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Delete a service (Delete)
  Future<void> delete(WidgetRef ref, String id) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();

      await supabase.from('service_packages').delete().eq('id', id).select(
          '*, user_id(*), one_to_one_session_service_id(*), digital_product_service_id(*), priority_dm_service_id(*)');

      final updatedList =
          (previousServices).where((member) => member.id != id).toList();

      state = AsyncData(updatedList);
      ref.read(deleteServicePackagesSuccessMsgProvider.notifier).state =
          'Service Package deleted successfully!';
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(deleteServicePackagesErrorMsgProvider.notifier).state =
          e.toString();
    }
  }
}

final servicePackagesViewModelProvider = StateNotifierProvider<
    ServicePackagesViewModel, AsyncValue<List<ServicePackageModel>>>(
  (ref) => ServicePackagesViewModel(),
);

final deleteServicePackagesErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final deleteServicePackagesSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final updateServicePackagesErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final updateServicePackagesSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final createServicePackagesErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final createServicePackagesSuccessMsgProvider =
    StateProvider<String?>((ref) => null);
