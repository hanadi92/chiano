import '../../models/pgn_model.dart';

abstract class Mapper {
  int map({required PgnMove move});
}
