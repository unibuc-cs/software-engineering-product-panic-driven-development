import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mediamaster/Library.dart';
import 'package:mediamaster/Services/provider_service.dart';
import 'package:mediamaster/Widgets/themes.dart';
import 'package:url_launcher/link.dart';
import '../Models/game.dart';
import 'media_widgets.dart';

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
                details == '' ? 'N/A' : details,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return SizedBox(
    width: 400,
    child:   Column(
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
    )
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

Widget getAdditionalButtonsForGame(Game game, BuildContext context, Function() resetState, bool isWishlist) {
  return Row(
    children: [
      Container(
        // Play button
        margin: const EdgeInsets.all(10),
        child: TextButton(
          style: greenFillButton(context)
            .filledButtonTheme
            .style,
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
            showSettingsDialog(game, context, resetState, isWishlist);
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
            showRecommendationsDialog(game, context);
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

Future<void> showIGDBImportDialog(BuildContext context, LibraryState<Game> library) {
  TextEditingController controller = TextEditingController();

  bool confirmed    = false; // Flag to track if the choice was confirmed or not.
  bool dataGathered = false; // Flag to track if the data was received from IGDB.
  bool invalidId    = false; // Flag to track if the id was invalid.

  List<Widget> invalidIdWidgets = [
    Text(
      'The ID is invalid',
      style: subtitleStyle,
      textAlign: TextAlign.center,
    ),
    SizedBox(
      height: 20,
    ),
    Icon(
      Icons.sentiment_dissatisfied_rounded,
      size: 50,
    ),
  ];

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          if (confirmed) {
            if (!invalidId) {
              return AlertDialog(
                content: Container(
                  constraints: BoxConstraints(maxHeight: 140),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: loadingWidget(
                            context
                          ),
                        ),
                      ),
                      Text(dataGathered
                          ? 'Creating game in database'
                          : 'Waiting for IGDB to finnish',
                        style: titleStyle,
                      ),
                    ],
                  ),
                ),
              );
            }
            return AlertDialog(
              title: const Text('Invalid ID'),
              content: Column(
                children: invalidIdWidgets,
              ),
            );
          }
          else {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Import game using IGDB ID'),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              content: SizedBox(
                width: 350,
                height: 100,
                child: Column(
                  children: [
                    Link(
                      uri: Uri.parse('https://duckduckgo.com'), // TODO: Replace this with a link to some tutorial on getting the IGDB id.
                      builder: (context, followLink) => RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'How to get IGDB ID',
                              style: TextStyle(
                                color: linkColor,
                                decoration: TextDecoration.underline,
                                fontSize: 22,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = followLink,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Insert IGDB ID',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            String query = controller.text;
                            if (query.isNotEmpty) {
                              confirmed = true;
                              setState(() {});
                              Map<String, dynamic> gameData = {};
                              try {
                                gameData = await getInfoIGDB({'id': query});
                              }
                              catch(e) {
                                invalidId = true;
                                return;
                              }
                              dataGathered = true;
                              setState(() {});
                              var result = await library.createGame(gameData);
                              await library.addToLibraryOrWishlist(
                                result.key,
                                result.value,
                              );
                              Navigator.of(context).pop();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    },
  );
}