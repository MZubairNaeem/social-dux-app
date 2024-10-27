import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view_models/one_to_one_session_view_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final oneToOneSessionState = ref.watch(oneToOneSessionViewModelProvider);
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
                  //price
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Duration (mins)',
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
                    controller: duration,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Duration cannot be empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter duration in mins',
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
