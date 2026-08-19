// lib/models/game_model.dart
import 'package:chiano/models/pgn_model.dart';
import 'package:chiano/models/player_model.dart';

class Game {
  final String url; // "https://www.chess.com/game/live/6252899948"
  final PgnGame pgn;
  final String timeControl; // "600"
  final int endTime; // 1610809173
  final bool rated; // true
  final String tcn; // "mu0Kgv5QfH!0ksWOHQ0Qdr3VlBKCvK7TnDZRKQ6EQG86rX6ZGQ76blRJQKZ7XJ9RKETFowFEJ1?91J2MlCMDuD98eg65CT5HJ470480T8QHNfnEdnfdmQomogo"
  final String uuid; // "540cd88c-5809-11eb-9a76-0069e4010001"
  final String initialSetup; // "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  final String fen; // "8/2p5/p2b1k1p/7r/3P1P2/2P3P1/PP4KP/R1B2R2 b - -"
  final String timeClass; // "rapid"
  final String rules; // "chess"
  final Player white;
  final Player black;
  final String eco; // "https://www.chess.com/openings/Van-t-Kruijs-Opening-1...e5"

  Game({
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
