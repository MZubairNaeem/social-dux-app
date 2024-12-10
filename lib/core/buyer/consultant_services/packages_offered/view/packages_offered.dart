import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/consultant_services/packages_offered/provider/packages_offered_provider.dart';
import 'package:scp/core/buyer/consultant_services/packages_offered/view/package_offered_booking.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';

class PackagesOffered extends ConsumerWidget {
  final String id;
  const PackagesOffered({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorityDMService = ref.watch(packagesOfferedProvider(id));
    return Scaffold(
      body: priorityDMService.when(
        data: (value) {
          if (value.isEmpty) {
            return Center(
              child: Text(
                'No Service Package Found',
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
                    Wrap(
                      spacing: 3.w, // space between items
                      runSpacing: 2.w, // space between lines
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.w),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            value[index].oneToOneSessionServiceId!.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.w),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            value[index].priorityDmServiceId!.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.w),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            value[index].digitalProductServiceId!.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
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
                                '${value[index].price.toString()} Pkr',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PackageOfferedBooking(
                                  service: value[index],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Avail Offer',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        )
                      ],
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
