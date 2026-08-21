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

    final intensity = List<double>.filled(_barCount, 0);
    for (final note in notes) {
      final opacity = note.opacityAt(now);
      if (opacity <= 0) continue;

      final pitch = _pitchFraction(note.key);
      final bucket = (pitch * (_barCount - 1)).round();
      final velocity = note.velocity / 127.0;
      final elapsed = now.difference(note.startedAt).inMilliseconds / 1000.0;

      // Smooth attack.
      final attack = Curves.easeOut.transform((elapsed / 0.12).clamp(0.0, 1.0));
      final value = velocity * attack * opacity;
      intensity[bucket] = math.max(intensity[bucket], value);
    }

    for (var i = 0; i < _barCount; i++) {
      final idle = 0.12 + 0.05 * math.sin(idlePhase * 2 * math.pi + i * 0.5);
      final heightFraction = math.max(idle, intensity[i]);
      final barHeight = size.height * heightFraction;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * barWidth + 2,
          size.height - barHeight,
          barWidth - 4,
          barHeight,
        ),
        const Radius.circular(4),
      );

      final paint = Paint()
        ..color = color.withValues(
          alpha: 0.25 + intensity[i] * 0.7,
        );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BarsPainter oldDelegate) => true;
}