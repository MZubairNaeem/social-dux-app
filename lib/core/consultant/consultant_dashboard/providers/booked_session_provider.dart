import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';

final bookedSessionCountProvider = FutureProvider<String>(
  (ref) async {
    List<ServiceModel> serviceModel = [];

    int count = 0;
    try {
      await supabase
          .from('services')
          .select('*, bookings(*, buyer_id(*), service_id(*)), users(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('service_type', serviceTypeToString(ServiceType.oneToOneSession))
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(ServiceModel.fromJson(item));
          }
          for (var c in serviceModel) {
            count = count + c.bookings!.length;
          }
        },
      );
      return count.toString();
    } catch (e) {
      return count.toString();
    }
  },
);

final priorityDMBookedCountProvider = FutureProvider<String>(
  (ref) async {
    List<ServiceModel> serviceModel = [];

    int count = 0;
    try {
      await supabase
          .from('services')
          .select('*, bookings(*, buyer_id(*), service_id(*)), users(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('service_type', serviceTypeToString(ServiceType.priorityDM))
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(ServiceModel.fromJson(item));
          }
          for (var c in serviceModel) {
            count = count + c.bookings!.length;
          }
        },
      );
      return count.toString();
    } catch (e) {
      return count.toString();
    }
  },
);

final testimonialsCountProviders = FutureProvider<String>(
  (ref) async {
    int count = 0; // Initialize the count
    try {
      // Query the testimonials from the database
      final response = await supabase
          .from('testimonials')
          .select('*, user_id(*), service_id(*, users(*))')
          .eq('service_id.users.id',
              supabase.auth.currentUser!.id); // Filter by current user ID

      // Loop through the response and count matching testimonials
      for (var item in response) {
        if (item['service_id']['users']['id'] ==
            supabase.auth.currentUser!.id) {
          count++;
        }
      }

      // Return the count as a string
      return count.toString();
    } catch (e) {
      // Log the error for debugging
      log('Error fetching testimonials: $e');
      return count.toString(); // Return the count as 0 if there's an error
    }
  },
);

final paymentCount = FutureProvider<String>(
  (ref) async {
    List<ServiceModel> serviceModel = [];

    int count = 0;
    try {
      await supabase
          .from('services')
          .select('*, bookings(*, buyer_id(*), service_id(*)), users(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .then(
        (value) {
          for (var item in value) {
            serviceModel.add(ServiceModel.fromJson(item));
          }
          for (var c in serviceModel) {
            for (var x in c.bookings!) {
              count = count + int.parse(c.price.toString());
            }
          }
        },
      );
      return count.toString();
    } catch (e) {
      return count.toString();
    }
  },
);
