import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/services/one_to_sessions/provider/available_slot_by_id.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view_models/one_to_one_session_view_model.dart';
import 'package:scp/main.dart';
import 'package:scp/model/service_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class AddOneToOneSession extends ConsumerStatefulWidget {
  const AddOneToOneSession({super.key});

  @override
  AddOneToOneSessionState createState() => AddOneToOneSessionState();
}

class AddOneToOneSessionState extends ConsumerState<AddOneToOneSession> {
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final duration = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final MultiSelectController<String> slots = MultiSelectController<String>();
  String? selectedSlot;
  final List<String> medTypes = []; // Medication types

  @override
  Widget build(BuildContext context) {
    final oneToOneSessionState = ref.watch(oneToOneSessionViewModelProvider);
    final slot = ref.watch(availableSlotById(supabase.auth.currentUser!.id));
    ref.listen<String?>(createoneToOneSessionErrorMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
      }
    });

    ref.listen<String?>(createoneToOneSessionSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        Navigator.of(context).pop();
        CustomSnackbar.showSnackbar(context, next, true);
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Add One to One Session Service',
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
                      'Title',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  //outline textfield
                  TextFormField(
                    controller: title,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
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
                  SizedBox(height: 2.h),
                  //description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  //outline textfield
                  TextFormField(
                    controller: description,
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
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
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Slot',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  slot.when(
                    data: (val) {
                      return DropdownButtonFormField<String>(
                        value: val.isNotEmpty
                            ? val.first.id.toString()
                            : 'No available slots', // Set initial value as the ID
                        items: val.map<DropdownMenuItem<String>>((slot) {
                          final displayValue =
                              '${slot.startTime} - ${slot.endTime}\n${slot.availableDays.map((day) => day.day.toString()).join(", ")}';
                          return DropdownMenuItem<String>(
                            value: slot.id.toString(), // Use ID as the value
                            child: Text(
                              displayValue, // Display time and days
                              style: const TextStyle(
                                  fontSize: 14), // Optional styling
                            ),
                          );
                        }).toList(),
                        onChanged: val.isNotEmpty
                            ? (String? newValue) {
                                selectedSlot =
                                    newValue!; // Update the selected slot with the ID
                              }
                            : null, // Disable onChanged if val is empty
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        hint: const Text('Select Slot'),
                      );
                    },
                    error: (e, st) => Text(e.toString()),
                    loading: () => const Text('Loading...'),
                  ),
                  SizedBox(height: 2.h),
                  //price
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Price (Pkr)',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  //outline textfield
                  TextFormField(
                    controller: price,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Price cannot be empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter price in Pkr',
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

                  SizedBox(height: 3.h),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      ref
                          .read(oneToOneSessionViewModelProvider.notifier)
                          .create(
                            ServiceModel(
                              title: title.text.trim(),
                              description: description.text.trim(),
                              price: int.parse(price.text.trim()),
                              duration: duration.text.trim(),
                              serviceType: ServiceType.oneToOneSession,
                            ),
                            ref,
                            selectedSlot!,
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
                    child: oneToOneSessionState is AsyncLoading
                        ? const CustomProgressIndicator(
                            color: white,
                          )
                        : Text(
                            'Create Service',
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
