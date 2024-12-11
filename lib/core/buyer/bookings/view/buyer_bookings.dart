import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/bookings/view_models/buyer_bookings_view_model.dart';
import 'package:scp/core/buyer/buyer_dashboard/providers/user_provider.dart';
import 'package:scp/core/buyer/testemonials/view/give_testemonials.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class BuyerBookings extends ConsumerWidget {
  const BuyerBookings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorityDMService = ref.watch(buyerBookingsViewModelProvider);
    final userState = ref.watch(userProvider(supabase.auth.currentUser!.id));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Services Purchased',
          icon: true,
        ),
      ),
      body: priorityDMService.when(
        data: (value) {
          if (value.isEmpty) {
            return Center(
              child: Text(
                'No Service Purchased Yet!',
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
              final dateTime = DateTime.parse(value[index].startTime);
              var endTime = '';

              if (value[index].endTime != null) {
                final endDateTime = DateTime.parse(value[index].endTime!);

                endTime = DateFormat('d MMM, y').format(endDateTime);
              }

              // Format the DateTime object
              final startTime = DateFormat('d MMM, y').format(dateTime);
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
                          value[index].serviceId!.title,
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
                      value[index].serviceId!.description ?? '',
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
                                    '${value[index].serviceId!.price.toString()} \$',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    value[index].serviceId!.duration ?? '',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Column(
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
                                    'Start Time $startTime',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                if (endTime != '')
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 2.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.w)),
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'End Time $endTime',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (value[index].serviceId!.serviceType ==
                            ServiceType.digitalProduct)
                          IconButton(
                            onPressed: () async {
                              try {
                                // Parse the file path from the URL
                                final filePath = value[index].serviceId!.file!;

                                String updatedPath =
                                    filePath.replaceAll('digital_products', '');
                                log(updatedPath);

                                // Download file from Supabase storage
                                final Uint8List fileBytes = await supabase
                                    .storage
                                    .from(
                                        'digital_products') // Replace 'your_bucket_name' with your actual bucket name
                                    .download(updatedPath);

                                // Get the local storage path
                                final directory =
                                    await getApplicationDocumentsDirectory();
                                final localPath =
                                    '${directory.path}/${filePath.split('/').last}';

                                // Save the file locally
                                final file = File(localPath);
                                await file.writeAsBytes(fileBytes);

                                log('File downloaded to: $localPath');
                                CustomSnackbar.showSnackbar(context,
                                    'File downloaded to: $localPath', true);
                                OpenDocument.openDocument(
                                  filePath: localPath,
                                );
                              } catch (e) {
                                log('Error downloading file: $e');
                              }
                            },
                            icon: Icon(
                              TablerIcons.download,
                              color: primaryColor,
                              size: 18.sp,
                            ),
                          ),
                        if ('ServiceType.oneToOneSession' ==
                            value[index].serviceId!.serviceType.toString())
                          userState.when(
                            data: (val) {
                              return TextButton(
                                onPressed: () async => await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CallPage(
                                        bookingId: value[index].id!,
                                        username: val.name),
                                  ),
                                ),
                                child: Text(
                                  'Start Meeting',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                              );
                            },
                            error: (error, stackTrace) => Text('Error: $error'),
                            loading: () => const CupertinoActivityIndicator(
                              color: primaryColor,
                            ),
                          ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GiveTestemonials(
                                booking: value[index],
                              ),
                            ),
                          ),
                          child: Text(
                            'Give Testimonial',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
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

class CallPage extends StatelessWidget {
  final String bookingId;
  final String username;
  const CallPage({super.key, required this.bookingId, required this.username});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          1474611744, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          'd2e1807c62e94f7d2dcea08cde7d5da2bbaac970b78eb29894c07e5a448c1f2c', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: supabase.auth.currentUser!.id,
      userName: username,
      callID: bookingId,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
