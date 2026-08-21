import 'package:chiano/extensions/pgn_move_extension.dart';
import 'package:chiano/models/pgn_model.dart';
import 'package:flutter/cupertino.dart';

import 'mapper.dart';

class LandingSquareMapper implements Mapper {
  LandingSquareMapper();

  /*
    notes are 7: A B C D E F G , and their sharps
      chessboard squares/pieces are 8. pawns are sharp.
      and the 8th H is an A note. inspired by do re mi fa so la ti do
   */
  @override
  int map({required PgnMove move})
  {
    String firstChar = move.san.characters.first;

    if (move.isShortCastle) {
      return 72;
    }
    if (move.isLongCastle) {
      return 61;
    }

    bool isSharp = firstChar == firstChar.toLowerCase();
    String landingSquareChar = move.san.characters.takeLast(move.isCheck ? 3 : 2).first;
    switch (landingSquareChar) {
      case 'a':
      // do
        return isSharp ? 61 : 60;
      case 'b':
      // re
        return isSharp ? 63 : 62;
      case 'c':
      // mi
      // mi sharp is physically a fa
        return isSharp ? 65 : 64;
      case 'd':
      // fa
        return isSharp ? 66 : 65;
      case 'e':
      // so
        return isSharp ? 68 : 67;
      case 'f':
      // la
        return isSharp ? 70 : 69;
      case 'g':
      // ti
      // ti sharp is physically a do octa
        return isSharp ? 72 : 71;
      case 'h':
      // do octa
        return 72;
    }

    return 0;
  }
}
