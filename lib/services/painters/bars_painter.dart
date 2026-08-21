import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/active_note.dart';


const _minKey = 21; // lowest key on an 88-key piano
const _maxKey = 108; // highest key on an 88-key piano
double _pitchFraction(int key) => ((key - _minKey) / (_maxKey - _minKey)).clamp(0.0, 1.0);

class BarsPainter extends CustomPainter {
  BarsPainter({required this.notes, required this.idlePhase, required this.color});

  static const _barCount = 32;

  final List<ActiveNote> notes;
  final double idlePhase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final barWidth = size.width / _barCount;

    // Max intensity per bucket, from whichever active note falls in it.
    final intensity = List<double>.filled(_barCount, 0);
    for (final note in notes) {
      final opacity = note.opacityAt(now);
      if (opacity <= 0) continue;
      final bucket = (_pitchFraction(note.key) * (_barCount - 1)).round();
      final value = (note.velocity / 127) * opacity;
      if (value > intensity[bucket]) intensity[bucket] = value;
    }

    for (var i = 0; i < _barCount; i++) {
      final idleBob = 0.05 + 0.03 * math.sin(idlePhase * 2 * math.pi + i * 0.5);
      final heightFrac = math.max(idleBob, intensity[i]);
      final barHeight = size.height * heightFrac;

      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth + 1,
          size.height - barHeight,
          barWidth - 2,
          barHeight,
        ),
        Paint()..color = color.withValues(alpha: 0.25 + intensity[i] * 0.65),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BarsPainter oldDelegate) => true;
}