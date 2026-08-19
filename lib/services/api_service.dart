import 'dart:convert';

import 'package:chiano/models/game_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  static const String apiUrl = 'https://api.chess.com';

  ApiService(this.client);

  Future<List<Game>> getPGNGamesPerYearMonth({
    required String username,
    required String year,
    required String month,
  }) async {
    // todo handle validation of params in UI input form not here
    final response = await client.get(
      Uri.parse('$apiUrl/pub/player/$username/games/$year/$month'),
    );

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);
        final List<dynamic> gamesListJson = decodedBody['games'] ?? [];

        return gamesListJson
            .map((gameJson) => Game.fromJson(gameJson as Map<String, dynamic>))
            .toList();
      case 404:
        throw Exception('User "$username" or games in $year/$month not found.');

      case 429:
        throw Exception('Rate limited. Please slow down requests.');

      case 500:
      case 503:
        throw Exception('Chess.com servers are currently experiencing issues.');

      default:
        throw Exception('An unexpected error occurred: ${response.statusCode}');
    }
  }
}
