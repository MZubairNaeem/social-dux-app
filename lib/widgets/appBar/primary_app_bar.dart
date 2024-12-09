import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';

class PrimaryAppBar extends StatelessWidget {
  final String title;
  final bool icon;
  final Function()? onPressed;
  final Color color;
  final Color itemColor;
  const PrimaryAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.color = primaryColor,
    this.itemColor = white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      leading: icon
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                CupertinoIcons.back,
                color: itemColor,
              ),
            )
          : IconButton(
              onPressed: () {
                onPressed!();
              },
              icon: Icon(
                CupertinoIcons.bars,
                color: itemColor,
              ),
            ),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
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
