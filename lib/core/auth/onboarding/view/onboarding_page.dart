import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/auth/login/view/login_page.dart';
import 'package:scp/core/auth/onboarding/view/onboarding_user_profile_page.dart';
import 'package:scp/core/auth/onboarding/view_models/onboarding_view_model.dart';
import 'package:scp/core/buyer/buyer_dashboard/view/buyer_dashboard_page.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleSelectedState = ref.watch(roleSelectViewModelProvider);
    ref.listen<AsyncValue<AuthUserModel?>>(roleSelectViewModelProvider,
        (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            CustomSnackbar.showSnackbar(
                context, 'Role Selected Successful!', true);
            if (user.onboardingStep == OnboardingSteps.registered) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OnboardingPage(),
                ),
              );
            } else if (user.onboardingStep == OnboardingSteps.roleSelected) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OnboardingUserProfilePage(),
                ),
              );
            } else if (user.onboardingStep == OnboardingSteps.completed) {
              if (user.role!.name == 'BUYER') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BuyerDashboardPage(),
                  ),
                );
              } else if (user.role!.name == 'CONSULTANT') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BuyerDashboardPage(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              }
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            }
          }
        },
        loading: () {},
        error: (error, _) {
          CustomSnackbar.showSnackbar(context, error.toString(), false);
        },
      );
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose!',
              style: TextStyle(
                color: textColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                //italic: true,
                fontStyle: FontStyle.italic,
              ),
            ),
            //what you want to be
            Text(
              'what you want to be',
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5.h),
            roleSelectedState is AsyncLoading
                ? const CustomProgressIndicator(
                    color: primaryColor,
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(roleSelectViewModelProvider.notifier)
                              .roleSelect(
                                true,
                              );
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
                        child: Text(
                          'Continue as Buyer',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(roleSelectViewModelProvider.notifier)
                              .roleSelect(
                                false,
                              );
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
                        child: Text(
                          'Continue as Consultant',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
