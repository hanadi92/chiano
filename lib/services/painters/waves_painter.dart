import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/active_note.dart';

const _minKey = 21; // lowest key on an 88-key piano
const _maxKey = 108; // highest key on an 88-key piano

double _pitchFraction(int key) => ((key - _minKey) / (_maxKey - _minKey)).clamp(0.0, 1.0);

class WavesPainter extends CustomPainter {
  WavesPainter({required this.notes, required this.idlePhase, required this.color});

  final List<ActiveNote> notes;
  final double idlePhase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    // Faint idle baseline so the visualizer isn't dead when silent.
    _drawWave(
      canvas,
      size,
      centerY: size.height / 2,
      amplitude: 6,
      cycles: 1.5,
      phase: idlePhase * 2 * math.pi,
      color: color.withValues(alpha: 0.15),
    );

    for (final note in notes) {
      final opacity = note.opacityAt(now);
      if (opacity <= 0) continue;
      final pitchFrac = _pitchFraction(note.key);
      final velocityFrac = note.velocity / 127;
      final elapsedSeconds = now.difference(note.startedAt).inMilliseconds / 1000;

      _drawWave(
        canvas,
        size,
        centerY: size.height * (1 - pitchFrac),
        amplitude: 8 + velocityFrac * 40,
        cycles: 1 + pitchFrac * 5,
        phase: elapsedSeconds * 3,
        color: color.withValues(alpha: 0.8 * opacity),
      );
    }
  }

  void _drawWave(
      Canvas canvas,
      Size size, {
        required double centerY,
        required double amplitude,
        required double cycles,
        required double phase,
        required Color color,
      }) {
    final path = Path();
    const step = 4.0;
    for (double x = 0; x <= size.width; x += step) {
      final t = x / size.width;
      final y = centerY + math.sin(t * cycles * 2 * math.pi + phase) * amplitude;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant WavesPainter oldDelegate) => true;
}