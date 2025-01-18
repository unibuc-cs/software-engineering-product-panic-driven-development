import 'package:flutter/material.dart';
import '../Models/manga.dart';
import 'media_widgets.dart';

// TODO: add specific stuff later
// for now this is exactly as the one for Anime, Book, Movie and TVSeries
// I left them like this because specific stuff will be added
Widget getAdditionalButtonsForManga(Manga manga, BuildContext context, Function() resetState) {
  return Row(
    children: [
      Container(
        // Settings button
        margin: const EdgeInsets.all(10),
        child: IconButton(
          onPressed: () {
            showSettingsDialog(manga, context, resetState);
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
        // Settings button
        margin: const EdgeInsets.all(10),
        child: TextButton(
          onPressed: () {
            showRecommendationsDialog(manga, context);
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
          child: const Text('Similar manga'),
        ),
      ),
    ],
  );
}