import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';

class PrimaryAppBar extends StatelessWidget {
  final String title;
  final bool icon;
  final Function()? onPressed;
  const PrimaryAppBar(
      {super.key, required this.title, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      leading: icon
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.back,
                color: white,
              ),
            )
          : IconButton(
              onPressed: () {
                onPressed!();
              },
              icon: const Icon(
                CupertinoIcons.bars,
                color: white,
              ),
            ),
      title: Text(
        title,
        style: TextStyle(
          color: white,
          fontSize: 16.sp,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 1,
      centerTitle: true,
    );
  }
}
