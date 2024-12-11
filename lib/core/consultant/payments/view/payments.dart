import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/payments/providers/payments_provider.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';

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
    _tabController = TabController(length: 1, vsync: this);
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
                Transactions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Transactions extends ConsumerStatefulWidget {
  const Transactions({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends ConsumerState<Transactions> {
  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentProvider);
    return payments.when(
      data: (data) {
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var price = 0;

              for (var a in data[index].bookings!) {
                price = price + int.parse(data[index].price.toString());
              }
              return Container(
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
                        SizedBox(
                          width: 80.w,
                          child: Text(
                            'Transactions against Service: ${data[index].title}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.clip,
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
                            Row(
                              children: [
                                Text(
                                  '\$',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  '$price',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            // Row(
                            //   children: [
                            //     Transform.rotate(
                            //       angle: 310 * 3.14 / 180,
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: 1.w,
                            //           vertical: 1.w,
                            //         ),
                            //         decoration: BoxDecoration(
                            //           color: green.withOpacity(0.3),
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Icon(
                            //           Icons.arrow_upward,
                            //           color: green,
                            //           size: 4.w,
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 1.w,
                            //     ),
                            //     Text(
                            //       '+ 9.5%',
                            //       style: TextStyle(
                            //         color: textColor,
                            //         fontSize: 16.sp,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 1.w,
                            //     ),
                            //     Text(
                            //       'than last year',
                            //       style: TextStyle(
                            //         color: hintText,
                            //         fontSize: 16.sp,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 1.h,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       height: 3.w,
                            //       width: 3.w,
                            //       decoration: const BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: primaryColor,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 3.w,
                            //     ),
                            //     Text(
                            //       '2023',
                            //       style: TextStyle(
                            //         color: textColor,
                            //         fontSize: 16.sp,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5.w,
                            //     ),
                            //     Container(
                            //       height: 3.w,
                            //       width: 3.w,
                            //       decoration: const BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: primaryColorDark,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 3.w,
                            //     ),
                            //     Text(
                            //       '2024',
                            //       style: TextStyle(
                            //         color: textColor,
                            //         fontSize: 16.sp,
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => const Center(
        child: CustomProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }
}
