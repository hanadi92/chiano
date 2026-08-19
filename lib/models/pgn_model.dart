enum PgnColor { white, black }

class PgnMove {
  const PgnMove({
    required this.moveNumber,
    required this.color,
    required this.san,
    this.clock,
  });
  final int moveNumber;
  final PgnColor color;
  // standard algebraic notation for chess moves
  final String san;
  // remaining clock time for the player after this move.
  final Duration? clock;
}

class PgnGame {
  const PgnGame({
    required this.event,
    required this.site,
    required this.date,
    required this.round,
    required this.white,
    required this.black,
    required this.result,
    required this.currentPosition,
    required this.timezone,
    required this.eco,
    required this.ecoUrl,
    required this.utcDate,
    required this.utcTime,
    required this.utcDateTime,
    required this.whiteElo,
    required this.blackElo,
    required this.timeControl,
    required this.termination,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.link,
    required this.moves,
    required this.rawTags,
  });

  final String? event;
  final String? site;
  final DateTime? date;
  final String? round;
  final String? white;
  final String? black;
  final String? result;
  final String? currentPosition;
  final String? timezone;
  final String? eco;
  final Uri? ecoUrl;
  final DateTime? utcDate;
  final String? utcTime;
  final DateTime? utcDateTime;
  final int? whiteElo;
  final int? blackElo;
  final String? timeControl;
  final String? termination;
  final String? startTime;
  final DateTime? endDate;
  final String? endTime;
  final Uri? link;
  final List<PgnMove> moves;

  final Map<String, String> rawTags;

  factory PgnGame.parse(String pgn) {
    final tags = <String, String>{};
    for (final match in _tagPattern.allMatches(pgn)) {
      tags[match.group(1)!] = match.group(2)!;
    }

    final movetextStart = pgn.indexOf('\n\n');
    final movetext = movetextStart == -1 ? pgn : pgn.substring(movetextStart);

    final moves = <PgnMove>[
      for (final match in _movePattern.allMatches(movetext))
        PgnMove(
          moveNumber: int.parse(match.group(1)!),
          color: match.group(2) != null ? PgnColor.black : PgnColor.white,
          san: match.group(3)!,
          clock: _parseClock(match.group(4)),
        ),
    ];

    return PgnGame(
      event: tags['Event'],
      site: tags['Site'],
      date: _date(tags['Date']),
      round: tags['Round'],
      white: tags['White'],
      black: tags['Black'],
      result: tags['Result'],
      currentPosition: tags['CurrentPosition'],
      timezone: tags['Timezone'],
      eco: tags['ECO'],
      ecoUrl: _uri(tags['ECOUrl']),
      utcDate: _date(tags['UTCDate']),
      utcTime: tags['UTCTime'],
      utcDateTime: _combineUtc(tags['UTCDate'], tags['UTCTime']),
      whiteElo: _int(tags['WhiteElo']),
      blackElo: _int(tags['BlackElo']),
      timeControl: tags['TimeControl'],
      termination: tags['Termination'],
      startTime: tags['StartTime'],
      endDate: _date(tags['EndDate']),
      endTime: tags['EndTime'],
      link: _uri(tags['Link']),
      moves: List.unmodifiable(moves),
      rawTags: Map.unmodifiable(tags),
    );
  }

  static final _tagPattern = RegExp(r'\[(\w+)\s+"([^"]*)"\]');
  static final _movePattern = RegExp(
    r'(\d+)\.(\.\.)?\s*(\S+)(?:\s*\{\[%clk\s+([\d:.]+)\]\})?',
  );

  static Duration? _parseClock(String? raw) {
    if (raw == null) return null;
    final parts = raw.split(':');
    if (parts.length != 3) return null;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = double.tryParse(parts[2]) ?? 0;
    return Duration(
      hours: hours,
      minutes: minutes,
      milliseconds: (seconds * 1000).round(),
    );
  }

  static int? _int(String? s) => s == null ? null : int.tryParse(s);

  static DateTime? _date(String? s) {
    if (s == null) return null;
    return DateTime.tryParse(s.replaceAll('.', '-'));
  }

  static Uri? _uri(String? s) => s == null ? null : Uri.tryParse(s);

  static DateTime? _combineUtc(String? date, String? time) {
    if (date == null || time == null) return null;
    return DateTime.tryParse('${date.replaceAll('.', '-')}T${time}Z');
  }
}
