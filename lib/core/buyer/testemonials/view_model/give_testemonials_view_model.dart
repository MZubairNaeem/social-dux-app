import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/testimonial_model.dart';

final buyerTestemonialForService =
    FutureProvider.family<List<TestimonialModel>, String>(
  (ref, id) async {
    List<TestimonialModel> testemonialsModel = [];
    try {
      await supabase
          .from('testimonials')
          .select('*, user_id(*), service_id(*)')
          .eq('booking_id', id)
          .then(
        (value) {
          for (var item in value) {
            testemonialsModel.add(TestimonialModel.fromJson(item));
          }
        },
      );
      return testemonialsModel;
    } catch (e) {
      return testemonialsModel;
    }
  },
);
