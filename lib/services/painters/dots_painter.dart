import 'package:flutter/material.dart';

import '../../models/active_note.dart';

const _minKey = 21; // lowest key on an 88-key piano
const _maxKey = 108; // highest key on an 88-key piano
double _pitchFraction(int key) => ((key - _minKey) / (_maxKey - _minKey)).clamp(0.0, 1.0);

class DotsPainter extends CustomPainter {
  DotsPainter({required this.notes, required this.idlePhase, required this.color});

  final List<ActiveNote> notes;
  final double idlePhase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    // Idle ambience: a handful of slow, faint drifting dots.
    for (var i = 0; i < 6; i++) {
      final t = (idlePhase + i / 6) % 1.0;
      final dx = size.width * (0.1 + 0.8 * ((i * 0.37) % 1.0));
      final dy = size.height * (0.2 + 0.6 * t);
      canvas.drawCircle(
        Offset(dx, dy),
        4,
        Paint()..color = color.withValues(alpha: 0.08),
      );
    }

    for (final note in notes) {
      final opacity = note.opacityAt(now);
      if (opacity <= 0) continue;
      final pitchFrac = _pitchFraction(note.key);
      final velocityFrac = note.velocity / 127;
      final elapsedMs = now.difference(note.startedAt).inMilliseconds;

      // Quick attack burst, then settle.
      final attack = (elapsedMs / 150).clamp(0.0, 1.0);
      final radius = (12 + velocityFrac * 36) * attack;
      final dx = size.width * pitchFrac;
      // Spread vertically by pitch class so chords don't fully overlap.
      final dy = size.height * (0.3 + 0.4 * ((note.key % 12) / 12));

      canvas.drawCircle(
        Offset(dx, dy),
        radius,
        Paint()..color = color.withValues(alpha: opacity * 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DotsPainter oldDelegate) => true;
}