import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/auth/onboarding/view/splash_page.dart';
import 'package:scp/core/consultant/calendar/view_model/available_slots_view_model.dart';
import 'package:scp/core/consultant/consultant_dashboard/providers/booked_session_provider.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/widgets/consultant_footer_buttons.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/widgets/info_button.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/widgets/new_card.dart';
import 'package:scp/core/consultant/services/digital_products/view_models/digital_products_offered_view_model.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view_models/one_to_one_session_view_model.dart';
import 'package:scp/core/consultant/services/priority_dm/view_models/priority_dm_service_view_model.dart';
import 'package:scp/core/consultant/services/service_packages/view_models/service_packages_view_model.dart';
import 'package:scp/core/consultant/testimonials/view_model/testimonials_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsultantDashboard extends ConsumerStatefulWidget {
  const ConsultantDashboard({super.key});

  @override
  ConsultantDashboardState createState() => ConsultantDashboardState();
}

class ConsultantDashboardState extends ConsumerState<ConsultantDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(oneToOneSessionViewModelProvider.notifier).list());
    Future.microtask(
        () => ref.read(priorityDmServiceViewModelProvider.notifier).list());
    Future.microtask(() =>
        ref.read(digitalProductsOfferedViewModelProvider.notifier).list());
    Future.microtask(
        () => ref.read(servicePackagesViewModelProvider.notifier).list());

    Future.microtask(
        () => ref.read(availableSlotsViewModelProvider.notifier).list());

    Future.microtask(
        () => ref.read(testimonialsViewModelProvider.notifier).list());
    _controller = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    _controller = ScrollController();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentIndex = (_currentIndex + 1) % _cards.length;
      _controller.animateTo(
        _controller.position.maxScrollExtent * (_currentIndex / _cards.length),
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late ScrollController _controller;
  int _currentIndex = 0;
  final _cards = List.generate(3, (index) => const NewsCard());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Text(
            'Social Dux',
            style: TextStyle(
              fontSize: 18.sp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              Supabase.instance.client.auth.signOut();
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove('token');
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SplashPage()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(
              TablerIcons.logout,
              color: white,
            ),
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          ref.invalidate(bookedSessionCountProvider);
          ref.invalidate(priorityDMBookedCountProvider);
          ref.invalidate(testimonialsCountProviders);
          ref.invalidate(paymentCount);
          return Future<void>.delayed(const Duration(seconds: 0));
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0.0, 100 * (1 - _animation.value)),
              child: Opacity(
                opacity: _animation.value,
                child: ListView(
                  children: [
                    const NewsCard(),
                    // Add more NewsCard widgets here
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final count = ref.watch(bookedSessionCountProvider);
                            return count.when(
                              data: (val) {
                                return InfoWidget(
                                  textColor: primaryColor,
                                  backgroundColor:
                                      primaryColor.withOpacity(0.2),
                                  splashColor: primaryColor.withOpacity(0.1),
                                  onPressed: () {},
                                  heading: 'Booked Sessions',
                                  count: val,
                                  iconString: 'lib/assets/icons/bookings.png',
                                );
                              },
                              error: (e, st) {
                                return const SizedBox();
                              },
                              loading: () {
                                return const SizedBox();
                              },
                            );
                          },
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final count =
                                ref.watch(priorityDMBookedCountProvider);
                            return count.when(
                              data: (val) {
                                return InfoWidget(
                                  textColor: orange,
                                  backgroundColor: orange.withOpacity(0.2),
                                  splashColor: orange.withOpacity(0.1),
                                  onPressed: () {},
                                  heading: 'Priority DMs',
                                  count: val,
                                  iconString: 'lib/assets/icons/prioritydm.png',
                                );
                              },
                              error: (e, st) {
                                return const SizedBox();
                              },
                              loading: () {
                                return const SizedBox();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final count = ref.watch(testimonialsCountProviders);
                            return count.when(
                              data: (val) {
                                return InfoWidget(
                                  textColor: cyan,
                                  backgroundColor: cyan.withOpacity(0.2),
                                  splashColor: cyan.withOpacity(0.1),
                                  onPressed: () {},
                                  heading: 'Testimonials',
                                  count: val,
                                  iconString:
                                      'lib/assets/icons/testomonials.png',
                                );
                              },
                              error: (e, st) {
                                return const SizedBox();
                              },
                              loading: () {
                                return const SizedBox();
                              },
                            );
                          },
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final count = ref.watch(paymentCount);
                            return count.when(
                              data: (val) {
                                return InfoWidget(
                                  textColor: red,
                                  backgroundColor: red.withOpacity(0.2),
                                  splashColor: red.withOpacity(0.1),
                                  onPressed: () {},
                                  heading: 'Payments',
                                  count: val,
                                  iconString: 'lib/assets/icons/payment.png',
                                );
                              },
                              error: (e, st) {
                                return const SizedBox();
                              },
                              loading: () {
                                return const SizedBox();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      persistentFooterButtons: const [
        ConsultantFooterButtons(),
      ],
    );
  }
}
