import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color color;
  const CustomProgressIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.sp,
      width: 20.sp,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  color.withOpacity(0.1), // Adjust opacity for the glow effect
              spreadRadius: 4,
              blurRadius: 1,
            ),
          ],
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 6.sp,
          color: color,
          backgroundColor: color.withOpacity(0.2),
        ),
      ),
    );
  }
}

/// Simple preloader inside a Center widget
const preloader = Center(child: CustomProgressIndicator(color: primaryColor));
