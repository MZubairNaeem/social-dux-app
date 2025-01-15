import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/constant/path.dart';
import 'package:scp/core/auth/forgotPassword/view/forgot_password.dart';
import 'package:scp/core/auth/login/view_model/login_view_model.dart';
import 'package:scp/core/auth/onboarding/view/onboarding_page.dart';
import 'package:scp/core/auth/onboarding/view/onboarding_user_profile_page.dart';
import 'package:scp/core/auth/register/view/register_page.dart';
import 'package:scp/core/buyer/buyer_dashboard/view/buyer_dashboard_page.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    ref.listen<AsyncValue<AuthUserModel?>>(loginViewModelProvider,
        (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            CustomSnackbar.showSnackbar(context, 'Login Successful!', true);
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: ListView(
            children: [
              Image.asset(
                socialDuxLogo,
                height: 25.h,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CustomOutlineButton(
              //       text: 'Sign in with Google',
              //       icon: googleLogo,
              //       onPressed: () {},
              //     ),
              //     SizedBox(width: 10.sp),
              //     CustomOutlineButton(
              //       text: 'Sign in with FB',
              //       icon: fbLogo,
              //       onPressed: () {},
              //     ),
              //   ],
              // ),
              //horizontal line
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       margin: EdgeInsets.symmetric(vertical: 2.h),
              //       height: 0.1.h,
              //       width: 25.w,
              //       color: hintText.withOpacity(0.1),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 14.sp),
              //       child: Text(
              //         'or sign in with',
              //         style: TextStyle(
              //           color: textColor,
              //           fontSize: 16.sp,
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: EdgeInsets.symmetric(vertical: 2.h),
              //       height: 0.1.h,
              //       width: 25.w,
              //       color: hintText.withOpacity(0.1),
              //     ),
              //   ],
              // ),
              //email
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
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
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
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

                      SizedBox(height: 1.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
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
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.sp,
                            horizontal: 12.sp,
                            //add icon
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: hintText,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push( 
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          ),
                          style: ButtonStyle(
                            overlayColor: WidgetStateColor.resolveWith(
                              (states) => primaryColorLight,
                            ),
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text;
                            final password = passwordController.text;
                            ref
                                .read(loginViewModelProvider.notifier)
                                .login(email, password);
                          }
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
                        child: loginState is AsyncLoading
                            ? const CustomProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to Social Dux? ',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            ),
                            style: ButtonStyle(
                              overlayColor: WidgetStateColor.resolveWith(
                                (states) => primaryColorLight,
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
