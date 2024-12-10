import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/testimonial_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestimonialsViewModel
    extends StateNotifier<AsyncValue<List<TestimonialModel>>> {
  TestimonialsViewModel() : super(const AsyncData([]));

  Future<void> list() async {
    try {
      state = const AsyncLoading();
      List<TestimonialModel> testimonialModel = [];
      await supabase
          .from('testimonials')
          .select('*, user_id(*), service_id(*, users(*))')
          .eq('service_id.users.id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            log('testimonials');
            log(item.toString());
            testimonialModel.add(TestimonialModel.fromJson(item));
          }
          state = AsyncData(testimonialModel);
        },
      );
    } on PostgrestException catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  // Delete a role (Delete)
  Future<void> delete(WidgetRef ref, String id) async {
    final previousTestimonials = state.value ?? [];
    try {
      state = const AsyncLoading();

      await supabase
          .from('testimonials')
          .delete()
          .eq('id', id)
          .select('*, user_id(*), service_id(*)');

      final updatedList =
          (previousTestimonials).where((member) => member.id != id).toList();

      state = AsyncData(updatedList);
      ref.read(deleteTestimonialSuccessMsgProvider.notifier).state =
          'Testimonial deleted successfully!';
    } catch (e) {
      state = AsyncData(previousTestimonials);
      ref.read(deleteTestimonialErrorMsgProvider.notifier).state = e.toString();
    }
  }
}

final testimonialsViewModelProvider = StateNotifierProvider<
    TestimonialsViewModel, AsyncValue<List<TestimonialModel>>>(
  (ref) => TestimonialsViewModel(),
);

final deleteTestimonialErrorMsgProvider = StateProvider<String?>((ref) => null);
final deleteTestimonialSuccessMsgProvider =
    StateProvider<String?>((ref) => null);
