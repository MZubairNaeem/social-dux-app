import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/calendar/view_model/available_slots_view_model.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/widgets/consultant_footer_buttons.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/widgets/info_button.dart';
import 'package:scp/core/consultant/consultant_dashboard/view/widgets/new_card.dart';
import 'package:scp/core/consultant/services/digital_products/view_models/digital_products_offered_view_model.dart';
import 'package:scp/core/consultant/services/one_to_sessions/view_models/one_to_one_session_view_model.dart';
import 'package:scp/core/consultant/services/priority_dm_service/view_models/priority_dm_service_view_model.dart';
import 'package:scp/core/consultant/services/service_packages/view_models/service_packages_view_model.dart';
import 'package:scp/core/consultant/testimonials/view_model/testimonials_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/drawer/drawer.dart';

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
      drawer: const DrawerWidget(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: PrimaryAppBar(
          title: 'Social Dux',
          icon: false,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0.0, 100 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    child: Row(
                      children: _cards,
                    ),
                  ),
                  // Add more NewsCard widgets here
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoWidget(
                        textColor: primaryColor,
                        backgroundColor: primaryColor.withOpacity(0.2),
                        splashColor: primaryColor.withOpacity(0.1),
                        onPressed: () {},
                        heading: 'Booked Sessions',
                        count: '12',
                        iconString: 'lib/assets/icons/bookings.png',
                      ),
                      InfoWidget(
                        textColor: orange,
                        backgroundColor: orange.withOpacity(0.2),
                        splashColor: orange.withOpacity(0.1),
                        onPressed: () {},
                        heading: 'Priority DMs',
                        count: '15',
                        iconString: 'lib/assets/icons/prioritydm.png',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoWidget(
                        textColor: cyan,
                        backgroundColor: cyan.withOpacity(0.2),
                        splashColor: cyan.withOpacity(0.1),
                        onPressed: () {},
                        heading: 'Testimonials',
                        count: '9',
                        iconString: 'lib/assets/icons/testomonials.png',
                      ),
                      InfoWidget(
                        textColor: red,
                        backgroundColor: red.withOpacity(0.2),
                        splashColor: red.withOpacity(0.1),
                        onPressed: () {},
                        heading: 'Payments',
                        count: '1200',
                        iconString: 'lib/assets/icons/payment.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      persistentFooterButtons: const [
        ConsultantFooterButtons(),
      ],
    );
  }
}
