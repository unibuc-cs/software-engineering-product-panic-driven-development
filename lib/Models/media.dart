import "package:mediamaster/Models/media_user.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "platform.dart";
import "publisher.dart";
import "creator.dart";

import "package:flutter/material.dart";

class Media {
  // Data
  int id;
  String originalName;
  String description;
  DateTime releaseDate;
  int criticScore;
  int communityScore;
  String mediaType;

  static const TextStyle textStyle = TextStyle(color: Colors.white);

  Media(
      {this.id = -1,
      required this.originalName,
      required this.description,
      required this.releaseDate,
      required this.criticScore,
      required this.communityScore,
      required this.mediaType});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Media).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "originalname": originalName,
      "description": description,
      "releasedate": releaseDate,
      "criticscore": criticScore,
      "comunityscore": communityScore,
      "mediatype": mediaType,
    };
  }

  factory Media.from(Map<String, dynamic> json) {
    return Media(
      id: json["id"],
      originalName: json["originalname"],
      description: json["description"],
      releaseDate: json["releasedate"],
      criticScore: json["criticscore"],
      communityScore: json["comunityscore"],
      mediaType: json["mediatype"],
    );
  }

  Future<List<Publisher>> get publishers async {
    final supabase = Supabase.instance.client;
    List<dynamic> publisherIds = await supabase
      .from("mediapublisher")
      .select("publisherid")
      .eq("mediaid", id);
    return (await supabase
      .from("publisher")
      .select()
      .inFilter("id", publisherIds))
      .map(Publisher.from)
      .toList();
  }

  Future<List<Creator>> get creators async {
    final supabase = Supabase.instance.client;
    List<dynamic> creatorsIds = await supabase
      .from("mediacreator")
      .select("creatorid")
      .eq("mediaid", id);
    return (await supabase
      .from("creator")
      .select()
      .inFilter("id", creatorsIds))
      .map(Creator.from)
      .toList();
  }

  Future<List<Platform>> get platforms async {
    final supabase = Supabase.instance.client;
    List<dynamic> platformsIds = await supabase
      .from("mediaplatform")
      .select("platformid")
      .eq("mediaid", id);
    return (await supabase
      .from("platform")
      .select()
      .inFilter("id", platformsIds))
      .map(Platform.from)
      .toList();
  }

  // TODO: Make this more general
  Widget getListWidget(String title, List<String> items) {
    final ScrollController scrollController = ScrollController();

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 70.0,
              ),
              child: RawScrollbar(
                controller: scrollController,
                thumbColor: Colors.white,
                radius: const Radius.circular(8.0),
                thickness: 6.0,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.label,
                            color: Colors.white70,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              items[index],
                              style: textStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReleaseDateWidget() {
    if (releaseDate == DateTime(1800)) {
      return getListWidget('Release Date', List.of(["N/A"]));
    }
    return getListWidget('Release Date', List.of([releaseDate.toString().substring(0, 10)]));
  }

  Future<Widget> getPublishersWidget() async {
    var pubs = (await publishers).map((pub) => pub.name).toList();
    return getListWidget('Publisher${pubs.length <= 1 ? "" : "s"}', pubs.isEmpty ? List.of(["N/A"]) : pubs);
  }

  Future<Widget> getCreatorsWidget() async{
    var crts = (await creators).map((crt) => crt.name).toList();
    return getListWidget('Creator${crts.length <= 1 ? "" : "s"}', crts.isEmpty ? List.of(["N/A"]) : crts);
  }

  Future<Widget> getPlatformsWidget() async {
    var plts = (await platforms).map((plt) => plt.name).toList();
    return getListWidget('Platform${plts.length <= 1 ? "" : "s"}', plts.isEmpty ? List.of(["N/A"]) : plts);
  }

  Widget getRatingsWidget() {
    String criticScoreString = "Critic score: ";
    if (criticScore != 0) {
      criticScoreString += criticScore.toString();
    }
    else {
      criticScoreString += "N/A";
    }

    String communityScoreString = "Community score: ";
    if (communityScore != 0) {
      communityScoreString += communityScore.toString();
    }
    else {
      communityScoreString += "N/A";
    }

    return getListWidget('Ratings', List.of([criticScoreString, communityScoreString]));
  }

  // New code here

  Future<MediaUser> getCustomizations() async {
    // TODO: Get the current user's id.
    int userId=TODO HERE;
    return MediaUser.from(await Supabase.instance.client.from("mediauser").select().eq("mediaid", id).eq("userid", userId).single());
  }

  Future<Widget> displayMedia(Widget additionalButtons, Widget notesWidget) async {
    MediaUser customizations = await getCustomizations();
    String imageUrl = "https://${customizations.backgroundImage}";
    String coverUrl = "https://${customizations.coverImage}";

    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.only(
          top: 200,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              imageUrl,
            ),
            alignment: Alignment.topCenter,
          ),
          color: Colors.black,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: const Color.fromARGB(224, 64, 64, 64),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  // Game name;
                  child: Text(
                    customizations.name,
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ),
                additionalButtons,
                // TODO: The following were the buttons. Might be useful when implementing specific types
                /*Row(
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
                          );
                        },
                        icon: const Icon(
                          Icons.access_alarm_outlined,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 32, 32, 32)),
                        ),
                      ),
                    ),
                    Container(
                      // Sys Check button
                      margin: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () {
                          _showSysCheck(game);
                        },
                        icon: const Icon(
                          Icons.monitor,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 32, 32, 32)),
                        ),
                      ),
                    ),
                    Container(
                      // Settings button
                      margin: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () {
                          _showGameSettingsDialog(game);
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 32, 32, 32)),
                        ),
                      ),
                    ),
                    Container(
                      // Settings button
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                        onPressed: () {
                          _showGameRecommendationsDialog(game);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 32, 32, 32)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          overlayColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 32, 32, 32)),
                        ),
                        child: const Text('Similar games'),
                      ),
                    ),
                  ],
                ),*/
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        // Cover
                        margin: const EdgeInsets.all(
                          20,
                        ),
                        child: Image(
                          image: NetworkImage(
                            coverUrl,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        // Description
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          description,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        // Data (publisher, retailer, etc.)
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            getReleaseDateWidget(),
                            await getPublishersWidget(),
                            await getCreatorsWidget(),
                            await getPlatformsWidget(),
                            getRatingsWidget()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                notesWidget,
                // TODO: This might be useful when implementing the library
                /*renderNotes(
                  UserSystem().getUserNotes(
                    game.media,
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}