import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool zoomValue = false;
  bool meetMalue = false;
  bool linkValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Calendar 📆',
          icon: true,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time Zone',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Karachi (GMT+5)',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reschedule Policy',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Update Policy',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Period',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        '2 months',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notice Period',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        '240 Minutes',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meeting Location',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Amet, exercitationem dolor sit amet consectetur adipisicing elit. Amet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/icons/zoom.png',
                  width: 7.w,
                  height: 7.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zoom Meeting',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //toogle button
                Switch.adaptive(
                  // thumb color (round icon)
                  activeColor: white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: white,
                  inactiveTrackColor: Colors.grey,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: zoomValue,
                  // changes the state of the switch
                  onChanged: (bool v) {
                    setState(() {
                      // update the state variable value
                      zoomValue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          //horizontal line
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: Container(
              height: 0.1.h,
              color: hintText.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            child: Row(
              children: [
                Image.asset(
                  'lib/assets/icons/meet.png',
                  width: 7.w,
                  height: 7.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google Meet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //toogle button
                Switch.adaptive(
                  // thumb color (round icon)
                  activeColor: white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: white,
                  inactiveTrackColor: Colors.grey,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: meetMalue,
                  // changes the state of the switch
                  onChanged: (bool v) {
                    setState(() {
                      // update the state variable value
                      meetMalue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: Container(
              height: 0.1.h,
              color: hintText.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.link,
                  color: textColor,
                  size: 7.w,
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'InApp Meeting',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //toogle button
                Switch.adaptive(
                  // thumb color (round icon)
                  activeColor: white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: white,
                  inactiveTrackColor: Colors.grey,
                  splashRadius: 50.0,
                  // boolean variable value
                  value: linkValue,
                  // changes the state of the switch
                  onChanged: (bool v) {
                    setState(() {
                      // update the state variable value
                      linkValue = v;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: Container(
              height: 0.1.h,
              color: hintText.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calendars',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lorem ipsum, dolor sit amet consectetur adipisicing elit.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    overlayColor: WidgetStateColor.resolveWith(
                      (states) => primaryColorDark,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Calendar Account',
                        style: TextStyle(
                          color: white,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.add,
                        color: white,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
