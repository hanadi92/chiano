import 'dart:math';

import 'package:chiano/extensions/pgn_move_extension.dart';
import 'package:chiano/models/pgn_model.dart';
import 'package:flutter/cupertino.dart';

import 'mapper.dart';

class EndMapper implements Mapper {
  EndMapper();

  @override
  int map({required PgnMove move})
  {
    bool isShortCastle = move.san == 'O-O';
    if (isShortCastle) {
      return 10;
    }
    bool isLongCastle = move.san == 'O-O-O';
    if (isLongCastle) {
      return 117;
    }

    String firstChar = move.san.characters.first;
    bool isSharp = firstChar == firstChar.toLowerCase();
    // String finalSquareChar = move.san.characters.takeLast(move.isCheck ? 3 : 2).first;
    // for now, castle is Rook move
    String piece = isSharp ? 'P' : move.isShortCastle || move.isLongCastle ? 'R' : move.san.characters.first;

    int baseNote = 1; // (15 - 117 notes / 6 pieces) = 17 note range + 6 for range checks
    int min = 1;
    switch (piece) {
      case 'P': // pawns 15 - 32
        min = 15;
        baseNote = min + Random().nextInt((32) - min);
        break;
      case 'R': // rooks 33 - 50
        min = 33;
        baseNote = min + Random().nextInt((50) - min);
        break;
      case 'N': // knights 51 - 68
        min = 51;
        baseNote = min + Random().nextInt((68) - min);
        break;
      case 'B': // bishops 69 - 86
        min = 69;
        baseNote = min + Random().nextInt((86) - min);
        break;
      case 'Q': // queen 87 - 104
        min = 87;
        baseNote = min + Random().nextInt((104) - min);
        break;
      case 'K': // king 105 - 122
        min = 105;
        baseNote = min + Random().nextInt((122) - min);
        break;
    }

    return baseNote;
  }
}
