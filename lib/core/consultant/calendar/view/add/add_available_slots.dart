import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/calendar/view_model/available_slots_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class AddAvailableSlots extends ConsumerStatefulWidget {
  const AddAvailableSlots({super.key});

  @override
  AddAvailableSlotsState createState() => AddAvailableSlotsState();
}

class AddAvailableSlotsState extends ConsumerState<AddAvailableSlots> {
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final duration = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final MultiSelectController<String> days = MultiSelectController<String>();

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String? selectedDay; // To store the selected weekday
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // Method to format time to a readable string
  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Tap to Select';
    final now = DateTime.now();
    final formattedTime = DateFormat.jm().format(
      DateTime(now.year, now.month, now.day, time.hour, time.minute),
    );
    return formattedTime;
  }

  // Method to show the time picker dialog
  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = selectedTime;
        } else {
          endTime = selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final slotState = ref.watch(availableSlotsViewModelProvider);
    ref.listen<String?>(createAvailableSlotErrorMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
        ref.read(createAvailableSlotErrorMsgProvider.notifier).state = null;
      }
    });

    ref.listen<String?>(createAvailableSlotSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        Navigator.of(context).pop();
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(createAvailableSlotSuccessMsgProvider.notifier).state = null;
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Add Availability Slot',
          icon: true,
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 3.h,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Coming Available Days',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  //outline textfield
                  MultiDropdown<String>(
                    items: weekdays
                        .map(
                          (e) => DropdownItem(
                            value: e.toString(),
                            label: e,
                          ),
                        )
                        .toList(),
                    controller: days,
                    enabled: true,
                    searchEnabled: true,
                    chipDecoration: ChipDecoration(
                      labelStyle: TextStyle(
                        color: textColor,
                        fontSize: 15.sp,
                      ),
                      backgroundColor: neutral200,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 10,
                    ),
                    fieldDecoration: FieldDecoration(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      hintText: 'Select Available Days',
                      hintStyle: const TextStyle(
                        color: neutral400,
                      ),
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                        borderSide: const BorderSide(
                          color: neutral600,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                        borderSide: const BorderSide(
                          color: neutral600,
                        ),
                      ),
                    ),
                    dropdownDecoration: const DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 500,
                      header: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Select Day',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: const Icon(
                        TablerIcons.check,
                        color: primaryColor,
                      ),
                      disabledIcon: Icon(
                        TablerIcons.lock,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a permission';
                      }
                      return null;
                    },
                    onSelectionChange: (selectedItems) {},
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Slot Start Time',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => selectTime(context, true),
                        child: Text(
                          formatTime(startTime),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Slot End Time',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => selectTime(context, false),
                        child: Text(
                          formatTime(endTime),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //price

                  SizedBox(height: 1.h),
                  //outline textfield
                  SizedBox(height: 3.h),
                  ElevatedButton(
                    onPressed: () {
                      final List<String> daysList = days.selectedItems
                          .map(
                            (e) => e.value,
                          )
                          .toList();
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (startTime == null) {
                        CustomSnackbar.showSnackbar(
                            context, 'Start Time is required!', false);
                        return;
                      }
                      if (endTime == null) {
                        CustomSnackbar.showSnackbar(
                            context, 'End Time is required!', false);
                        return;
                      }
                      DateTime dateTime = DateTime.now();
                      int hoursOffset = dateTime.timeZoneOffset.inHours;

                      // Convert TimeOfDay to DateTime
                      DateTime startDateTime = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        startTime!.hour,
                        startTime!.minute,
                      );

                      // Subtract the hours offset
                      DateTime updatedDateTime =
                          startDateTime.subtract(Duration(hours: hoursOffset));

                      // Convert back to TimeOfDay
                      TimeOfDay updatedTime = TimeOfDay(
                        hour: updatedDateTime.hour,
                        minute: updatedDateTime.minute,
                      );

                      DateTime endDateTime = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        endTime!.hour,
                        endTime!.minute,
                      );

                      // Subtract the hours offset
                      DateTime updatedEndDateTime =
                          endDateTime.subtract(Duration(hours: hoursOffset));

                      // Convert back to TimeOfDay
                      TimeOfDay updatedEndTime = TimeOfDay(
                        hour: updatedEndDateTime.hour,
                        minute: updatedEndDateTime.minute,
                      );

                      // DateTime dateTime = DateTime.now();
                      // int hours = dateTime.timeZoneOffset.inHours;
                      log(updatedTime.toString());
                      log(updatedEndTime.toString());
                      // startLocalDateTime =
                      //     startLocalDateTime.add(Duration(hours: hours));
                      ref.read(availableSlotsViewModelProvider.notifier).create(
                            daysList,
                            updatedTime,
                            updatedEndTime,
                            ref,
                          );
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateColor.resolveWith(
                        (states) => primaryColorDark,
                      ),
                      minimumSize: WidgetStateProperty.all(
                        Size(100.w, 5.h),
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
                    child: slotState is AsyncLoading
                        ? const CustomProgressIndicator(
                            color: white,
                          )
                        : Text(
                            'Add Slot',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
