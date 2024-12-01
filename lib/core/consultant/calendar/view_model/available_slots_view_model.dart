import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/available_slot_model.dart';
import 'package:scp/model/service_package_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailableSlotsViewModel
    extends StateNotifier<AsyncValue<List<AvailableSlotModel>>> {
  AvailableSlotsViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<AvailableSlotModel> availableSlotModel = [];

      await supabase
          .from('available_slots')
          .select('*, available_days(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            availableSlotModel.add(AvailableSlotModel.fromJson(item));
          }
          state = AsyncData(availableSlotModel);
        },
      );
    } on PostgrestException catch (e, st) {
      log(e.toString());
      state = AsyncError(e.toString(), st);
    }
  }

  // Create a service (Create)
  Future<void> create(List<String> days, TimeOfDay startTime, TimeOfDay endTime,
      WidgetRef ref) async {
    // Cache the current state before loading
    final previousSlots = state.value ?? [];
    try {
      state = const AsyncLoading(); // Set to loading

      final List<Map<String, dynamic>> res =
          await supabase.from('available_slots').insert({
        'start_time': convertTimeOfDayToString(startTime),
        'end_time': convertTimeOfDayToString(endTime),
      }).select('*, available_days(*)');

      for (var day in days) {
        await supabase.from('available_days').insert({
          'day': day,
          'available_slot_id': res[0]['id'],
        }).select('*, available_slot_id(*)');
      }

      final List<Map<String, dynamic>> res3 = await supabase
          .from('available_slots')
          .select('*, available_days(*)')
          .eq('id', res[0]['id']);

      var newSession = AvailableSlotModel.fromJson(res3.first);
      List<AvailableSlotModel> updatedList = [
        ...previousSlots, // Retain previous jobs
        newSession, // Add the new member
      ];
      // Update the state with the new list
      state = AsyncData(updatedList);
      // Pop the screen and show a success message
      ref.read(createAvailableSlotSuccessMsgProvider.notifier).state =
          'Available Slot Created Successful!';
    } on PostgrestException catch (e) {
      log(e.toString());
      state = AsyncData(previousSlots);
      ref.read(createAvailableSlotErrorMsgProvider.notifier).state =
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

      AvailableSlotModel serviceFromResponse =
          AvailableSlotModel.fromJson(res.first);
      List<AvailableSlotModel> updatedList = (previousServices).map((service) {
        return service.id == servicePackageModel.id
            ? serviceFromResponse
            : service;
      }).toList();
      ref.read(updateAvailableSlotSuccessMsgProvider.notifier).state =
          'Service Package Updated Successful!';
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(updateAvailableSlotErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  Future<void> statusChange(bool status, String id, WidgetRef ref) async {
    final previousSlots = state.value ?? [];
    try {
      state = const AsyncLoading();

      final List<Map<String, dynamic>> res = await supabase
          .from('available_slots')
          .update({
            'status': status,
          })
          .eq('id', id)
          .select('*, available_days(*)');

      AvailableSlotModel slotFromResponse =
          AvailableSlotModel.fromJson(res.first);
      List<AvailableSlotModel> updatedList = (previousSlots).map((slot) {
        return slot.id == id ? slotFromResponse : slot;
      }).toList();
      ref.read(changeAvailableSlotStatusSuccessMsgProvider.notifier).state =
          'Slot Status Changed Successful!';
      state = AsyncData(updatedList);
    } catch (e) {
      state = AsyncData(previousSlots);
      ref.read(changeAvailableSlotStatusErrorMsgProvider.notifier).state =
          e.toString();
    }
  }

  // Delete a service (Delete)
  Future<void> delete(WidgetRef ref, String id) async {
    final previousServices = state.value ?? [];
    try {
      state = const AsyncLoading();

      await supabase
          .from('available_slots')
          .delete()
          .eq('id', id)
          .select('*, available_days(*)');

      final updatedList =
          (previousServices).where((member) => member.id != id).toList();

      state = AsyncData(updatedList);
      ref.read(deleteAvailableSlotSuccessMsgProvider.notifier).state =
          'Slot deleted successfully!';
    } catch (e) {
      state = AsyncData(previousServices);
      ref.read(deleteAvailableSlotErrorMsgProvider.notifier).state =
          e.toString();
    }
  }
}

final availableSlotsViewModelProvider = StateNotifierProvider<
    AvailableSlotsViewModel, AsyncValue<List<AvailableSlotModel>>>(
  (ref) => AvailableSlotsViewModel(),
);

final deleteAvailableSlotErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final deleteAvailableSlotSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final updateAvailableSlotErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final updateAvailableSlotSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final changeAvailableSlotStatusErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final changeAvailableSlotStatusSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

final createAvailableSlotErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final createAvailableSlotSuccessMsgProvider =
    StateProvider<String?>((ref) => null);

String convertTimeOfDayToString(TimeOfDay time) {
  final String hour = time.hour.toString().padLeft(2, '0');
  final String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
