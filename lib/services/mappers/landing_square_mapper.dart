import 'dart:math';

import 'package:chiano/extensions/pgn_move_extension.dart';
import 'package:chiano/models/pgn_model.dart';
import 'package:flutter/cupertino.dart';

import 'mapper.dart';

class PieceBasedMapper implements Mapper {
  PieceBasedMapper();

  @override
  int map({required PgnMove move})
  {
    String firstChar = move.san.characters.first;
    bool isSharp = firstChar == firstChar.toLowerCase();
    // String finalSquareChar = move.san.characters.takeLast(move.isCheck ? 3 : 2).first;
    // for now, castle is Rook move
    String piece = isSharp ? 'P' : move.isShortCastle || move.isLongCastle ? 'R' : move.san.characters.first;
    int baseNote = 1;
    int min = 1;
    switch (piece) {
      case 'K': // king is rare to play so keep note at edge
        min = 50;
        baseNote = min + Random().nextInt((54) - min);
        break;
      case 'N':
        min = 55;
        baseNote = min + Random().nextInt((59) - min);
        break;
      case 'P': // pawn is often to play
        min = 60;
        baseNote = min + Random().nextInt((64) - min);
        break;
      case 'B': // bishops 69 - 86
        min = 65;
        baseNote = min + Random().nextInt((69) - min);
        break;
      case 'Q': // queen 87 - 104
        min = 70;
        baseNote = min + Random().nextInt((74) - min);
        break;
      case 'R': // rook is rare to play so keep note at edge
        min = 75;
        baseNote = min + Random().nextInt((80) - min);
        break;
    }

    return baseNote;
  }
}
