import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/bookings_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuyerBookingsViewModel
    extends StateNotifier<AsyncValue<List<BookingsModel>>> {
  BuyerBookingsViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<BookingsModel> bookings = [];
      await supabase
          .from('bookings')
          .select('*, buyer_id(*), service_id(*)')
          .eq('buyer_id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            bookings.add(BookingsModel.fromJson(item));
          }
          state = AsyncData(bookings);
        },
      );
    } on PostgrestException catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  // Create a new job (Create)
  Future<void> create(
      String? endTime, WidgetRef ref, String serviceId, String? slotId) async {
    // Cache the current state before loading
    final previousBooking = state.value ?? [];
    try {
      state = const AsyncLoading(); // Set to loading
      try {
        final List<Map<String, dynamic>> res =
            await supabase.from('bookings').insert({
          'end_time': endTime,
          'service_id': serviceId,
        }).select('*, buyer_id(*), service_id(*)');

        var newSession = BookingsModel.fromJson(res.first);
        List<BookingsModel> updatedList = [
          ...previousBooking, // Retain previous jobs
          newSession, // Add the new member
        ];
        if (slotId != null) {
          await supabase.from('available_slots').update(
              {'buyer_id': supabase.auth.currentUser!.id}).eq('id', slotId);
        }
        // Update the state with the new list
        state = AsyncData(updatedList);
        // Pop the screen and show a success message
        ref.read(createbuyerBookingsSuccessMsgProvider.notifier).state =
            'Successful!';
      } on StorageException catch (e) {
        state = AsyncData(previousBooking);
        ref.read(createbuyerBookingsErrorMsgProvider.notifier).state =
            e.toString();
      }
    } on PostgrestException catch (e) {
      state = AsyncData(previousBooking);
      ref.read(createbuyerBookingsErrorMsgProvider.notifier).state =
          e.toString();
    }
  }
}

final buyerBookingsViewModelProvider = StateNotifierProvider<
    BuyerBookingsViewModel, AsyncValue<List<BookingsModel>>>(
  (ref) => BuyerBookingsViewModel(),
);

final createbuyerBookingsErrorMsgProvider =
    StateProvider<String?>((ref) => null);
final createbuyerBookingsSuccessMsgProvider =
    StateProvider<String?>((ref) => null);
