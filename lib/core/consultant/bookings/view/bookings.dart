import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Bookings 😍',
          icon: true,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 1.w,
          ),
          SizedBox(
            width: double.infinity,
            child: TabBar(
              dividerColor: white,
              automaticIndicatorColorAdjustment: false,
              isScrollable: true,
              indicatorColor: primaryColorDark,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      _tabController.animateTo(0);
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    margin: EdgeInsets.symmetric(vertical: 1.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: _selectedIndex == 0 ? 1.5 : 1,
                        //if the tab is selected, the border color will be primaryColor, else white.
                        color: _selectedIndex == 0
                            ? primaryColor
                            : textColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Center(
                      child: Text(
                        '1:1 Sessions',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _tabController.animateTo(1);
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    margin: EdgeInsets.symmetric(vertical: 1.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: _selectedIndex == 1 ? 1.5 : 1,
                        //if the tab is selected, the border color will be primaryColor, else white.
                        color: _selectedIndex == 1
                            ? primaryColor
                            : textColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Center(
                      child: Text(
                        'Priority DMs',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                      _tabController.animateTo(2);
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    margin: EdgeInsets.symmetric(vertical: 1.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: _selectedIndex == 2 ? 1.5 : 1,
                        //if the tab is selected, the border color will be primaryColor, else white.
                        color: _selectedIndex == 2
                            ? primaryColor
                            : textColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Center(
                      child: Text(
                        'Digital Products',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                      _tabController.animateTo(3);
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    margin: EdgeInsets.symmetric(vertical: 1.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: _selectedIndex == 3 ? 1.5 : 1,
                        //if the tab is selected, the border color will be primaryColor, else white.
                        color: _selectedIndex == 3
                            ? primaryColor
                            : textColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Center(
                      child: Text(
                        'Packages',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                OneToOneSessionBookings(),
                OneToOneSessionBookings(),
                OneToOneSessionBookings(),
                OneToOneSessionBookings(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OneToOneSessionBookings extends StatefulWidget {
  const OneToOneSessionBookings({super.key});

  @override
  State<OneToOneSessionBookings> createState() =>
      _OneToOneSessionBookingsState();
}

class _OneToOneSessionBookingsState extends State<OneToOneSessionBookings> {
  //get current time
  final DateTime now = DateTime.now();
  //after 10 minutes
  final DateTime afterTenMinutes =
      DateTime.now().add(const Duration(minutes: 10));
  //after 20 minutes
  final DateTime afterTwentyMinutes =
      DateTime.now().add(const Duration(minutes: 20));
  //after 30 minutes
  final DateTime afterThirtyMinutes =
      DateTime.now().add(const Duration(minutes: 30));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 4.h,
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '${now.hour}:${now.minute}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      '${afterTenMinutes.hour}:${afterTenMinutes.minute}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      '${afterTwentyMinutes.hour}:${afterTwentyMinutes.minute}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      '${afterThirtyMinutes.hour}:${afterThirtyMinutes.minute}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.h,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Container(
                        color: primaryColor,
                        height: 5.h,
                        width: 1,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.h,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Container(
                        color: primaryColor,
                        height: 5.h,
                        width: 1,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.h,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Container(
                        color: primaryColor,
                        height: 5.h,
                        width: 1,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.h,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  children: [
                    Text(
                      'Session 1',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Session 2',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Session 3',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Session 4',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
