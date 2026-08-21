// lib/models/game_model.dart
import 'package:chiano/models/pgn_model.dart';
import 'package:chiano/models/player_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class Game {
  final String url;
  final PgnGame pgn;
  final String timeControl;
  final int endTime;
  final bool rated;
  final String tcn;
  final String uuid;
  final String initialSetup;
  final String fen;
  final String timeClass;
  final String rules;
  final Player white;
  final Player black;
  final String eco;

  const Game({
    required this.url,
    required this.pgn,
    required this.timeControl,
    required this.endTime,
    required this.rated,
    required this.tcn,
    required this.uuid,
    required this.initialSetup,
    required this.fen,
    required this.timeClass,
    required this.rules,
    required this.white,
    required this.black,
    required this.eco,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'url': String url,
        'pgn': String pgn,
        'time_control': String timeControl,
        'end_time': int endTime,
        'rated': bool rated,
        'tcn': String tcn,
        'uuid': String uuid,
        'initial_setup': String initialSetup,
        'fen': String fen,
        'time_class': String timeClass,
        'rules': String rules,
        'white': Map<String, dynamic> whiteJson,
        'black': Map<String, dynamic> blackJson,
        'eco': String eco,
      } =>
        Game(
          url: url,
          pgn: PgnGame.parse(pgn),
          timeControl: timeControl,
          endTime: endTime,
          rated: rated,
          tcn: tcn,
          uuid: uuid,
          initialSetup: initialSetup,
          fen: fen,
          timeClass: timeClass,
          rules: rules,
          white: Player.fromJson(whiteJson),
          black: Player.fromJson(blackJson),
          eco: eco,
        ),
      _ => throw const FormatException('Failed to load game structure.'),
    };
  }
}
