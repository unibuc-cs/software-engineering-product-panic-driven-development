import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "media.dart";
import "media_type.dart";

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
}