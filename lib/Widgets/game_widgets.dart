import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/tag.dart';
import '../UserSystem.dart';
import '../Models/game.dart';
import '../Models/genre.dart';
import '../Models/media_user_tag.dart';
import '../Models/media_user_genre.dart';
import '../Services/tag_service.dart';
import '../Services/genre_service.dart';
import '../Services/provider_service.dart';
import '../Services/media_user_tag_service.dart';
import '../Services/media_user_genre_service.dart';

int getMinTimeToBeat(Game game) {
  List<int> times = List.from([
    game.HLTBAllStylesInSeconds,
    game.HLTBCompletionistInSeconds,
    game.HLTBCoopInSeconds,
    game.HLTBMainInSeconds,
    game.HLTBMainSideInSeconds,
    game.HLTBVersusInSeconds
  ]);

  return times.reduce(min);
}

Widget renderHLTB(Game game) {
  String formatTime(int timeInSeconds) {
    if (timeInSeconds / (60 * 60) ==  timeInSeconds ~/ (60 * 60)) {
      return '${timeInSeconds ~/ (60 * 60)} hour${timeInSeconds / (60 * 60) > 1 ? 's' : ''}';
    }
    return '${timeInSeconds / (60 * 60)} hour${timeInSeconds / (60 * 60) > 1 ? 's' : ''}';
  }

  Widget formatHLTBRow(String title, int timeInSeconds) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                formatTime(timeInSeconds),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (game.HLTBMainInSeconds > 0)
        formatHLTBRow(
          'Main',
          game.HLTBMainInSeconds,
        ),
      if (game.HLTBMainSideInSeconds > 0)
        formatHLTBRow(
          'Main + Side',
          game.HLTBMainSideInSeconds,
        ),
      if (game.HLTBCompletionistInSeconds > 0)
        formatHLTBRow(
          'Completionist',
          game.HLTBCompletionistInSeconds,
        ),
      if (game.HLTBAllStylesInSeconds > 0)
        formatHLTBRow(
          'All styles',
          game.HLTBAllStylesInSeconds,
        ),
      if (game.HLTBCoopInSeconds > 0)
        formatHLTBRow(
          'Co-op',
          game.HLTBCoopInSeconds,
        ),
      if (game.HLTBVersusInSeconds > 0)
        formatHLTBRow(
          'Versus',
          game.HLTBVersusInSeconds,
        ),
    ],
  );
}

Widget renderPCGW(Game game) {
  Widget formatPCGWRow(String title, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                details,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      formatPCGWRow(
        'OS minimum',
        game.OSMinimum,
      ),
      formatPCGWRow(
        'OS recommended',
        game.OSRecommended,
      ),
      formatPCGWRow(
        'CPU minimum',
        game.CPUMinimum,
      ),
      formatPCGWRow(
        'CPU recommended',
        game.CPURecommended,
      ),
      formatPCGWRow(
        'RAM minimum',
        game.RAMMinimum,
      ),
      formatPCGWRow(
        'RAM recommended',
        game.RAMRecommended,
      ),
      formatPCGWRow(
        'HDD minimum',
        game.HDDMinimum,
      ),
      formatPCGWRow(
        'HDD recommended',
        game.HDDRecommended,
      ),
      formatPCGWRow(
        'GPU minimum',
        game.GPUMinimum,
      ),
      formatPCGWRow(
        'GPU recommended',
        game.GPURecommended,
      ),
    ],
  );
}

// TODO: Don't know if we'll get to implement this function
void playGame(Game game) {
  // TODO: This function gets invoked by the play button. For now, until we integrate Steam/Epic/GOG/whatever this will be empty and the play button will do nothing
}

Future<void> _showHLTBDialog(Game game, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('How long to beat'),
        content: renderHLTB(game),
      );
    },
  );
}

Future<void> _showSysCheck(Game game, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('System requirements'),
        content: renderPCGW(game),
      );
    },
  );
}

Future<void> _showGameSettingsDialog(Game game, BuildContext context, Function() resetState) async {
  Set<int> mutIds = MediaUserTagService.instance.items.where((mut) => mut.mediaId == game.mediaId).map((mut) => mut.tagId).toSet();
  Set<int> mugIds = MediaUserGenreService.instance.items.where((mug) => mug.mediaId == game.mediaId).map((mug) => mug.genreId).toSet();

  return showDialog( // TODO: There is a big chance that none of what I did here works (Builder within Builder)
    context: context,
    builder: (context) {
      return FutureBuilder(
        future: Future.wait([TagService.instance.readAll(), GenreService.instance.readAll()]),
        builder: (context, snapshot) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Game settings'),
                content: SizedBox(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          'Game tags',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (Tag tag in snapshot.data!.first.map((obj) => obj as Tag))
                          Row(
                            children: [
                              Checkbox(
                                value: mutIds.contains(tag.id),
                                onChanged: (value) {
                                  setState(() async {
                                    MediaUserTag mut = MediaUserTag(
                                      mediaId: game.mediaId,
                                      userId: UserSystem.instance.getCurrentUserId(),
                                      tagId: tag.id,
                                    );

                                    if (value == true) {
                                      await MediaUserTagService.instance.create(mut);
                                      mutIds.add(mut.tagId);
                                    }
                                    else {
                                      await MediaUserTagService.instance.delete(mut);
                                      mutIds.remove(mut.tagId);
                                    }
                                    resetState();
                                  });
                                },
                              ),
                              Text(
                                tag.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        const Text(
                          'Game genres',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (Genre genre in snapshot.data!.last.map((obj) => obj as Genre))
                          Row(
                            children: [
                              Checkbox(
                                value: mugIds.contains(genre.id),
                                onChanged: (value) {
                                  setState(() async {
                                    MediaUserGenre mug = MediaUserGenre(
                                      mediaId: game.mediaId,
                                      userId: UserSystem.instance.getCurrentUserId(),
                                      genreId: genre.id,
                                    );

                                    if (value == true) {
                                      await MediaUserGenreService.instance.create(mug);
                                      mugIds.add(mug.genreId);
                                    }
                                    else {
                                      await MediaUserGenreService.instance.delete(mug);
                                      mugIds.remove(mug.genreId);
                                    }
                                    resetState();
                                  });
                                },
                              ),
                              Text(
                                genre.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  );
}

Future<void> _showGameRecommendationsDialog(Game game, BuildContext context) async {
  var similarGames = await getRecsIGDB(game.toJson());
  List<Widget> recommendations = [];

  // TODO: fix similar games
  if (context.mounted) {
    if (similarGames.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return const AlertDialog(
                title: Text(
                  'Similar games',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: 400,
                  width: 300,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.grey,
                            size: 50,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'There are no similar games for this game, sorry!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    for (var similarGame in similarGames) {
      String name = similarGame['name'];
      if (name[name.length - 1] == ')' && name.length >= 7) {
        name = name.substring(0, name.length - 7);
      }
      recommendations.add(
        ListTile(
          leading: const Icon(Icons.videogame_asset),
          title: Text(
            similarGame['name'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: name));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name copied to clipboard')),
              );
            },
            child: const Icon(Icons.copy), // Icon to indicate copying
          ),
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Similar games'),
              content: SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: recommendations,
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}

Widget getAdditionalButtonsForGame(Game game, BuildContext context, Function() resetState) {
  return Row(
    children: [
      Container(
        // Play button
        margin: const EdgeInsets.all(10),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                const WidgetStatePropertyAll(Colors.lightGreen),
            shape:
              const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                ),
              ),
          ),
          onPressed: () {
            playGame(game);
          },
          child: const Column(
            children: [
              Text(
                'Play',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '(currently unavailable)',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      Container(
        // HLTB button
        margin: const EdgeInsets.all(10),
        child: IconButton(
          onPressed: () {
            _showHLTBDialog(
              game,
              context,
            );
          },
          icon: const Icon(
            Icons.access_alarm_outlined,
            color: Colors.white,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              const Color.fromARGB(255, 32, 32, 32)
            ),
          ),
        ),
      ),
      Container(
        // Sys Check button
        margin: const EdgeInsets.all(10),
        child: IconButton(
          onPressed: () {
            _showSysCheck(game, context);
          },
          icon: const Icon(
            Icons.monitor,
            color: Colors.white,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              const Color.fromARGB(255, 32, 32, 32)
            ),
          ),
        ),
      ),
      Container(
        // Settings button
        margin: const EdgeInsets.all(10),
        child: IconButton(
          onPressed: () {
            _showGameSettingsDialog(game, context, resetState);
          },
          // TODO: there is a bug here, if i press the button for God of War a red screen appears for a second
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
            _showGameRecommendationsDialog(game, context);
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
          child: const Text('Similar games'),
        ),
      ),
    ],
  );
}