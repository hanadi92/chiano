import 'package:chiano/models/pgn_model.dart';
import 'package:flutter/cupertino.dart';

extension PgnMoveExtenstion on PgnMove {
  bool get isCheck {
    return san.contains('+');
  }
  bool get isTake {
    return san.contains('x');
  }

  int get note {
    // notes are 7: A B C D E F G , and their sharps
    // chessboard squares/pieces are 8. pawns are sharp.
    // and the 8th H is an A note. inspired by do re mi fa so la ti do
    String firstChar = san.characters.first;

    bool isShortCastle = san == 'O-O';
    if (isShortCastle) {
      return 72;
    }
    bool isLongCastle = san == 'O-O-O';
    if (isLongCastle) {
      return 61;
    }

    bool isSharp = firstChar == firstChar.toLowerCase();
    String finalSquareChar = san.characters.takeLast(isCheck ? 3 : 2).first;
    switch (finalSquareChar) {
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
  int get velocity {
    if (isTake) {
      return 127;
    }

    // todo to be implemented after introducing stress level
    return 100;
  }
}
