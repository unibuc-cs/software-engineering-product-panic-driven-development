import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pair/pair.dart';
import '../Helpers/getters.dart';
import '../Models/tag.dart';
import '../Models/book.dart';
import '../Models/game.dart';
import '../Models/anime.dart';
import '../Models/manga.dart';
import '../Models/media.dart';
import '../Models/movie.dart';
import '../Models/wishlist.dart';
import '../Models/tv_series.dart';
import '../Models/media_user.dart';
import '../Models/media_user_tag.dart';
import '../Models/general/model.dart';
import '../Models/general/media_type.dart';
import '../Services/wishlist_service.dart';
import '../Services/tag_service.dart';
import '../Services/media_user_service.dart';
import '../Services/media_user_tag_service.dart';
import '../UserSystem.dart';
import 'game_widgets.dart';
import 'book_widgets.dart';
import 'anime_widgets.dart';
import 'manga_widgets.dart';
import 'movie_widgets.dart';
import 'tv_series_widgets.dart';

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
              maxHeight: 85.0,
            ),
            child: Scrollbar(
              controller: scrollController,
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
  if (media.releaseDate == null) {
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

Widget getGenresWidget(Media media) {
  var gens = media.genres.map((gen) => gen.name).toList();
  return getListWidget('Genre${gens.length <= 1 ? '' : 's'}', gens.isEmpty ? List.of(['N/A']) : gens);
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

  // not every link has https:, so first I remove it (when it is the case) and add it manually for all of them
  String imageUrl = 'https:${customizations.backgroundImage.replaceAll('https:', '')}';
  String coverUrl = 'https:${customizations.coverImage.replaceAll('https:', '')}';

  if (media.mediaType == 'movie' || media.mediaType == 'tv_series') {
      imageUrl = 'https://image.tmdb.org/t/p/original${customizations.backgroundImage}';
      coverUrl = 'https://image.tmdb.org/t/p/original${customizations.coverImage}';
  }

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
                // MediaType name;
                child: Text(
                  customizations.name,
                  style: const TextStyle(color: Colors.white, fontSize: 24.0),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          additionalButtons,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // Cover
                                margin: const EdgeInsets.all(
                                  20,
                                ),
                                child: Image(
                                  image: NetworkImage(
                                    coverUrl,
                                  ),
                                  width: 210,
                                  height: 246,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // Description
                                  margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                                  child: Text(
                                    media.description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // Data (publisher, retailer, etc.)
                      constraints: BoxConstraints(
                        maxWidth: 200,
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          getReleaseDateWidget(media),
                          getPublishersWidget(media),
                          getCreatorsWidget(media),
                          getGenresWidget(media),
                          getPlatformsWidget(media),
                          getRatingsWidget(media),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              notesWidget,
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showSettingsDialog<MT extends MediaType>(MT mt, BuildContext context, Function() resetState) async {
  Set<int> mutIds = MediaUserTagService.instance.items.where((mut) => mut.mediaId == mt.getMediaId()).map((mut) => mut.tagId).toSet();

  String mediaType = getMediaTypeDbNameCapitalize(MT);
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('$mediaType settings'),
            content: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      '$mediaType tags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (Tag tag in TagService.instance.items)
                      Row(
                        children: [
                          Checkbox(
                            value: mutIds.contains(tag.id),
                            onChanged: (value) async {
                              MediaUserTag mut = MediaUserTag(
                                mediaId: mt.getMediaId(),
                                userId: UserSystem.instance.getCurrentUserId(),
                                tagId: tag.id,
                              );

                              if (value == true) {
                                await MediaUserTagService.instance.create(mut);
                                mutIds.add(mut.tagId);
                              }
                              else {
                                await MediaUserTagService.instance.delete([mut.mediaId, mut.tagId]);
                                mutIds.remove(mut.tagId);
                              }
                              resetState();
                              setState(() {});
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
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  );
}

Future<void> showRecommendationsDialog<MT extends MediaType>(MT mt, BuildContext context) async {
  var similarEntries = await getRecsForType(MT, (mt as Model).toJson());
  List<Widget> recommendations = [];

  String mediaType = getMediaTypeDbName(MT);
  String mediaTypePlural = getMediaTypeDbNamePlural(MT);

  if (context.mounted) {
    if (similarEntries.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  'Similar $mediaTypePlural',
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
                            'There are no similar $mediaTypePlural for this $mediaType, sorry!',
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

    for (var similarEntry in similarEntries) {
      String name = similarEntry['name'];
      if (name[name.length - 1] == ')' && name.length >= 7) {
        name = name.substring(0, name.length - 7);
      }
      recommendations.add(
        ListTile(
          leading: const Icon(Icons.videogame_asset),
          title: Text(
            similarEntry['name'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: name));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name copied to clipboard')),
              );
            },
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
              title: Text('Similar $mediaTypePlural'),
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

Widget getAdditionalButtons<MT extends MediaType>(MT mt, BuildContext context, Function() resetState) {
  if (MT == Anime) {
    return getAdditionalButtonsForAnime(mt as Anime, context, resetState);
  }
  if (MT == Book) {
    return getAdditionalButtonsForBook(mt as Book, context, resetState);
  }
  if (MT == Game) {
    return getAdditionalButtonsForGame(mt as Game, context, resetState);
  }
  if (MT == Manga) {
    return getAdditionalButtonsForManga(mt as Manga, context, resetState);
  }
  if (MT == Movie) {
    return getAdditionalButtonsForMovie(mt as Movie, context, resetState);
  }
  if (MT == TVSeries) {
    return getAdditionalButtonsForTVSeries(mt as TVSeries, context, resetState);
  }
  throw UnimplementedError('getAdditionalButtons was not defined for this type');
}
