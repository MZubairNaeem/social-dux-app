import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/testimonials/view_model/testimonials_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class Testimonials extends ConsumerWidget {
  const Testimonials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonialsState = ref.watch(testimonialsViewModelProvider);
    ref.listen<String?>(deleteTestimonialErrorMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
        ref.read(deleteTestimonialErrorMsgProvider.notifier).state = null;
      }
    });

    ref.listen<String?>(deleteTestimonialSuccessMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(deleteTestimonialSuccessMsgProvider.notifier).state = null;
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Testimonials ❤',
          icon: true,
        ),
      ),
      body: testimonialsState.when(
        data: (value) {
          if (value.isEmpty) {
            return Center(
              child: Text(
                'No testimonial has been given to you. :(',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
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
                  children: [
                    Row(
                      children: [
                        Text(
                          '💬',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        value[index].review ?? "",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textColor,
                          wordSpacing: 0.1,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    if (value[index].rating != null)
                      Row(
                        children: [
                          for (var i = 0; i < value[index].rating!; i++)
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16.sp,
                            ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (value[index].userId != null)
                              Text(
                                value[index].userId!.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            SizedBox(
                              width: 1.w,
                            ),
                            if (value[index].serviceId != null)
                              Text(
                                "(${value[index].serviceId!.title})",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: textColor,
                                ),
                              ),
                          ],
                        ),
                        //menu
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(testimonialsViewModelProvider.notifier)
                                .delete(
                                  ref,
                                  value[index].id!,
                                );
                          },
                          icon: Icon(
                            CupertinoIcons.delete,
                            color: textColor,
                            size: 16.sp,
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
        loading: () => const Center(
          child: CustomProgressIndicator(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
