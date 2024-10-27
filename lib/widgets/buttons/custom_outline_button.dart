import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;
  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateColor.resolveWith(
          (states) => primaryColorLight,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(white),
        side: WidgetStateProperty.all(
          BorderSide(
            color: hintText,
            width: 2.sp,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 16.sp,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
