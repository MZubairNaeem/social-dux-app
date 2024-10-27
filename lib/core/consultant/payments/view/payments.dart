import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      backgroundColor: scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Payments 💵',
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
                        'Summary',
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
                        'Transactions',
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
                Summary(),
                Transactions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
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
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.h,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                  vertical: 1.w,
                ),
                decoration: BoxDecoration(
                  color: primaryColorDark.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'lib/assets/icons/paypal.png',
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                children: [
                  Text(
                    'Paypal Transfer',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Money added',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    '+\$6,581',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                  vertical: 1.w,
                ),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'lib/assets/icons/officebag.png',
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                children: [
                  Text(
                    'Wallet',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bill Payment',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    '+\$6,581',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                  vertical: 1.w,
                ),
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'lib/assets/icons/mastercard.png',
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                children: [
                  Text(
                    'Credit Card',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Money reversed',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    '+\$6,581',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                  vertical: 1.w,
                ),
                decoration: BoxDecoration(
                  color: primaryColorDark.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'lib/assets/icons/money.png',
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                children: [
                  Text(
                    'Bank Transfer',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Money added',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    '+\$6,581',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                  vertical: 1.w,
                ),
                decoration: BoxDecoration(
                  color: red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'lib/assets/icons/piechart.png',
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                children: [
                  Text(
                    'Refund',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bill payment',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    '+\$6,581',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          decoration: BoxDecoration(
            color: canvasColor,
            boxShadow: [
              BoxShadow(
                color: hintText.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$36,581',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 310 * 3.14 / 180,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.w,
                                vertical: 1.w,
                              ),
                              decoration: BoxDecoration(
                                color: green.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_upward,
                                color: green,
                                size: 4.w,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '+ 9.5%',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            'than last year',
                            style: TextStyle(
                              color: hintText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 3.w,
                            width: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '2023',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            height: 3.w,
                            width: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColorDark,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '2024',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          decoration: BoxDecoration(
            color: canvasColor,
            boxShadow: [
              BoxShadow(
                color: hintText.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Pending Payments',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$36,581',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 310 * 3.14 / 180,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.w,
                                vertical: 1.w,
                              ),
                              decoration: BoxDecoration(
                                color: green.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_upward,
                                color: green,
                                size: 4.w,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '+ 9.5%',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            'than last year',
                            style: TextStyle(
                              color: hintText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 3.w,
                            width: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '2023',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            height: 3.w,
                            width: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColorDark,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '2024',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          decoration: BoxDecoration(
            color: canvasColor,
            boxShadow: [
              BoxShadow(
                color: hintText.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'LifeTime Earnings',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$36,581',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 310 * 3.14 / 180,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.w,
                                vertical: 1.w,
                              ),
                              decoration: BoxDecoration(
                                color: green.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_upward,
                                color: green,
                                size: 4.w,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '+ 9.5%',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            'than last year',
                            style: TextStyle(
                              color: hintText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 3.w,
                            width: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '2023',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            height: 3.w,
                            width: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColorDark,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            '2024',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
