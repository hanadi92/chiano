import 'package:chiano/extensions/string_extension.dart';
import 'package:chiano/services/mappers/piece_based_mapper.dart';
import 'package:chiano/services/mappers/landing_square_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

import '../extensions/pgn_move_extension.dart';
import '../models/game_model.dart';
import 'visualizer_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing: ${widget.game.timeClass.toTitleCase()}'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: _buildPlayButton(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: MusicVisualizer(
                controller: visualizerController,
                style: VisualizationStyle.bars,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    switch (_status) {
      case _PlayerStatus.loading:
        return const CircularProgressIndicator();
      case _PlayerStatus.error:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Could not load soundfont:\n$_error',
            textAlign: TextAlign.center,
          ),
        );
      case _PlayerStatus.ready:
        return FloatingActionButton(
          onPressed: widget.game.pgn.moves.isEmpty ? null : _play,
          tooltip: 'Play',
          child: const Icon(Icons.play_arrow),
        );
      case _PlayerStatus.playing:
        return FloatingActionButton(
          onPressed: _stop,
          tooltip: 'Stop',
          child: const Icon(Icons.stop),
        );
    }
  }
}
