import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/consultant_services/digital_products_service/view/digital_products_service.dart';
import 'package:scp/core/buyer/consultant_services/dm_service/view/dm_service.dart';
import 'package:scp/core/buyer/consultant_services/one_to_sessions_service/view/one_to_sessions_service.dart';
import 'package:scp/core/buyer/consultant_services/packages_offered/view/packages_offered.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';

class ConsultantServices extends ConsumerStatefulWidget {
  final String id;
  const ConsultantServices({super.key, required this.id});

  @override
  ConsultantServicesState createState() => ConsultantServicesState();
}

class ConsultantServicesState extends ConsumerState<ConsultantServices>
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
              children: [
                OneToSessionsService(id: widget.id),
                DmServices(id: widget.id),
                DigitalProductsService(id: widget.id),
                PackagesOffered(id: widget.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
