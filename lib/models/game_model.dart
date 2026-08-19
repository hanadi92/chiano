// lib/models/game_model.dart
import 'package:chiano/models/player_model.dart';

class Game {
  final String url; // "https://www.chess.com/game/live/6252899948"
  final String pgn; // "[Event \"Live Chess\"]\n[Site \"Chess.com\"]\n[Date \"2021.01.16\"]\n[Round \"-\"]\n[White \"Bayusi2\"]\n[Black \"kopiko_o9\"]\n[Result \"1-0\"]\n[CurrentPosition \"8/2p5/p2b1k1p/7r/3P1P2/2P3P1/PP4KP/R1B2R2 b - -\"]\n[Timezone \"UTC\"]\n[ECO \"A00\"]\n[ECOUrl \"https://www.chess.com/openings/Van-t-Kruijs-Opening-1...e5\"]\n[UTCDate \"2021.01.16\"]\n[UTCTime \"14:44:36\"]\n[WhiteElo \"1385\"]\n[BlackElo \"1327\"]\n[TimeControl \"600\"]\n[Termination \"Bayusi2 won on time\"]\n[StartTime \"14:44:36\"]\n[EndDate \"2021.01.16\"]\n[EndTime \"14:59:33\"]\n[Link \"https://www.chess.com/game/live/6252899948\"]\n\n1. e3 {[%clk 0:09:52.6]} 1... e5 {[%clk 0:09:58.1]} 2. Nf3 {[%clk 0:09:50.9]} 2... Nc6 {[%clk 0:09:56.6]} 3. Bb5 {[%clk 0:09:47.5]} 3... Nge7 {[%clk 0:09:47.7]} 4. c3 {[%clk 0:09:43.1]} 4... a6 {[%clk 0:09:44.3]} 5. Bxc6 {[%clk 0:09:41.3]} 5... Nxc6 {[%clk 0:09:43.2]} 6. Qb3 {[%clk 0:09:38]} 6... h6 {[%clk 0:09:25.2]} 7. d4 {[%clk 0:09:30.2]} 7... e4 {[%clk 0:09:03.6]} 8. Ne5 {[%clk 0:09:22.2]} 8... Qf6 {[%clk 0:08:32.5]} 9. f4 {[%clk 0:08:59.5]} 9... d6 {[%clk 0:08:08.3]} 10. Nxc6 {[%clk 0:08:52.9]} 10... Bg4 {[%clk 0:06:17.1]} 11. Na5 {[%clk 0:08:19.2]} 11... O-O-O {[%clk 0:05:48.9]} 12. Qxb7+ {[%clk 0:08:10.2]} 12... Kd7 {[%clk 0:05:43.8]} 13. Nc6 {[%clk 0:07:52.2]} 13... Rc8 {[%clk 0:05:02.4]} 14. Nd2 {[%clk 0:07:46.5]} 14... d5 {[%clk 0:04:58.4]} 15. Ne5+ {[%clk 0:07:39.8]} 15... Kd8 {[%clk 0:04:21.6]} 16. Qxd5+ {[%clk 0:07:29.9]} 16... Bd6 {[%clk 0:04:16.8]} 17. Nxg4 {[%clk 0:07:26.5]} 17... Qh4+ {[%clk 0:04:15.5]} 18. g3 {[%clk 0:07:18.3]} 18... Qxg4 {[%clk 0:04:13.8]} 19. Qxf7 {[%clk 0:07:13.7]} 19... Rf8 {[%clk 0:03:53.5]} 20. Qd5 {[%clk 0:07:05.5]} 20... g5 {[%clk 0:03:38.8]} 21. Nxe4 {[%clk 0:07:00.4]} 21... gxf4 {[%clk 0:03:12.3]} 22. exf4 {[%clk 0:06:45.2]} 22... Re8 {[%clk 0:02:41.7]} 23. O-O {[%clk 0:06:14]} 23... Rb8 {[%clk 0:02:10.8]} 24. Nf6 {[%clk 0:06:09.1]} 24... Rb5 {[%clk 0:01:23]} 25. Qa8+ {[%clk 0:06:01]} 25... Ke7 {[%clk 0:01:16.4]} 26. Qxe8+ {[%clk 0:05:56.4]} 26... Kxf6 {[%clk 0:01:11.8]} 27. Qc6 {[%clk 0:05:52.1]} 27... Rh5 {[%clk 0:00:18.1]} 28. Rf2 {[%clk 0:05:32.7]} 28... Qd1+ {[%clk 0:00:16.3]} 29. Rf1 {[%clk 0:05:27.6]} 29... Qe2 {[%clk 0:00:15.7]} 30. Qg2 {[%clk 0:05:20]} 30... Qxg2+ {[%clk 0:00:13.4]} 31. Kxg2 {[%clk 0:05:18.4]} 1-0\n",
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
          pgn: pgn,
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
