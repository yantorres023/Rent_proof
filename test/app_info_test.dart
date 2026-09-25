import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/app_info.dart';

void main() {
  test('appVersion matches pubspec version', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*([0-9.]+)\+',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(appVersion, version);
  });

  test('public name is not the conflicting codename', () {
    // See docs/DECISIONS.md D-004.
    expect(appName.toLowerCase().replaceAll(' ', ''), isNot('rentproof'));
  });
}
