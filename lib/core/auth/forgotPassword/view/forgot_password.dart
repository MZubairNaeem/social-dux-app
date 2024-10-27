import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/constant/path.dart';
import 'package:scp/theme/colors/colors.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
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
              //horizontal line
              //email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Please enter the email address associated with your account and We will email you a link to reset your password.',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 2.h),
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
                      ),
                      cursorColor: primaryColorDark,
                    ),
                    SizedBox(height: 4.h),
                    //outline textfield

                    ElevatedButton(
                      onPressed: () {},
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
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        overlayColor: WidgetStateColor.resolveWith(
                          (states) => primaryColor,
                        ),
                        minimumSize: WidgetStateProperty.all(
                          Size(100.w, 5.h),
                        ),
                        backgroundColor: WidgetStateColor.resolveWith(
                          (states) => primaryColorLight,
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
                        'Back to Login',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
