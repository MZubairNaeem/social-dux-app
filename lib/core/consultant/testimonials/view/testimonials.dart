import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';

class Testimonials extends StatelessWidget {
  const Testimonials({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Testimonials ❤',
          icon: true,
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: hintText.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '💬',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'I had the privilege of engaging in discussions with you regarding the review of my resume and career guidance. I am immensely grateful for the insightful advice and valuable feedback provided. you demonstrated a deep understanding of the industry and offered constructive suggestions to enhance my resume. The guidance on career strategies was instrumental in shaping my professional path. I highly recommend you for their expertise, professionalism, and genuine commitment to supporting individuals in their career endeavors. The personalized attention and thoughtful insights have proven invaluable, and I am confident that others seeking career guidance will benefit greatly from Waleed expertise. Thank you once again for the invaluable assistance.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: textColor,
                    wordSpacing: 0.1,
                    letterSpacing: 0.1,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Syed Aneeb Ali',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          '(Resume review)',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    //menu
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: textColor,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: hintText.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '💬',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'I had such a great time having a conversation with Waleed, he\'s an expert in his field and the advice he provides is precise and to the point, helping resolve the exact issue and in synergy he clarifies all the misconceptions and pertinent concerns. I highly recommend scheduling a session with him.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: textColor,
                    wordSpacing: 0.1,
                    letterSpacing: 0.1,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Qaim',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          '(Career Guidance)',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    //menu
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: textColor,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: hintText.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '💬',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'I liked getting a good, clearer perspective. The session was helpful and I received good insights into my queries and concerns. Thank you for your time!',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: textColor,
                    wordSpacing: 0.1,
                    letterSpacing: 0.1,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Meerab',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          '(1 : 1 Session)',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    //menu
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: textColor,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
