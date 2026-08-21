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
    final centerY = size.height / 2;
    final path = Path();
    const step = 4.0;

    for (double x = 0; x <= size.width; x += step) {
      // size of the whole wave
      final t = x / size.width;

      // Base movement of the wave.
      double displacement =
          math.sin(
            t * math.pi * 2 * 1.5 +
                idlePhase * math.pi * 2,
          ) * 6;

      for (final note in notes) {
        final opacity = note.opacityAt(now);
        if (opacity <= 0) continue;
        // where the current note belong on the wave 0-1 low-high note
        final pitch = _pitchFraction(note.key);
        final distance = t - pitch;
        // controls how wide the effect is
        const sigma = 0.10;
        // controls the domino effect (horizontal)
        final influence = math.exp(-(distance * distance) / (2 * sigma * sigma));
        // the height of the effect (vertical)
        final velocity = note.velocity / 127;
        final elapsed = now.difference(note.startedAt).inMilliseconds / 1000;
        final wave = math.sin(distance * 40 - elapsed * 8) * velocity * opacity * influence * 100;

        displacement += wave;
      }

      final y = centerY + displacement;

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