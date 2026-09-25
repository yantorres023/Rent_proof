import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/data/database.dart';
import 'src/providers.dart';
import 'src/services/storage_paths.dart';
import 'src/ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final roboto = await rootBundle.loadString(
      'assets/fonts/Roboto_LICENSE.txt',
    );
    yield LicenseEntryWithLineBreaks(['Roboto (report font)'], roboto);
  });
  final paths = await StoragePaths.platform();
  // Leftover share files from a previous session are not needed.
  await paths.clearExports();
  final db = AppDatabase.open();
  runApp(
    ProviderScope(
      // Database errors are not transient; surface them instead of retrying.
      retry: (_, _) => null,
      overrides: [
        databaseProvider.overrideWithValue(db),
        storagePathsProvider.overrideWithValue(paths),
      ],
      child: const RentProofApp(),
    ),
  );
}
