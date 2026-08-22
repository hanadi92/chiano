import 'package:chiano/services/painters/bars_painter.dart';
import 'package:chiano/services/painters/dots_painter.dart';
import 'package:chiano/services/painters/waves_painter.dart';
import 'package:flutter/material.dart';

import '../../models/active_note.dart';

enum VisualizationStyle { waves, dots, bars }

class MusicVisualizerController extends ChangeNotifier {
  static const fadeOutDuration = Duration(milliseconds: 500);

  final List<ActiveNote> _notes = [];

  List<ActiveNote> get notes => List.unmodifiable(_notes);

  void noteOn({
    required int key,
    required int velocity,
    Duration duration = const Duration(seconds: 2),
  }) {
    final now = DateTime.now();
    _notes.removeWhere((n) => n.key == key || n.isExpiredAt(now));
    _notes.add(ActiveNote(
        key: key,
        velocity: velocity,
        startedAt: DateTime.now(),
        duration: duration,
    ));
    notifyListeners();
  }

  void noteOff(int key) {
    final index = _notes.lastIndexWhere((n) => n.key == key && n.releasedAt == null);
    if (index == -1) return;
    _notes[index] = _notes[index].released(DateTime.now());
    notifyListeners();
  }

  void reset() {
    _notes.clear();
    notifyListeners();
  }
}

class MusicVisualizer extends StatefulWidget {
  const MusicVisualizer({
    required this.controller,
    required this.style,
    this.color = Colors.deepPurple,
    super.key,
  });

  final MusicVisualizerController controller;
  final VisualizationStyle style;
  final Color color;

  @override
  State<MusicVisualizer> createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idle;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idle, widget.controller]),
      builder: (context, _) {
        return CustomPaint(
          painter: _painterFor(),
          size: Size.infinite,
        );
      },
    );
  }

  CustomPainter _painterFor() {
    final notes = widget.controller.notes;
    final phase = _idle.value;
    switch (widget.style) {
      case VisualizationStyle.waves:
        return WavesPainter(notes: notes, idlePhase: phase, color: widget.color);
      case VisualizationStyle.dots:
        return DotsPainter(notes: notes, idlePhase: phase, color: widget.color);
      case VisualizationStyle.bars:
        return BarsPainter(notes: notes, idlePhase: phase, color: widget.color);
    }
  }
}
