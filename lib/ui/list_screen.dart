import 'package:flutter/material.dart';

import '../models/game_model.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({required this.gamesFuture, super.key});

  final Future<List<Game>> gamesFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: SafeArea(
        child: FutureBuilder<List<Game>>(
          future: gamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Something went wrong:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final games = snapshot.data ?? const <Game>[];

            if (games.isEmpty) {
              return const Center(child: Text('No results found.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: games.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  key: ValueKey(game.uuid),
                  child: ListTile(
                    title: Text(game.uuid), // todo human readable pgn.date.
                    subtitle: Text('Type: ${game.timeClass} vs ${game.black.username}'),

                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
