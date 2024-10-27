import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view/edit/edit_one_to_one_session.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view_models/one_to_one_session_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class OneToOneSessions extends ConsumerWidget {
  const OneToOneSessions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oneToOneSessions = ref.watch(oneToOneSessionViewModelProvider);
    ref.listen<String?>(deleteoneToOneSessionErrorMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
      }
    });

    ref.listen<String?>(deleteoneToOneSessionSuccessMsgProvider,
        (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(deleteoneToOneSessionSuccessMsgProvider.notifier).state = null;
      }
    });

    return Scaffold(
      body: oneToOneSessions.when(
        data: (value) {
          if (value.isEmpty) {
            return Center(
              child: Text(
                'No One To One Session Service Found',
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
                                '${value[index].price.toString()} Pkr',
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.eye,
                              color: textColor,
                              size: 16.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Public',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        //menu
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await ref
                                    .read(oneToOneSessionViewModelProvider
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
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditOneToOneSession(
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
    );
  }
}
