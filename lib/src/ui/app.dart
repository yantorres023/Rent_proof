import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_info.dart';
import '../providers.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';

class RentProofApp extends StatelessWidget {
  const RentProofApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('en', 'US')],
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(onboardingCompletedProvider);
    return onboarded.when(
      data: (done) => done ? const HomeScreen() : const OnboardingScreen(),
      loading: () => const Scaffold(body: SizedBox.shrink()),
      error: (_, _) => const HomeScreen(),
    );
  }
}
