import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/calendar/view/add/add_available_slots.dart';
import 'package:scp/core/consultant/calendar/view_model/available_slots_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends ConsumerState<Calendar> {
  bool zoomValue = false;
  bool meetMalue = false;
  bool linkValue = false;
  @override
  Widget build(BuildContext context) {
    final availableSlotState = ref.watch(availableSlotsViewModelProvider);
    ref.listen<String?>(deleteAvailableSlotErrorMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
      }
    });

    ref.listen<String?>(deleteAvailableSlotSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(deleteAvailableSlotSuccessMsgProvider.notifier).state = null;
      }
    });

    ref.listen<String?>(changeAvailableSlotStatusErrorMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
        ref.read(changeAvailableSlotStatusErrorMsgProvider.notifier).state =
            null;
      }
    });

    ref.listen<String?>(changeAvailableSlotStatusSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(changeAvailableSlotStatusSuccessMsgProvider.notifier).state =
            null;
      }
    });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Calendar 📆',
          icon: true,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Available Slots',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                availableSlotState.when(
                  data: (value) {
                    if (value.isEmpty) {
                      return Center(
                        child: Text(
                          'No Slot Added Yet',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
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
                                    '${value[index].startTime} - ${value[index].endTime}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              for (var day in value[index].availableDays)
                                Text(
                                  '- ${day.day}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: textColor,
                                    wordSpacing: 0.1,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // IconButton(
                                  //   splashColor: primaryColor,
                                  //   onPressed: () async {
                                  //     await ref
                                  //         .read(availableSlotsViewModelProvider
                                  //             .notifier)
                                  //         .statusChange(
                                  //           !value[index].status,
                                  //           value[index].id!,
                                  //           ref,
                                  //         );
                                  //   },
                                  //   icon: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: [
                                  //       Icon(
                                  //         value[index].status
                                  //             ? CupertinoIcons.eye
                                  //             : CupertinoIcons.eye_slash_fill,
                                  //         color: textColor,
                                  //         size: 16.sp,
                                  //       ),
                                  //       SizedBox(width: 2.w),
                                  //       Text(
                                  //         value[index].status
                                  //             ? 'Active'
                                  //             : 'Inactive',
                                  //         style: TextStyle(
                                  //           fontSize: 15.sp,
                                  //           color: textColor,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  const Spacer(),
                                  //menu
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await ref
                                              .read(
                                                  availableSlotsViewModelProvider
                                                      .notifier)
                                              .delete(
                                                ref,
                                                value[index].id!,
                                              );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.bin_xmark,
                                          color: delete,
                                          size: 16.sp,
                                        ),
                                      ),
                                      // IconButton(
                                      //   onPressed: () {},
                                      //   icon: Icon(
                                      //     CupertinoIcons.pen,
                                      //     color: edit,
                                      //     size: 16.sp,
                                      //   ),
                                      // ),
                                    ],
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
                  loading: () => const Center(
                      child: CustomProgressIndicator(color: primaryColor)),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time Zone',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Karachi (GMT+5)',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reschedule Policy',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Update Policy',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Period',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        '2 months',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notice Period',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        '240 Minutes',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meeting Location',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/icons/zoom.png',
                  width: 7.w,
                  height: 7.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zoom Meeting',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //toogle button
                Switch.adaptive(
                  // thumb color (round icon)
                  activeColor: white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: white,
                  inactiveTrackColor: Colors.grey,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: zoomValue,
                  // changes the state of the switch
                  onChanged: (bool v) {
                    setState(() {
                      // update the state variable value
                      zoomValue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          //horizontal line
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: Container(
              height: 0.1.h,
              color: hintText.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/icons/meet.png',
                  width: 7.w,
                  height: 7.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google Meet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //toogle button
                Switch.adaptive(
                  // thumb color (round icon)
                  activeColor: white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: white,
                  inactiveTrackColor: Colors.grey,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: meetMalue,
                  // changes the state of the switch
                  onChanged: (bool v) {
                    setState(() {
                      // update the state variable value
                      meetMalue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: Container(
              height: 0.1.h,
              color: hintText.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.link,
                  color: textColor,
                  size: 7.w,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'InApp Meeting',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //toogle button
                Switch.adaptive(
                  // thumb color (round icon)
                  activeColor: white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: white,
                  inactiveTrackColor: Colors.grey,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: linkValue,
                  // changes the state of the switch
                  onChanged: (bool v) {
                    setState(() {
                      // update the state variable value
                      linkValue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: Container(
              height: 0.1.h,
              color: hintText.withOpacity(0.2),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddAvailableSlots(),
          ),
        ),
        icon: Icon(
          TablerIcons.calendar,
          color: white,
          size: 5.w,
        ),
        label: const Text(
          'Add Available Slots',
          style: TextStyle(
            color: white,
          ),
        ),
      ),
    );
  }
}
