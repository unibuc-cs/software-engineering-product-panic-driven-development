import 'package:flutter/material.dart';
import 'package:pair/pair.dart';
import '../Services/media_user_service.dart';
import '../Services/wishlist_service.dart';
import '../Models/game.dart';
import '../Models/media.dart';
import '../Models/media_user.dart';
import '../Models/wishlist.dart';
import '../Models/general/media_type.dart';
import 'game_widgets.dart';

// Auxilliary function for general list widgets (publishers, creators, ...)
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
            style: TextStyle(color: Colors.white).copyWith(
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
                            style: TextStyle(color: Colors.white).copyWith(
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

Widget getReleaseDateWidget(Media media) {
  if (media.releaseDate == DateTime(1800)) {
    return getListWidget('Release Date', List.of(['N/A']));
  }
  return getListWidget('Release Date', List.of([media.releaseDate.toString().substring(0, 10)]));
}

Widget getPublishersWidget(Media media) {
  var pubs = media.publishers.map((pub) => pub.name).toList();
  return getListWidget('Publisher${pubs.length <= 1 ? '' : 's'}', pubs.isEmpty ? List.of(['N/A']) : pubs);
}

Widget getCreatorsWidget(Media media) {
  var crts = media.creators.map((crt) => crt.name).toList();
  return getListWidget('Creator${crts.length <= 1 ? '' : 's'}', crts.isEmpty ? List.of(['N/A']) : crts);
}

Widget getPlatformsWidget(Media media) {
  var plts = media.platforms.map((plt) => plt.name).toList();
  return getListWidget('Platform${plts.length <= 1 ? '' : 's'}', plts.isEmpty ? List.of(['N/A']) : plts);
}

Widget getRatingsWidget(Media media) {
  String criticScoreString = 'Critic score: ';
  if (media.criticScore != 0) {
    criticScoreString += media.criticScore.toString();
  }
  else {
    criticScoreString += 'N/A';
  }

  String communityScoreString = 'Community score: ';
  if (media.communityScore != 0) {
    communityScoreString += media.communityScore.toString();
  }
  else {
    communityScoreString += 'N/A';
  }

  return getListWidget('Ratings', List.of([criticScoreString, communityScoreString]));
}

Pair<MediaUser?, Wishlist?> getCustomizations(Media media, bool isWishlist) {
  if (isWishlist == false) {
    return Pair(
      MediaUserService
        .instance
        .items
        .where((mu) => mu.mediaId == media.id)
        .first,
      null
      );
  }
  else {
    return Pair(
      null,
      WishlistService
        .instance
        .items
        .where((wish) => wish.mediaId == media.id)
        .first
      );
  }
}

Widget displayMedia(Media media, Widget additionalButtons, Widget notesWidget, bool isWishlist) {
  Pair<MediaUser?, Wishlist?> aux = getCustomizations(media, isWishlist);
  dynamic customizations;

  if (aux.value == null) {
    customizations = aux.key;
  }
  else {
    customizations = aux.value;
  }

  String imageUrl = 'https:${customizations.backgroundImage}';
  String coverUrl = 'https:${customizations.coverImage}';

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
                        media.description,
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
                          getReleaseDateWidget(media),
                          getPublishersWidget(media),
                          getCreatorsWidget(media),
                          getPlatformsWidget(media),
                          getRatingsWidget(media),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              notesWidget,
            ],
          ),
        ),
      ),
    ),
  );
}

Widget getAdditionalButtons<MT extends MediaType>(MT mt, BuildContext context, Function() resetState) {
  if (MT == Game) {
    return getAdditionalButtonsForGame(mt as Game, context, resetState);
  }
  throw UnimplementedError('getAdditionalButtons was not defined for this type');
}
