import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/services/digital_products/view_models/digital_products_offered_view_model.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view_models/one_to_one_session_view_model.dart';
import 'package:scp/core/consultant/services/priority_dm/view_models/priority_dm_service_view_model.dart';
import 'package:scp/core/consultant/services/service_packages/view_models/service_packages_view_model.dart';
import 'package:scp/model/service_model.dart';
import 'package:scp/model/service_package_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class AddServicePackages extends ConsumerStatefulWidget {
  const AddServicePackages({super.key});

  @override
  AddServicePackagesState createState() => AddServicePackagesState();
}

class AddServicePackagesState extends ConsumerState<AddServicePackages> {
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final duration = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final oneToOneSessionTitleController = TextEditingController();
  final oneToOneSessionIdController = TextEditingController();

  final priorityDMServiceController = TextEditingController();
  final priorityDMServiceIdController = TextEditingController();

  final digitalProductController = TextEditingController();
  final digitalProductIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final servicePackagesState = ref.watch(servicePackagesViewModelProvider);
    ref.listen<String?>(createServicePackagesErrorMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
      }
    });

    ref.listen<String?>(createServicePackagesSuccessMsgProvider,
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
          title: 'Add Service Package',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'One To One Session',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),
                  Consumer(
                    builder: (context, ref, _) {
                      final oneToOneSession =
                          ref.watch(oneToOneSessionViewModelProvider);
                      return oneToOneSession.when(
                        data: (oneToOneSession) {
                          if (oneToOneSession.isEmpty) {
                            return const Text(
                                'No one To One Session available');
                          }
                          return Container(
                            width: 90.w,
                            height: 5.5.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: neutral400,
                              ),
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: DropdownButton<ServiceModel>(
                              dropdownColor: white,
                              isDense: true,
                              icon: Icon(
                                TablerIcons.caret_down,
                                color: neutral600,
                                size: 20.sp,
                              ),
                              hint: const Text('Select an One To One Session'),
                              value: oneToOneSessionTitleController.text.isEmpty
                                  ? null
                                  : oneToOneSession.firstWhere(
                                      (oneToOneSessionName) =>
                                          oneToOneSessionName.title ==
                                          oneToOneSessionTitleController.text),
                              underline: Container(),
                              items: oneToOneSession.map((island) {
                                return DropdownMenuItem<ServiceModel>(
                                  value: island,
                                  child: Text(
                                    island.title,
                                  ),
                                );
                              }).toList(),
                              onChanged: (ServiceModel? selectedIsland) {
                                setState(() {
                                  oneToOneSessionTitleController.text =
                                      selectedIsland!.title;
                                  oneToOneSessionIdController.text =
                                      selectedIsland.id.toString();
                                });
                              },
                            ),
                          );
                        },
                        loading: () => const CupertinoActivityIndicator(
                          color: primaryColor,
                        ),
                        error: (error, stackTrace) => Text('Error: $error'),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Priority DM Service',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),
                  Consumer(
                    builder: (context, ref, _) {
                      final oneToOneSession =
                          ref.watch(priorityDmServiceViewModelProvider);
                      return oneToOneSession.when(
                        data: (oneToOneSession) {
                          if (oneToOneSession.isEmpty) {
                            return const Text(
                                'No Priority DM Service available');
                          }
                          return Container(
                            width: 90.w,
                            height: 5.5.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: neutral400,
                              ),
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: DropdownButton<ServiceModel>(
                              dropdownColor: white,
                              isDense: true,
                              icon: Icon(
                                TablerIcons.caret_down,
                                color: neutral600,
                                size: 20.sp,
                              ),
                              hint: const Text('Select a Priority DM Service'),
                              value: priorityDMServiceController.text.isEmpty
                                  ? null
                                  : oneToOneSession.firstWhere(
                                      (oneToOneSessionName) =>
                                          oneToOneSessionName.title ==
                                          priorityDMServiceController.text),
                              underline: Container(),
                              items: oneToOneSession.map((island) {
                                return DropdownMenuItem<ServiceModel>(
                                  value: island,
                                  child: Text(
                                    island.title,
                                  ),
                                );
                              }).toList(),
                              onChanged: (ServiceModel? selectedIsland) {
                                setState(() {
                                  priorityDMServiceController.text =
                                      selectedIsland!.title;
                                  priorityDMServiceIdController.text =
                                      selectedIsland.id.toString();
                                });
                              },
                            ),
                          );
                        },
                        loading: () => const CupertinoActivityIndicator(
                          color: primaryColor,
                        ),
                        error: (error, stackTrace) => Text('Error: $error'),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Digital Product',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),
                  Consumer(
                    builder: (context, ref, _) {
                      final oneToOneSession =
                          ref.watch(digitalProductsOfferedViewModelProvider);
                      return oneToOneSession.when(
                        data: (oneToOneSession) {
                          if (oneToOneSession.isEmpty) {
                            return const Text('No Digital Product available');
                          }
                          return Container(
                            width: 90.w,
                            height: 5.5.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: neutral400,
                              ),
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: DropdownButton<ServiceModel>(
                              dropdownColor: white,
                              isDense: true,
                              icon: Icon(
                                TablerIcons.caret_down,
                                color: neutral600,
                                size: 20.sp,
                              ),
                              hint: const Text('Select a Digital Product'),
                              value: digitalProductController.text.isEmpty
                                  ? null
                                  : oneToOneSession.firstWhere(
                                      (oneToOneSessionName) =>
                                          oneToOneSessionName.title ==
                                          digitalProductController.text),
                              underline: Container(),
                              items: oneToOneSession.map((island) {
                                return DropdownMenuItem<ServiceModel>(
                                  value: island,
                                  child: Text(
                                    island.title,
                                  ),
                                );
                              }).toList(),
                              onChanged: (ServiceModel? selectedIsland) {
                                setState(() {
                                  digitalProductController.text =
                                      selectedIsland!.title;
                                  digitalProductIdController.text =
                                      selectedIsland.id.toString();
                                });
                              },
                            ),
                          );
                        },
                        loading: () => const CupertinoActivityIndicator(
                          color: primaryColor,
                        ),
                        error: (error, stackTrace) => Text('Error: $error'),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  //price
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Price (\$)',
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
                      hintText: 'Enter price in \$',
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
                      if (oneToOneSessionTitleController.text.isEmpty) {
                        CustomSnackbar.showSnackbar(
                            context, 'Select One to one Session', false,
                            duration: 1);
                        return;
                      }
                      if (priorityDMServiceController.text.isEmpty) {
                        CustomSnackbar.showSnackbar(
                            context, 'Select  Priority DM Service', false,
                            duration: 1);
                        return;
                      }

                      if (digitalProductController.text.isEmpty) {
                        CustomSnackbar.showSnackbar(
                            context, 'Select a Digital Product', false,
                            duration: 1);
                        return;
                      }

                      ref
                          .read(servicePackagesViewModelProvider.notifier)
                          .create(
                            ServicePackageModel(
                              title: title.text.trim(),
                              price: int.parse(price.text.trim()),
                              oneToOneSessionServiceid:
                                  oneToOneSessionIdController.text,
                              priorityDmServiceid:
                                  priorityDMServiceIdController.text,
                              digitalProductServiceid:
                                  digitalProductIdController.text,
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
                    child: servicePackagesState is AsyncLoading
                        ? const CustomProgressIndicator(
                            color: white,
                          )
                        : Text(
                            'Create Package',
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
