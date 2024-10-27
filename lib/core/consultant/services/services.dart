import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/services/digital_products/view/add/add_digital_product_offered.dart';
import 'package:scp/core/consultant/services/digital_products/view/list/digital_products_offered.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view/add/add_one_to_one_session.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view/list/one_to_one_sessions.dart';
import 'package:scp/core/consultant/services/priority_dm_service/view/add/add_priority_dm_service.dart';
import 'package:scp/core/consultant/services/priority_dm_service/view/list/priority_dm_services.dart';
import 'package:scp/core/consultant/services/service_packages/view/add/add_service_packages.dart';
import 'package:scp/core/consultant/services/service_packages/view/list/service_packages.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';

class Services extends ConsumerStatefulWidget {
  const Services({super.key});

  @override
  ServicesState createState() => ServicesState();
}

class ServicesState extends ConsumerState<Services>
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
          title: 'Services 😎',
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
                OneToOneSessions(),
                PriorityDmServices(),
                DigitalProductsOffered(),
                ServicePackages(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _selectedIndex == 0
                ? const AddOneToOneSession()
                : _selectedIndex == 1
                    ? const AddPriorityDmService()
                    : _selectedIndex == 2
                        ? const AddDigitalProductOffered()
                        : const AddServicePackages(),
          ),
        ),
        label: Text(
          _selectedIndex == 0
              ? 'Add One to One Session'
              : _selectedIndex == 1
                  ? 'Add Priority DM Service'
                  : _selectedIndex == 2
                      ? 'Add Digital Product'
                      : 'Add Package',
          style: TextStyle(
            fontSize: 15.sp,
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          CupertinoIcons.add,
          color: white,
          size: 15.sp,
        ),
        backgroundColor: green,
      ),
    );
  }
}
