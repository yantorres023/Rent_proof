import 'package:uuid/uuid.dart';

/// Injectable time source so tests can control recorded timestamps.
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// Random (v4) identifiers. Never derived from user input.
class IdGenerator {
  const IdGenerator();

  static const _uuid = Uuid();

  String next() => _uuid.v4();
}
