import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:mediamaster/UserSystem.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "genre.dart";
import "media.dart";
import "media_user_genre.dart";
import "media_user_tag.dart";
import "tag.dart";
import "media_type.dart";
import "../Services/ApiService.dart";

class Game extends MediaType {
  // Data
  int mediaId;
  int id;
  int parentGameId;
  int IGDBId;
  String OSMinimum;
  String OSRecommended;
  String CPUMinimum;
  String CPURecommended;
  String RAMMinimum;
  String RAMRecommended;
  String HDDMinimum;
  String HDDRecommended;
  String GPUMinimum;
  String GPURecommended;
  int HLTBMainInSeconds;
  int HLTBMainSideInSeconds;
  int HLTBCompletionistInSeconds;
  int HLTBAllStylesInSeconds;
  int HLTBCoopInSeconds;
  int HLTBVersusInSeconds;

  Game({
    this.id = -1,
    required this.mediaId,
    this.parentGameId = -1,
    required this.IGDBId,
    required this.OSMinimum,
    required this.OSRecommended,
    required this.CPUMinimum,
    required this.CPURecommended,
    required this.RAMMinimum,
    required this.RAMRecommended,
    required this.HDDMinimum,
    required this.HDDRecommended,
    required this.GPUMinimum,
    required this.GPURecommended,
    this.HLTBMainInSeconds = -1,
    this.HLTBMainSideInSeconds = -1,
    this.HLTBCompletionistInSeconds = -1,
    this.HLTBAllStylesInSeconds = -1,
    this.HLTBCoopInSeconds = -1,
    this.HLTBVersusInSeconds = -1,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Game).id;
  }

  @override
  int getMediaId() {
    return mediaId;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "parentgameid": parentGameId,
      "igdbid": IGDBId,
      "osminimum": OSMinimum,
      "osrecommended": OSRecommended,
      "cpuminimum": CPUMinimum,
      "cpurecommended": CPURecommended,
      "ramminimum": RAMMinimum,
      "ramrecommended": RAMRecommended,
      "hddminimum": HDDMinimum,
      "hddrecommended": HDDRecommended,
      "gpuminimum": GPUMinimum,
      "gpurecommended": GPURecommended,
      "hltbmaininseconds": HLTBMainInSeconds,
      "hltbmainsideinseconds": HLTBMainSideInSeconds,
      "hltbcompletionistinseconds": HLTBCompletionistInSeconds,
      "hltballstylesinseconds": HLTBAllStylesInSeconds,
      "hltbcoopinseconds": HLTBCoopInSeconds,
      "hltbversusinseconds": HLTBVersusInSeconds,
    };
  }

  factory Game.from(Map<String, dynamic> json) {
    return Game(
      id: json["id"],
      mediaId: json["mediaid"],
      parentGameId: json["parentgameid"],
      IGDBId: json["igdbid"],
      OSMinimum: json["osminimum"],
      OSRecommended: json["osrecommended"],
      CPUMinimum: json["cpuminimum"],
      CPURecommended: json["cpurecommended"],
      RAMMinimum: json["ramminimum"],
      RAMRecommended: json["ramrecommended"],
      HDDMinimum: json["hddminimum"],
      HDDRecommended: json["hddrecommended"],
      GPUMinimum: json["gpuminimum"],
      GPURecommended: json["gpurecommended"],
      HLTBMainInSeconds: json["hltbmaininseconds"],
      HLTBMainSideInSeconds: json["hltbmainsideinseconds"],
      HLTBCompletionistInSeconds: json["hltbcompletionistinseconds"],
      HLTBAllStylesInSeconds: json["hltballstylesinseconds"],
      HLTBCoopInSeconds: json["hltbcoopinseconds"],
      HLTBVersusInSeconds: json["hltbversusinseconds"],
    );
  }

  @override
  Future<Media> get media async {
    return Media
      .from(
        await Supabase
          .instance
          .client
          .from("media")
          .select()
          .eq("mediaid", mediaId)
          .single()
      );
  }

  Future<Game?> get parentGame async {
    return Game.from(
      await Supabase
        .instance
        .client
        .from("game")
        .select()
        .eq("gameid", parentGameId)
        .single()
    );
  }

  int getMinTimeToBeat() {
    List<int> times = List.from([
      HLTBAllStylesInSeconds,
      HLTBCompletionistInSeconds,
      HLTBCoopInSeconds,
      HLTBMainInSeconds,
      HLTBMainSideInSeconds,
      HLTBVersusInSeconds
    ]);
    int minTime = -1;

    for (int time in times) {
      if (minTime == -1 || minTime > time) {
        minTime = time;
      }
    }

    return minTime;
  }

  Widget renderHLTB() {
    String formatTime(int timeInSeconds) {
      if (timeInSeconds / (60 * 60) ==  timeInSeconds ~/ (60 * 60)) {
        return "${timeInSeconds ~/ (60 * 60)} hour${timeInSeconds / (60 * 60) > 1 ? 's' : ''}";
      }
      return "${timeInSeconds / (60 * 60)} hour${timeInSeconds / (60 * 60) > 1 ? 's' : ''}";
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
        if (HLTBMainInSeconds > 0)
          formatHLTBRow(
            "Main",
            HLTBMainInSeconds,
          ),
        if (HLTBMainSideInSeconds > 0)
          formatHLTBRow(
            "Main + Side",
            HLTBMainSideInSeconds,
          ),
        if (HLTBCompletionistInSeconds > 0)
          formatHLTBRow(
            "Completionist",
            HLTBCompletionistInSeconds,
          ),
        if (HLTBAllStylesInSeconds > 0)
          formatHLTBRow(
            "All styles",
            HLTBAllStylesInSeconds,
          ),
        if (HLTBCoopInSeconds > 0)
          formatHLTBRow(
            "Co-op",
            HLTBCoopInSeconds,
          ),
        if (HLTBVersusInSeconds > 0)
          formatHLTBRow(
            "Versus",
            HLTBVersusInSeconds,
          ),
      ],
    );
  }

  Widget renderPCGW() {
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
          "OS minimum",
          OSMinimum,
        ),
        formatPCGWRow(
          "OS recommended",
          OSRecommended,
        ),
        formatPCGWRow(
          "CPU minimum",
          CPUMinimum,
        ),
        formatPCGWRow(
          "CPU recommended",
          CPURecommended,
        ),
        formatPCGWRow(
          "RAM minimum",
          RAMMinimum,
        ),
        formatPCGWRow(
          "RAM recommended",
          RAMRecommended,
        ),
        formatPCGWRow(
          "HDD minimum",
          HDDMinimum,
        ),
        formatPCGWRow(
          "HDD recommended",
          HDDRecommended,
        ),
        formatPCGWRow(
          "GPU minimum",
          GPUMinimum,
        ),
        formatPCGWRow(
          "GPU recommended",
          GPURecommended,
        ),
      ],
    );
  }

  // TODO: Don't know if we'll get to implement this function
  static void playGame(Game game) {
    // TODO: This function gets invoked by the play button. For now, until we integrate Steam/Epic/GOG/whatever this will be empty and the play button will do nothing
  }

  static Future<void> _showHLTBDialog(Game game, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('How long to beat'),
          content: game.renderHLTB(),
        );
      },
    );
  }

  static Future<void> _showSysCheck(Game game, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('System requirements'),
          content: game.renderPCGW(),
        );
      },
    );
  }

  // TODO: This function is speciffic to a media type. I don't yet know if we'll keep them in this file
  static Future<void> _showGameSettingsDialog(Game game, BuildContext context, Function() resetState) async {
    // TODO: This is how resetState worked when it was in Library
    // void resetState() {
    //   setState(() {});
    // }

    Set<int> mutIds = await MediaUserTag.getAllFor(game.mediaId, UserSystem().getCurrentUserId()); // TODO: Implemente this so it returns the set of tag ids for which there exist a MediaUserTag with that tagId
    Set<int> mugIds = await MediaUserGenre.getAllFor(game.mediaId, UserSystem().getCurrentUserId()); // TODO: Similar to the one above but with Genre
    
    // https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=use_build_context_synchronously#use_build_context_synchronously
    // If we remove the following if there is a chance that there will be weird crashes and bugs and what not.
    if (context.mounted) {
      return showDialog( // TODO: There is a big chance that none of what I did here works (Builder within Builder)
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: Future.wait([Tag.getAllTags(), Genre.getAllGenres()]),
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
                                          userId: UserSystem().currentUser!.id,
                                          tagId: tag.id,
                                        );

                                        if (value == true) {
                                          // TODO: endpoint
                                          await Supabase.instance.client.from("mediausertag").insert(mut.toSupa());
                                          mutIds.add(mut.tagId);
                                        } else {
                                          // TODO: endpoint
                                          await Supabase.instance.client.from("mediausertag").delete().eq("userid", mut.userId).eq("mediaid", mut.mediaId).eq("tagid", mut.tagId);
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
                                          userId: UserSystem().currentUser!.id,
                                          genreId: genre.id,
                                        );
                                        
                                        if (value == true) {
                                          // TODO: endpoint
                                          await Supabase.instance.client.from("mediausergenre").insert(mug.toSupa());
                                          mugIds.add(mug.genreId);
                                        } else {
                                          // TODO: endpoint
                                          await Supabase.instance.client.from("mediausergenre").delete().eq("userid", mug.userId).eq("mediaid", mug.mediaId).eq("genreid", mug.genreId);
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
  }

  static Future<void> _showGameRecommendationsDialog(Game game, BuildContext context) async {
    // TODO: This is how resetState worked when it was in Library
    // void resetState() {
    //   setState(() {});
    // }

    var similarGames = await getRecsIGDB(game.toSupa());
    List<Widget> recommendations = [];

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

  static Widget getAditionalButtons(Game game, BuildContext context, Function() resetState) {
    return Row(
      children: [
        Container(
          // Play button
          margin: const EdgeInsets.all(10),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor:
                  const WidgetStatePropertyAll(Colors.lightGreen), // TODO: MaterialStateProperty was here before. If something does not look alright then this could be the cause
              shape:
                const WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                  ),
                ), // TODO: MaterialStateProperty was here before. If something does not look alright then this could be the cause
            ),
            onPressed: () {
              playGame(game);
            },
            child: const Column(
              children: [
                Text(
                  "Play",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "(currently unnavailable)",
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
}