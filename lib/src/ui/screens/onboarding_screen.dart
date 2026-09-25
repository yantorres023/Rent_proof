import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_info.dart';
import '../../providers.dart';

class _Page {
  const _Page(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

const _pages = [
  _Page(
    Icons.home_work_outlined,
    'Record your place on move-in day',
    'Walk through each room with simple prompts, ideally before your '
        'boxes are unpacked.',
  ),
  _Page(
    Icons.picture_as_pdf_outlined,
    'Get a dated report you can send',
    'Turn your photos and notes into a PDF condition report. Sending it to '
        'your landlord soon after move-in gives both of you the same record.',
  ),
  _Page(
    Icons.compare_outlined,
    'Compare at move-out',
    'Repeat the same walkthrough when you leave and view the rooms side by '
        'side with your move-in photos.',
  ),
  _Page(
    Icons.lock_outline,
    'Private, and honest about limits',
    'Everything stays on this phone unless you share it. No account. '
        'The app records when it saved each file and a fingerprint (SHA-256) '
        'of the original. That shows a file has not changed since. It does '
        'not prove when a photo was taken, and it is not legal advice.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() =>
      ref.read(settingsRepositoryProvider).setOnboardingCompleted();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final last = _index == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: _finish, child: const Text('Skip')),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        ExcludeSemantics(
                          child: Icon(
                            page.icon,
                            size: 72,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (i == 0)
                          Text(
                            appName,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        Semantics(
                          header: true,
                          child: Text(
                            page.title,
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.body,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Semantics(
              label: 'Page ${_index + 1} of ${_pages.length}',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: i == _index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: last
                      ? _finish
                      : () => _controller.nextPage(
                          duration: MediaQuery.disableAnimationsOf(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        ),
                  child: Text(last ? 'Get started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
