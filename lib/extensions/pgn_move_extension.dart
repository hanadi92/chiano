import 'package:chiano/models/pgn_model.dart';
import 'package:chiano/services/mappers/mapper.dart';

extension PgnMoveExtenstion on PgnMove {
  bool get isCheck {
    return san.contains('+');
  }

  bool get isTake {
    return san.contains('x');
  }

  bool get isShortCastle {
    return san == 'O-O';
  }

  bool get isLongCastle {
    return san == 'O-O-O';
  }

  int note(Mapper mapper) {
    return mapper.map(move: this);
  }

  int get velocity {
    if (isTake) {
      return 127;
    }

    // todo to be implemented after introducing stress level
    return 100;
  }
}
