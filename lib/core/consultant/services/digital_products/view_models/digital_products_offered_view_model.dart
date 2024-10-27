import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DigitalProductsOfferedViewModel
    extends StateNotifier<AsyncValue<List<ServiceModel>>> {
  DigitalProductsOfferedViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<ServiceModel> serviceModel = [];
      await supabase
          .from('services')
          .select('*, user_id(*)')
          .eq('service_type', serviceTypeToString(ServiceType.digitalProduct))
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
  Future<void> create(ServiceModel serviceModel, WidgetRef ref) async {
    // Cache the current state before loading
    final previousSessions = state.value ?? [];
    try {
      state = const AsyncLoading(); // Set to loading
      try {
        final avatarFile = File(serviceModel.file!);
        String time = DateTime.now().toString();
        String fileExtension = serviceModel.file!.split('.').last;
        final String filePath =
            await supabase.storage.from('digital_products').upload(
                  '${supabase.auth.currentUser!.id}/$time.${fileExtension.toLowerCase()}',
                  avatarFile,
                  fileOptions:
                      const FileOptions(cacheControl: '3600', upsert: false),
                );
        final List<Map<String, dynamic>> res =
            await supabase.from('services').insert({
          'title': serviceModel.title,
          'description': serviceModel.description,
          'price': serviceModel.price,
          'duration': 'LifeTime',
          'file': filePath,
          'service_type': serviceTypeToString(ServiceType.digitalProduct),
        }).select('*, user_id(*)');

        var newSession = ServiceModel.fromJson(res.first);
        List<ServiceModel> updatedList = [
          ...previousSessions, // Retain previous jobs
          newSession, // Add the new member
        ];
        // Update the state with the new list
        state = AsyncData(updatedList);
        // Pop the screen and show a success message
        ref
            .read(createDigitalProductsOfferedSuccessMsgProvider.notifier)
            .state = 'Digital Product Added Successful!';
      } on StorageException catch (e) {
        state = AsyncData(previousSessions);
        ref.read(createDigitalProductsOfferedErrorMsgProvider.notifier).state =
            e.toString();
      }
    } on PostgrestException catch (e) {
      state = AsyncData(previousSessions);
      ref.read(createDigitalProductsOfferedErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Update a role (Update)
  Future<void> update(ServiceModel serviceModel, WidgetRef ref) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();
      final avatarFile = File(serviceModel.file!);
      String time = DateTime.now().toString();
      String fileExtension = serviceModel.file!.split('.').last;
      final String filePath = await supabase.storage
          .from('digital_products')
          .upload(
            '${supabase.auth.currentUser!.id}/$time.${fileExtension.toLowerCase()}',
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final List<Map<String, dynamic>> res = await supabase
          .from('services')
          .update({
            'title': serviceModel.title,
            'description': serviceModel.description,
            'price': serviceModel.price,
            'service_type': serviceTypeToString(ServiceType.digitalProduct),
            'file': filePath,
          })
          .eq('id', serviceModel.id!)
          .select('*, user_id(*)');

      ServiceModel serviceFromResponse = ServiceModel.fromJson(res.first);
      List<ServiceModel> updatedList = (previousServices).map((service) {
        return service.id == serviceModel.id ? serviceFromResponse : service;
      }).toList();
      ref.read(updateDigitalProductsOfferedSuccessMsgProvider.notifier).state =
          'Digital Product Updated Successful!';
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(updateDigitalProductsOfferedErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Delete a role (Delete)
  Future<void> delete(WidgetRef ref, String id, String file) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();

      await supabase
          .from('services')
          .delete()
          .eq('id', id)
          .select('*, user_id(*)');
      file = file.replaceAll('digital_products/', '');
      await supabase.storage.from('digital_products').remove([file]);

      final updatedList =
          (previousServices).where((member) => member.id != id).toList();

      state = AsyncData(updatedList);
      ref.read(deleteDigitalProductsOfferedSuccessMsgProvider.notifier).state =
          'Digital Product deleted successfully!';
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(deleteDigitalProductsOfferedErrorMsgProvider.notifier).state =
          e.toString();
    }
  }
}

final digitalProductsOfferedViewModelProvider = StateNotifierProvider<
    DigitalProductsOfferedViewModel, AsyncValue<List<ServiceModel>>>(
  (ref) => DigitalProductsOfferedViewModel(),
);

final deleteDigitalProductsOfferedErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final deleteDigitalProductsOfferedSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final updateDigitalProductsOfferedErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final updateDigitalProductsOfferedSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final createDigitalProductsOfferedErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final createDigitalProductsOfferedSuccessMsgProvider =
    StateProvider<String?>((ref) => null);
