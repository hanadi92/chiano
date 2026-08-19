import 'package:chiano/models/pgn_model.dart';
import 'package:flutter/cupertino.dart';

extension PgnMoveExtenstion on PgnMove {
  int get note {
    // notes are 7: A B C D E F G , and their sharps
    // chessboard squares/pieces are 8. pawns are sharp.
    // and the 8th H is an A note. inspired by do re mi fa so la ti do
    bool sharp = san.length == 2 ? true : false;
    switch (san.characters.first) {
        case 'A':
        case 'a':
          // do
          return sharp ? 61 : 60;
      case 'B':
      case 'b':
        // re
        return sharp ? 63 : 62;
      case 'C':
      case 'c':
        // mi
        // mi sharp is physically a fa
        return sharp ? 65 : 64;
      case 'D':
      case 'd':
        // fa
        return sharp ? 66 : 65;
      case 'E':
      case 'e':
        // so
        return sharp ? 68 : 67;
      case 'F':
      case 'f':
        // la
        return sharp ? 70 : 69;
      case 'G':
      case 'g':
        // ti
        // ti sharp is physically a do octa
        return sharp ? 72 : 71;
      case 'H':
      case 'h':
        // do octa
        return 72;
    }

    return 0;
  }
  int get velocity {
    // todo to be implemented after introducing stress level
    return 1;
  }
}
