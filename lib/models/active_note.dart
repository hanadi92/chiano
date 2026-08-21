import 'package:flutter/foundation.dart';

@immutable
class ActiveNote {
  const ActiveNote({
    required this.key,
    required this.velocity,
    required this.startedAt,
    required this.duration,
    this.releasedAt,
  });
  final int key;
  final int velocity;
  final DateTime startedAt;
  final Duration duration;
  final DateTime? releasedAt;

  ActiveNote released(DateTime at) => ActiveNote(
    key: key,
    velocity: velocity,
    startedAt: startedAt,
    duration: duration,
    releasedAt: at,
  );

  double opacityAt(DateTime now) {
    final endAt = releasedAt ?? startedAt.add(duration);
    final remaining = endAt.difference(now).inMilliseconds;
    if (remaining <= 0) return 0.0;

    const fadeMs = 500;
    if (remaining >= fadeMs) return 1.0;

    return remaining / fadeMs;
  }

  bool isExpiredAt(DateTime now) => opacityAt(now) <= 0;
}
