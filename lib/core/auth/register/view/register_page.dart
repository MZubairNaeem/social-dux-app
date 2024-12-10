import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/constant/path.dart';
import 'package:scp/constant/regex.dart';
import 'package:scp/core/auth/login/view/login_page.dart';
import 'package:scp/core/auth/register/view_model/register_view_model.dart';
import 'package:scp/model/auth_user_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerViewModelProvider);
    ref.listen<AsyncValue<AuthUserModel?>>(registerViewModelProvider,
        (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            CustomSnackbar.showSnackbar(
                context, 'Verification email sent to ${user.email}', true);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
              (route) => false,
            );
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
                          'Name',
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
                        controller: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
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
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
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
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
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
                      SizedBox(height: 1.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password',
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
                        controller: confirmPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Confirm Password cannot be empty';
                          }
                          if (value != password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.sp,
                            horizontal: 12.sp,
                            //add icon
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
                      SizedBox(height: 4.h),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(registerViewModelProvider.notifier)
                                .regitser(
                                  name.text.trim(),
                                  email.text.trim(),
                                  password.text.trim(),
                                );
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
                        child: registerState is AsyncLoading
                            ? const CustomProgressIndicator(
                                color: white,
                              )
                            : Text(
                                'Register',
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
                            'Already have an Account? ',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ButtonStyle(
                              overlayColor: WidgetStateColor.resolveWith(
                                (states) => primaryColorLight,
                              ),
                            ),
                            child: Text(
                              'Sign In',
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
