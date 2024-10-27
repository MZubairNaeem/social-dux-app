import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InfoWidget extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color splashColor;
  final String heading;
  final String count;
  final String iconString;
  final Function() onPressed;
  const InfoWidget({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.splashColor,
    required this.onPressed,
    required this.heading,
    required this.count,
    required this.iconString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 1.w,
        vertical: 2.w,
      ),
      child: InkWell(
        splashColor: splashColor,
        onTap: onPressed,
        child: Container(
          width: 45.w,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            color: backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconString,
                  color: textColor,
                  width: 10.w,
                ),
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
