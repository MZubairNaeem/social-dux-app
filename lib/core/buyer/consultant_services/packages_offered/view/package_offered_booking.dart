import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/bookings/view_models/buyer_bookings_view_model.dart';
import 'package:scp/model/service_package_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class PackageOfferedBooking extends ConsumerStatefulWidget {
  final ServicePackageModel service;

  const PackageOfferedBooking({super.key, required this.service});

  @override
  PackageOfferedBookingState createState() => PackageOfferedBookingState();
}

class PackageOfferedBookingState extends ConsumerState<PackageOfferedBooking> {
  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(buyerBookingsViewModelProvider);
    ref.listen<String?>(createbuyerBookingsErrorMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
        ref.read(createbuyerBookingsErrorMsgProvider.notifier).state = null;
      }
    });

    ref.listen<String?>(createbuyerBookingsSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        Navigator.of(context).pop();
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(createbuyerBookingsSuccessMsgProvider.notifier).state = null;
      }
    });

    final number = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'One Last Step',
          icon: true,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            child: Text(
              'Your are purchasing \'${widget.service.title}\' by \'${widget.service.users!.name}\' ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  widget.service.oneToOneSessionServiceId!.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget
                      .service.oneToOneSessionServiceId!.availableSlots!
                      .map<Widget>((slot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${slot.startTime} - ${slot.endTime}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: textColor,
                            wordSpacing: 0.1,
                            letterSpacing: 0.1,
                          ),
                        ),
                        if (slot.availableDays.isNotEmpty)
                          for (var day in slot.availableDays)
                            Text(
                              day.day,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: textColor.withOpacity(0.7),
                                wordSpacing: 0.1,
                                letterSpacing: 0.1,
                              ),
                            ),
                      ],
                    );
                  }).toList(),
                ),
                Text(
                  widget.service.digitalProductServiceId!.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.service.priorityDmServiceId!.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // availableSlotState.when(
          //   data: (value) {
          //     if (value.isEmpty) {
          //       return Center(
          //         child: Text(
          //           'No Slot Available',
          //           style: TextStyle(
          //             fontSize: 16.sp,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       );
          //     }
          //     return ListView.builder(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemCount: value.length,
          //       itemBuilder: (context, index) {
          //         slot = value[index].id;
          //         return Container(
          //           margin: EdgeInsets.all(5.w),
          //           padding: const EdgeInsets.all(10),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             border: Border.all(
          //               color: hintText.withOpacity(0.2),
          //               width: 0.5,
          //             ),
          //             borderRadius: BorderRadius.circular(3.w),
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Row(
          //                 children: [
          //                   Text(
          //                     '${value[index].startTime} - ${value[index].endTime}',
          //                     style: TextStyle(
          //                       fontSize: 18.sp,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                   const Spacer(),
          //                 ],
          //               ),
          //               SizedBox(height: 1.h),
          //               for (var day in value[index].availableDays)
          //                 Text(
          //                   '- ${day.day}',
          //                   textAlign: TextAlign.start,
          //                   style: TextStyle(
          //                     fontSize: 15.sp,
          //                     color: textColor,
          //                     wordSpacing: 0.1,
          //                     letterSpacing: 0.1,
          //                   ),
          //                 ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   error: (error, stackTrace) => Text('Error: $error'),
          //   loading: () => const Center(
          //     child: CustomProgressIndicator(color: primaryColor),
          //   ),
          // ),
          SizedBox(height: 3.h),
          //outline textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: TextFormField(
              controller: number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Your Easypaisa or Jazzcash number is required';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                helperText: 'Pay via Easypaisa or Jazzcash',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.sp,
                  horizontal: 12.sp,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hintText),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              cursorColor: primaryColorDark,
            ),
          ),

          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: ElevatedButton(
              onPressed: () {
                if (number.text.isEmpty) {
                  CustomSnackbar.showSnackbar(
                      context, 'Enter number to detect payment', false);
                  return;
                }
                ref.read(buyerBookingsViewModelProvider.notifier).create(
                      null,
                      ref,
                      widget.service.digitalProductServiceId!.id!,
                      null,
                    );
                ref.read(buyerBookingsViewModelProvider.notifier).create(
                      null,
                      ref,
                      widget.service.priorityDmServiceId!.id!,
                      null,
                    );
                ref.read(buyerBookingsViewModelProvider.notifier).create(
                      null,
                      ref,
                      widget.service.oneToOneSessionServiceId!.id!,
                      widget.service.oneToOneSessionServiceId!
                          .availableSlots![0].id,
                    );
              },
              style: ButtonStyle(
                overlayColor: WidgetStateColor.resolveWith(
                  (states) => primaryColorDark,
                ),
                minimumSize: WidgetStateProperty.all(
                  Size(90.w, 5.h),
                ),
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => primaryColor,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: 12.sp,
                    horizontal: 20.sp,
                  ),
                ),
              ),
              child: bookingState is AsyncLoading
                  ? const CustomProgressIndicator(
                      color: white,
                    )
                  : Text(
                      'Pay To Start',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
