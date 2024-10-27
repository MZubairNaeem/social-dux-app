import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/auth/onboarding/view/splash_page.dart';
import 'package:scp/theme/data/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vemwjjmnxcrmuiyypdge.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlbXdqam1ueGNybXVpeXlwZGdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc5MjUzNzgsImV4cCI6MjA0MzUwMTM3OH0.J7YcKNzrFXAmQKgGbCJ9ZYcFA_LANH7BPBhkuQCqgZc',
  );

  runApp(const SocialDux());
}

final supabase = Supabase.instance.client;
const storagePath =
    'https://vemwjjmnxcrmuiyypdge.supabase.co/storage/v1/object/public/';

class SocialDux extends StatelessWidget {
  const SocialDux({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return ProviderScope(
          child: MaterialApp(
            title: 'Social Dux',
            theme: MyThemes.blueTheme,
            home: const SplashPage(),
          ),
        );
      },
    );
  }
}
