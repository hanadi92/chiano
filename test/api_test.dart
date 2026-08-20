import 'package:chiano/models/game_model.dart';
import 'package:chiano/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:chiano/extensions/pgn_move_extension.dart';

void main() {
  test('api called and response parsed into a list of games', () async {
    final realClient = http.Client();
    final apiService = ApiService(realClient);
    final List<Game> result = await apiService.getPGNGamesPerYearMonth(
        username: 'kopiko_o9',
        year: '2026',
        month: '04',
    );

    print('--- LIVE API SERVICE PARSED OUTPUT ---');
    print(result);
    print(result.first.pgn.moves.first.note);
    print('--------------------------------------');

    assert(result.isNotEmpty);
  });
}