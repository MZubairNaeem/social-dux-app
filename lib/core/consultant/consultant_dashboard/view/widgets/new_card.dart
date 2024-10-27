import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 2.w,
        vertical: 1.h,
      ),
      child: InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          color: primaryColor,
          child: Column(
            children: [
              Image.asset(
                'lib/assets/logo/social_dux_logo.png',
                width: 100.w,
                height: 20.h,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(2.w),
                child: Column(
                  children: [
                    Text(
                      'News Title',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'News Description',
                      style: TextStyle(
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
