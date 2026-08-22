import 'dart:math' as math;

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

    _drawIdleDots(canvas, size);

    for (final note in notes) {
      _drawNote(canvas, size, note, now);
    }
  }

  void _drawIdleDots(Canvas canvas, Size size) {
    for (var i = 0; i < 10; i++) {
      final phase = (idlePhase + i / 10) % 1.0;
      final x = size.width * (0.08 + 0.84 * ((i * 0.37) % 1.0));
      final y = size.height * (0.15 + 0.7 * phase);
      final radius = 3.0 + math.sin(idlePhase * 2 * math.pi + i) * 1.0;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = color.withValues(alpha: 0.22),
      );
    }
  }

  void _drawNote(Canvas canvas, Size size, ActiveNote note, DateTime now)
  {
    final opacity = note.opacityAt(now);
    if (opacity <= 0) return;

    final pitch = _pitchFraction(note.key);
    final velocity = note.velocity / 127.0;
    final elapsed = now.difference(note.startedAt).inMilliseconds / 1000.0;

    // show up with ease-out
    final attack = Curves.easeOut.transform((elapsed / 0.25).clamp(0.0, 1.0));
    // while playing, move
    final movement = math.sin(elapsed * 5.0) * 8.0;
    final x = size.width * pitch;
    final y = size.height * 0.5 + movement;
    final radius = (8.0 + velocity * 32.0) * attack;

    // most out circle
    canvas.drawCircle(
      Offset(x, y),
      radius * 1.8,
      Paint()
        ..color = color.withValues(alpha: opacity * 0.25),
    );

    // middle circle
    canvas.drawCircle(
      Offset(x, y),
      radius,
      Paint()
        ..color = color.withValues(alpha: opacity * 0.50),
    );

    // smallest circle
    canvas.drawCircle(
      Offset(x, y),
      radius * 0.25,
      Paint()..color = color.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(covariant DotsPainter oldDelegate) => true;
}