import 'package:flutter/foundation.dart';

@immutable
class Player {
  final int rating;
  final String result;
  final String id;
  final String username;
  final String uuid;

  const Player({
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
