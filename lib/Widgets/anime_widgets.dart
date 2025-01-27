import 'package:flutter/material.dart';
import '../Models/anime.dart';
import 'media_widgets.dart';

// TODO: add specific stuff later
// for now this is exactly as the one for Book, Manga, Movie and TVSeries
// I left them like this because specific stuff will be added
Widget getAdditionalButtonsForAnime(Anime anime, BuildContext context, Function() resetState, bool isWishlist) {
  return Row(
    children: [
      Container(
        // Settings button
        margin: const EdgeInsets.all(10),
        child: IconButton(
          onPressed: () {
            showSettingsDialog(anime, context, resetState, isWishlist);
          },
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 32, 32, 32)
            ),
          ),
        ),
      ),
      Container(
        // Recommendations button
        margin: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: () {
            showRecommendationsDialog(anime, context);
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 32, 32, 32)
            ),
            foregroundColor: WidgetStatePropertyAll(
              Colors.white
            ),
            overlayColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 32, 32, 32)
            ),
          ),
          child: const Text('Similar anime'),
        ),
      ),
    ],
  );
}