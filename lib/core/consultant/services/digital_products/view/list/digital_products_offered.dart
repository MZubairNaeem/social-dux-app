import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/services/digital_products/view/edit/edit_digital_product_offered.dart';
import 'package:scp/core/consultant/services/digital_products/view_models/digital_products_offered_view_model.dart';
import 'package:scp/main.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class DigitalProductsOffered extends ConsumerWidget {
  const DigitalProductsOffered({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digitalProductsOfferedState =
        ref.watch(digitalProductsOfferedViewModelProvider);
    ref.listen<String?>(deleteDigitalProductsOfferedErrorMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
      }
    });

    ref.listen<String?>(deleteDigitalProductsOfferedSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, true);
        ref
            .read(deleteDigitalProductsOfferedSuccessMsgProvider.notifier)
            .state = null;
      }
    });

    return RefreshIndicator.adaptive(
      onRefresh: () {
        Future.microtask(() =>
            ref.read(digitalProductsOfferedViewModelProvider.notifier).list());

        return Future<void>.delayed(const Duration(seconds: 0));
      },
      child: Scaffold(
        body: digitalProductsOfferedState.when(
          data: (value) {
            if (value.isEmpty) {
              return Center(
                child: Text(
                  'No Digital Product Found',
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
                      Text(
                        value[index].description ?? '',
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
                                  '${value[index].price.toString()} \$',
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
                                  value[index].duration ?? '',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          //menu
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  try {
                                    // Parse the file path from the URL
                                    final filePath = value[index].file!;

                                    String updatedPath = filePath.replaceAll(
                                        'digital_products', '');
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
                                  } catch (e) {
                                    log('Error downloading file: $e');
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.book,
                                  color: accentColor,
                                  size: 16.sp,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(
                                          digitalProductsOfferedViewModelProvider
                                              .notifier)
                                      .delete(
                                        ref,
                                        value[index].id!,
                                        value[index].file!,
                                      );
                                },
                                icon: Icon(
                                  CupertinoIcons.bin_xmark,
                                  color: delete,
                                  size: 16.sp,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditDigitalProductOffered(
                                      serviceModel: value[index],
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  CupertinoIcons.pen,
                                  color: edit,
                                  size: 16.sp,
                                ),
                              ),
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
          loading: () =>
              const Center(child: CustomProgressIndicator(color: primaryColor)),
        ),
      ),
    );
  }
}


