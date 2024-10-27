import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/theme/colors/colors.dart';

class MyThemes {
  static final ThemeData blueTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          primaryColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          white,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
      ),
    ),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    splashColor: const Color(0xFF5D87FF),
    primaryColor: const Color(0xFF5D87FF),
    primaryColorLight: const Color(0xFFECF2FF),
    primaryColorDark: const Color(0xFF4570EA),
    secondaryHeaderColor: const Color(0xFF49BEFF),
    brightness: Brightness.light,
    canvasColor: const Color(0xFFFFFFFF),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    hintColor: const Color(0xFF243142).withOpacity(0.5),
    textTheme: const TextTheme(),
  );
}
