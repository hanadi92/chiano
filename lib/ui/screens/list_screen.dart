import 'package:chiano/ui/components/empty_state.dart';
import 'package:chiano/ui/components/title_bar.dart';
import 'package:flutter/material.dart';

import '../../models/game_model.dart';
import '../components/game_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({required this.gamesFuture, super.key});

  final Future<List<Game>> gamesFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleBar(title: 'Games'),
      body: SafeArea(
        child: FutureBuilder<List<Game>>(
          future: gamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading your games...',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  )
              );
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
              return EmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: games.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final game = games[index];

                return GameCard(game: game);
              },
            );
          },
        ),
      ),
    );
  }
}
