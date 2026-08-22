import 'package:chiano/extensions/string_extension.dart';
import 'package:chiano/services/mappers/landing_square_mapper.dart';
import 'package:chiano/services/mappers/piece_based_mapper.dart';
import 'package:chiano/ui/components/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

import '../../extensions/pgn_move_extension.dart';
import '../../models/game_model.dart';
import '../components/play_button.dart';
import '../components/visualizer.dart';

enum _PlayerStatus { loading, ready, playing, error }

final PieceBasedMapper _pieceBasedMapper = PieceBasedMapper();
final LandingSquareMapper _landingSquareMapper = LandingSquareMapper();

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({required this.game, super.key});

  final Game game;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final MusicVisualizerController visualizerController;
  final _midiEngine = MidiPro();

  _PlayerStatus _status = _PlayerStatus.loading;
  Object? _error;
  int _playbackGeneration = 0;

  VisualizationStyle _visualizationStyle = VisualizationStyle.waves;

  static const _noteDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    visualizerController = MusicVisualizerController();
    _initMidiEngine();
    _loadSoundfont();
  }

  @override
  void dispose() {
    _playbackGeneration++;
    _midiEngine.stopAllNotes();
    _midiEngine.unloadSoundfont(1);
    _midiEngine.dispose();
    visualizerController.dispose();
    super.dispose();
  }

  Future<void> _playBentNote({
    required int sfId,
    required int channel,
    required int key,
    required int velocity,
    required int bendValue,
    required Duration preBendDelay,
    required Duration bendDuration,
  }) async {
    await _midiEngine.pitchBend(value: 8192, channel: channel, sfId: sfId);
    await _midiEngine.playNote(sfId: sfId, channel: channel, key: key, velocity: velocity);
    visualizerController.noteOn(key: key, velocity: velocity, duration: Duration(milliseconds: 400));

    try {
      await Future.delayed(preBendDelay);
      await _midiEngine.pitchBend(value: bendValue, channel: channel, sfId: sfId);
      await Future.delayed(bendDuration);
    } finally {
      await _midiEngine.pitchBend(value: 8192, channel: channel, sfId: sfId);
      await _midiEngine.stopNote(sfId: sfId, channel: channel, key: key);
    }
  }

  Future<void> _initMidiEngine() async {
    await _midiEngine.init();
  }

  Future<void> _loadSoundfont() async {
    try {
      await _midiEngine.loadSoundfontAsset(
        assetPath: 'assets/Piano.SF2',
        bank: 0,
        program: 0,
      );

      if (!mounted) return;
      setState(() => _status = _PlayerStatus.ready);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _PlayerStatus.error;
        _error = e;
      });
    }
  }

  Future<void> _play() async {
    if (widget.game.pgn.moves.isEmpty) return;

    final generation = ++_playbackGeneration;
    setState(() => _status = _PlayerStatus.playing);

    for (final move in widget.game.pgn.moves) {
      if (generation != _playbackGeneration || !mounted) return;
      final note = move.note(_pieceBasedMapper);

      debugPrint('play note ${move.san} $note');
      if (move.isCheck) {
        await _playBentNote(
          sfId: 1,
          channel: 0,
          key: note,
          velocity: move.velocity,
          bendValue: 16383,
          preBendDelay: const Duration(milliseconds: 300),
          bendDuration: const Duration(milliseconds: 800),
        );
      }
      else {
        await _midiEngine.playNote(key: note, velocity: move.velocity);
        visualizerController.noteOn(key: note, velocity: move.velocity, duration: Duration(milliseconds: 400));
        await Future<void>.delayed(_noteDuration);
      }

      if (generation != _playbackGeneration || !mounted) return;
      await _midiEngine.stopNote(key: note);
    }

    if (generation == _playbackGeneration && mounted) {
      setState(() => _status = _PlayerStatus.ready);
    }
  }

  Future<void> _stop() async {
    _playbackGeneration++;
    await _midiEngine.panic();
    await _midiEngine.stopAllNotes();
    visualizerController.reset();
    if (!mounted) return;
    setState(() => _status = _PlayerStatus.ready);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Scaffold(
      appBar: TitleBar(
        title: 'Playing: ${widget.game.timeClass.toTitleCase()}',
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildVisualizationSelector(),
            Expanded(
              child: MusicVisualizer(
                controller: visualizerController,
                style: _visualizationStyle,
                color: colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: _buildPlayButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SegmentedButton<VisualizationStyle>(
        segments: const [
          ButtonSegment(
            value: VisualizationStyle.waves,
            label: Text('Waves'),
            icon: Icon(Icons.waves),
          ),
          ButtonSegment(
            value: VisualizationStyle.dots,
            label: Text('Dots'),
            icon: Icon(Icons.bubble_chart),
          ),
          ButtonSegment(
            value: VisualizationStyle.bars,
            label: Text('Bars'),
            icon: Icon(Icons.bar_chart),
          ),
        ],
        selected: {_visualizationStyle},
        onSelectionChanged: (selection) {
          setState(() {
            _visualizationStyle = selection.first;
          });
        },
      ),
    );
  }

  Widget _buildPlayButton() {
    switch (_status) {
      case _PlayerStatus.loading:
        return const SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(),
        );

      case _PlayerStatus.error:
        return Text(
          'Could not load soundfont:\n$_error',
          textAlign: TextAlign.center,
        );

      case _PlayerStatus.ready:
        return PlayButton(
          icon: Icons.play_arrow_rounded,
          onPressed: widget.game.pgn.moves.isEmpty ? null : _play,
        );

      case _PlayerStatus.playing:
        return PlayButton(
          icon: Icons.stop_rounded,
          onPressed: _stop,
        );
    }
  }
}