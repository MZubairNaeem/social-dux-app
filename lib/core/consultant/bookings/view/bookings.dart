import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/bookings/providers/all_services_provider.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';

class Bookings extends ConsumerWidget {
  const Bookings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(allServiceWithBookings);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Bookings',
          icon: true,
        ),
      ),
      body: bookings.when(
        data: (value) {
          log(value.length.toString());
          if (value.isEmpty) {
            return Center(
              child: Text(
                'No Bookings Yet!',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              // final dateTime = DateTime.parse(value[index].);
              // var endTime = '';

              // if (value[index].endTime != null) {
              //   final endDateTime = DateTime.parse(value[index].endTime!);

              //   endTime = DateFormat('d MMM, y').format(endDateTime);
              // }

              // Format the DateTime object
              // final startTime = DateFormat('d MMM, y').format(dateTime);
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: hintText.withOpacity(0.2),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          value[index].title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      value[index].description!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: textColor,
                        wordSpacing: 0.1,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                    border: Border.all(
                                      color: accentColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "${value[index].price} Pkr",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 1.h),
                                // if (endTime != '')
                                //   Container(
                                //     padding: EdgeInsets.symmetric(
                                //         horizontal: 3.w, vertical: 2.w),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(10.w)),
                                //       border: Border.all(
                                //         color: primaryColor,
                                //         width: 1,
                                //       ),
                                //     ),
                                //     child: Text(
                                //       'End Time $endTime',
                                //       style: TextStyle(
                                //         fontSize: 15.sp,
                                //         color: primaryColor,
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    Text(
                      'Service Bought By: ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value[index].bookings!.length,
                      itemBuilder: (context, c) {
                        DateTime date = DateTime.parse(
                            value[index].bookings![c].createdAt!);

                        // Format the date
                        String formattedDate =
                            DateFormat("d MMM yyyy").format(date);
                        return Text(
                          "By ${value[index].bookings![c].buyerId!.name} \nTime of Booking $formattedDate",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () =>
            const Center(child: CustomProgressIndicator(color: primaryColor)),
      ),
    );
  }
}
