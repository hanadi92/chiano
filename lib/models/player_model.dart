// lib/models/player_model.dart
class Player {
  final int rating; // 1385
  final String result; // "win"
  final String id; //  "https://api.chess.com/pub/player/bayusi2"
  final String username; // "Bayusi2"
  final String uuid; // "709aedf4-3be9-11eb-8d15-293845ac82c0"

  Player({
    required this.rating,
    required this.result,
    required this.id,
    required this.username,
    required this.uuid,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'rating': int rating,
        'result': String result,
        '@id': String id,
        'username': String username,
        'uuid': String uuid,
      } =>
        Player(
          rating: rating,
          result: result,
          id: id,
          username: username,
          uuid: uuid,
        ),
      _ => throw const FormatException('Failed to load player structure'),
    };
  }
}
