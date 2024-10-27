import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/consultant/bookings/view/bookings.dart';
import 'package:scp/core/consultant/calendar/view/calendar.dart';
import 'package:scp/core/consultant/payments/view/payments.dart';
import 'package:scp/core/consultant/priorityDMs/view/priority_dms.dart';
import 'package:scp/core/consultant/services/services.dart';
import 'package:scp/core/consultant/testimonials/view/testimonials.dart';
import 'package:scp/theme/colors/colors.dart';

class ConsultantFooterButtons extends StatelessWidget {
  const ConsultantFooterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Bookings(),
            ),
          ),
          tooltip: 'Bookings',
          icon: Image.asset(
            'lib/assets/icons/bookings.png',
            color: textColor,
            width: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PriorityDMs(),
            ),
          ),
          tooltip: 'Priority DMs',
          icon: Image.asset(
            'lib/assets/icons/prioritydm.png',
            color: textColor,
            width: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Testimonials(),
            ),
          ),
          tooltip: 'Testimonials',
          icon: Image.asset(
            'lib/assets/icons/testomonials.png',
            color: textColor,
            width: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Services(),
            ),
          ),
          tooltip: 'Services',
          icon: Image.asset(
            'lib/assets/icons/services.png',
            color: textColor,
            width: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Calendar(),
            ),
          ),
          tooltip: 'Calendar',
          icon: Image.asset(
            'lib/assets/icons/calendar.png',
            color: textColor,
            width: 6.w,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Payments(),
            ),
          ),
          tooltip: 'Payments',
          icon: Image.asset(
            'lib/assets/icons/payment.png',
            color: textColor,
            width: 6.w,
          ),
        ),
      ],
    );
  }
}
