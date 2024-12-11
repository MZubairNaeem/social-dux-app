import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/bookings/view_models/buyer_bookings_view_model.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class DmServiceBooking extends ConsumerWidget {
  final ServiceModel service;
  const DmServiceBooking({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final formattedDate = DateFormat('d MMM, y').format(DateTime.now());
    var endTime = DateFormat('d MMM, y').format(
        DateTime.now().add(Duration(days: int.parse(service.duration!))));
    final jazz = TextEditingController();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'One Last Step',
          icon: true,
        ),
      ),
      body: Form(
        child: ListView(
          children: [
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Your are purchasing \'${service.title}\' by \'${service.users!.name}\' ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Start Date: $formattedDate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'End Date: $endTime',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            //outline textfield
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              child: TextFormField(
                controller: jazz,
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
                onPressed: () async {
                  if (jazz.text.isEmpty) {
                    CustomSnackbar.showSnackbar(
                        context, 'Please Enter Number for payment', true);
                    return;
                  }
                  ref.read(buyerBookingsViewModelProvider.notifier).create(
                        endTime,
                        ref,
                        service.id!,
                        null,
                      );
                  await supabase.from('chat_rooms').insert({
                    'last_message': 'Say Hi!',
                    'buyer_id': supabase.auth.currentUser!.id,
                    'consultant_id': service.users!.id,
                  });
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
            )
          ],
        ),
      ),
    );
  }
}
