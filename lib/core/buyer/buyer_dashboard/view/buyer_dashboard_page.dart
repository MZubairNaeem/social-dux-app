import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/constant/path.dart';
import 'package:scp/core/auth/onboarding/view/splash_page.dart';
import 'package:scp/core/buyer/buyer_dashboard/view_model/all_services_provider.dart';
import 'package:scp/core/buyer/buyer_dashboard/view_model/user_provider.dart';
import 'package:scp/core/buyer/direct_messages/view/chat_room.dart';
import 'package:scp/main.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerDashboardPage extends ConsumerStatefulWidget {
  const BuyerDashboardPage({super.key});

  @override
  BuyerDashboardPageState createState() => BuyerDashboardPageState();
}

class BuyerDashboardPageState extends ConsumerState<BuyerDashboardPage> {
  final searchContrller = TextEditingController();
  // List of pill names
  final List<String> pillOptions = [
    'All',
    'Technology',
    'Education',
    'Advocacy',
    'Influencer'
  ];
  @override
  void initState() {
    super.initState();
    // Trigger the list() function when the widget is first built //for islands
    // Future.microtask(() => {
    //       log('adadada'),
    //       ref.read(customerRequestViewModelProvider.notifier).list(),
    //     });
  }

  // Track the currently selected pill
  String selectedPill = 'All';

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider(supabase.auth.currentUser!.id));
    final serviceState = ref.watch(allServiceCategoriesProvider);
    final technologyState =
        ref.watch(allFilterConsultantsProvider(selectedPill));
    final educationState =
        ref.watch(allFilterConsultantsProvider(selectedPill));
    final advocacyState = ref.watch(allFilterConsultantsProvider(selectedPill));
    final influencerState =
        ref.watch(allFilterConsultantsProvider(selectedPill));
    final searchedServiceState =
        ref.watch(searchedConsultantByNameProvider(searchContrller.text));

    final categoryDataToShow = selectedPill == 'Technology'
        ? technologyState // Use technologyState for "Technology"
        : selectedPill == 'Education'
            ? educationState // Use technologyState for "Education"
            : selectedPill == 'Advocacy'
                ? advocacyState // Use technologyState for "Advocacy"
                : selectedPill == 'Influencer'
                    ? influencerState // Use socialMediaServiceState for "Influencer"
                    : serviceState; // Handle other cases as needed
    //if search controller is empty use dataToShow otherWise use searchedServiceState
    final dataToShow = searchContrller.text.isEmpty
        ? categoryDataToShow
        : searchedServiceState;

    return Scaffold(
      backgroundColor: white,
      body: ListView(
        children: [
          userState.when(
            data: (val) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60.w,
                          child: Text(
                            'Hello, Welcome 👋',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60.w,
                          child: Text(
                            val.name,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        supabase.auth.signOut();
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('token');
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SplashPage()),
                            (route) => false,
                          );
                        }
                      },
                      child: Container(
                        width: 13.w,
                        height: 13.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9).withOpacity(0.2),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: ClipOval(
                            child: val.dp == null
                                ? Text(val.name.substring(0, 2))
                                : Image.network(
                                    '$storageUrl${val.dp}',
                                    width: 26.w,
                                    height: 26.w,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const CupertinoActivityIndicator(
              color: primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            child: TextField(
              controller: searchContrller,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                hintText: 'Search your favorite by name . . .',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: neutral400,
                ),
                prefixIcon: Icon(
                  TablerIcons.search,
                  color: textColor,
                  size: 18.sp,
                ),
                filled: true,
                fillColor: primaryColor.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.sp),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 7.w,
              top: 1.h,
            ),
            child: Text(
              'Shortcuts',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 2.h,
              ),
              child: Row(
                children: [
                  InkWellButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatRoom(),
                      ),
                    ),
                    text: 'Direct Messages',
                    splashColor: green.withOpacity(0.1),
                    textColor: textColor,
                    iconColor: green,
                    icon: TablerIcons.message_dots,
                  ),
                  SizedBox(width: 3.w),
                  // InkWell(
                  //   onTap: () {},
                  //   splashColor: accentColor.withOpacity(0.1),
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         TablerIcons.heart,
                  //         color: accentColor,
                  //         size: 20.sp,
                  //       ),
                  //       SizedBox(height: 1.h),
                  //       Text(
                  //         'Health & Wellbeing',
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(width: 3.w),
                  // InkWell(
                  //   onTap: () {},
                  //   splashColor: red.withOpacity(0.1),
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         TablerIcons.calendar,
                  //         color: red,
                  //         size: 20.sp,
                  //       ),
                  //       SizedBox(height: 1.h),
                  //       Text(
                  //         'Weddings & Events',
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(width: 3.w),
                  // InkWell(
                  //   onTap: () {},
                  //   splashColor: const Color(0xff2d7af1).withOpacity(0.1),
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         TablerIcons.buildings,
                  //         color: const Color(0xff2d7af1),
                  //         size: 20.sp,
                  //       ),
                  //       SizedBox(height: 1.h),
                  //       Text(
                  //         'Business Services',
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(width: 3.w),
                  // InkWell(
                  //   onTap: () {},
                  //   splashColor: const Color(0xff6610f2).withOpacity(0.1),
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         TablerIcons.book_2,
                  //         color: const Color(0xff6610f2),
                  //         size: 20.sp,
                  //       ),
                  //       SizedBox(height: 1.h),
                  //       Text(
                  //         'Lessons & Training',
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(width: 3.w),
                  // InkWell(
                  //   onTap: () {},
                  //   splashColor: const Color(0xff343a40).withOpacity(0.1),
                  //   child: Column(
                  //     children: [
                  //       Icon(
                  //         TablerIcons.dots,
                  //         color: const Color(0xff343a40),
                  //         size: 20.sp,
                  //       ),
                  //       SizedBox(height: 1.h),
                  //       Text(
                  //         'Other services',
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 7.w,
            ),
            child: Text(
              'Top Domains ✨',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),
            child: SizedBox(
              height: 4.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Make it scrollable
                itemCount: pillOptions.length,
                itemBuilder: (context, index) {
                  final pill = pillOptions[index];
                  final isSelected = selectedPill == pill;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedPill = pill; // Update selected pill
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isSelected ? primaryColor : Colors.transparent,
                        side: BorderSide(
                          color: isSelected ? primaryColor : neutral200,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        pill,
                        style: TextStyle(
                          color: isSelected ? white : textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            // height: 50.h,
            child: dataToShow.when(
              data: (val) {
                if (val.isEmpty) {
                  return Center(
                    child: Text(
                      'No Service Found',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 3.w,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: val.length,
                      itemBuilder: (context, count) {
                        return InkWell(
                          splashColor: primaryColor.withOpacity(0.1),
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: neutral200,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.sp),
                                    topRight: Radius.circular(8.sp),
                                    bottomRight: Radius.circular(12.sp),
                                    bottomLeft: Radius.circular(12.sp),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.sp),
                                          topRight: Radius.circular(10.sp),
                                        ),
                                        child: val[count].dp == null
                                            ? SizedBox(
                                                width: double.infinity,
                                                child: CircleAvatar(
                                                  child: Text(val[count]
                                                      .name
                                                      .substring(0, 2)),
                                                ),
                                              )
                                            : Image.network(
                                                storageUrl + val[count].dp!,
                                                width: double.infinity,
                                                fit: BoxFit.fitWidth,
                                              ),
                                      ),
                                    ),
                                    // 20% of the height for the text
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 1.w),
                                        child: Text(
                                          val[count].name,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: textColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        val[count].userProfiles != null
                                            ? val[count].userProfiles!.tagline!
                                            : '',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: textColor.withOpacity(0.6),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                  ).copyWith(bottom: 1.w),
                                  margin: EdgeInsets.all(10.sp),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                  child: Text(
                                    val[count].userProfiles!.domains!.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const CupertinoActivityIndicator(
                color: primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}

class InkWellButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color splashColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;

  const InkWellButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.splashColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      borderRadius: BorderRadius.circular(12.sp),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20.sp,
          ),
          SizedBox(height: 1.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
