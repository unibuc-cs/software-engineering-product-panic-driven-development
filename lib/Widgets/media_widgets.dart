import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediamaster/Models/link.dart';
import 'package:mediamaster/Services/anime_service.dart';
import 'package:mediamaster/Services/book_service.dart';
import 'package:mediamaster/Services/link_service.dart';
import 'package:mediamaster/Services/manga_service.dart';
import 'package:mediamaster/Services/media_link_service.dart';
import '../Helpers/getters.dart';
import '../Models/book.dart';
import '../Models/game.dart';
import '../Models/anime.dart';
import '../Models/manga.dart';
import '../Models/media.dart';
import '../Models/movie.dart';
import '../Models/user_tag.dart';
import '../Models/tv_series.dart';
import '../Models/media_user.dart';
import '../Models/media_user_tag.dart';
import '../Models/media_user_source.dart';
import '../Models/general/model.dart';
import '../Models/general/media_type.dart';
import '../Services/user_tag_service.dart';
import '../Services/wishlist_service.dart';
import '../Services/media_user_service.dart';
import '../Services/media_user_source_service.dart';
import '../Services/source_service.dart';
import '../Services/media_user_tag_service.dart';
import '../UserSystem.dart';
import 'game_widgets.dart';
import 'book_widgets.dart';
import 'anime_widgets.dart';
import 'manga_widgets.dart';
import 'movie_widgets.dart';
import 'tv_series_widgets.dart';
import 'themes.dart';

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


Widget getSourcesWidget(Media media) {
  var mus = MediaUserSourceService.instance.items;
  var sources = mus.where((mus) => mus.mediaId == media.id && mus.userId == UserSystem.instance.getCurrentUserId()).toList();
  var sourceIds = sources.map((source) => source.sourceId).toList();
  var allSources = SourceService.instance.items;
  List<String> sourceNames = [];
  for (var id in sourceIds) {
    var source = allSources.firstWhere((s) => s.id == id);
    sourceNames.add(source?.name ?? 'N/A');
  }

  if (sourceNames.isEmpty) {
    sourceNames.add('N/A');
  }

  return getListWidget('Source${sourceNames.length <= 1 ? '' : 's'}', sourceNames);
}

List<String> getAvailableSources(Media media) {
  var sources = SourceService
      .instance
      .items
      .where((source) => source.mediaType == 'all' || source.mediaType == media.mediaType)
      .toList();
  var sourceNames = sources.map((source) => source.name).toList();
  return sourceNames.isEmpty ? ['N/A'] : sourceNames;
}

List<String> getSelectedSources(Media media) {
  var mus = MediaUserSourceService.instance.items;
  var sources = mus.where((mus) => mus.mediaId == media.id && mus.userId == UserSystem.instance.getCurrentUserId()).toList();
  var sourceIds = sources.map((source) => source.sourceId).toList();
  var allSources = SourceService.instance.items;
  List<String> sourceNames = [];

  for (var id in sourceIds) {
    var source = allSources.firstWhere((s) => s.id == id);
    if (source != null) {
      sourceNames.add(source.name);
    }
  }

  return sourceNames;
}


dynamic getCustomizations(int mediaId, bool isWishlist) {
  // TODO: maybe a try catch is required here. Not sure
  if (isWishlist == false) {
    return MediaUserService
      .instance
      .items
      .where((mu) => mu.mediaId == mediaId)
      .first;
  }
  return WishlistService
    .instance
    .items
    .where((wish) => wish.mediaId == mediaId)
    .first;
}

Widget getLinkWidget(int mediaId) {
  Set<int> ids = MediaLinkService
    .instance
    .items
    .where((ml) => ml.mediaId == mediaId)
    .map((ml) => ml.linkId)
    .toSet();

  if (ids.isEmpty) {
    return Container();
  }

  List<Link> links = LinkService
    .instance
    .items
    .where((link) => ids.contains(link.id))
    .toList();

  links.sort((la, lb) => la.name.compareTo(lb.name));

  if (links.isEmpty) {
    return Container();
  }

  return Row(
    children: [
      SizedBox(
        width: 45,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Useful links',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 25,
            ),
          ),
          for (Link link in links)
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 10,
                ),
                SizedBox(
                  width: 7,
                ),
                displayLink(link.href, link.name),
              ],
            ),
        ],
      )
    ],
  );
}

Widget displayMedia(Media media, Widget additionalButtons, Widget notesWidget, bool isWishlist) {
  dynamic customizations = getCustomizations(media.id, isWishlist);

  String imageUrl = customizations.backgroundImage;
  String coverUrl = customizations.coverImage;

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          additionalButtons,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
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
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: getLinkWidget(media.id),
                                  ),
                                ],
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
                          // TODO: display user score and progress
                          getReleaseDateWidget(media),
                          getPublishersWidget(media),
                          getCreatorsWidget(media),
                          getGenresWidget(media),
                          getPlatformsWidget(media),
                          getRatingsWidget(media),
                          getSourcesWidget(media),
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

Future<void> showSettingsDialog<MT extends MediaType>(MT mt, BuildContext context, Function() resetState, bool isWishlist) async {
  Set<int> mutIds = MediaUserTagService
    .instance
    .items
    .where((mut) => mut.mediaId == mt.getMediaId())
    .map((mut) => mut.userTagId)
    .toSet();
  String mediaType            = getMediaTypeDbNameCapitalize(MT);
  String measureUnit          = getMeasureUnitForType(MT);
  String measureAttributeName = getMeasureAttributeNameForType(MT);
  List<String> statusOptions  = getStatusOptionsForType(MT);

  dynamic serviceInstance = isWishlist ? WishlistService.instance : MediaUserService.instance;

  dynamic customizations = getCustomizations(mt.media.id, isWishlist);
  String statusValue = '';
  if (!isWishlist) {
    statusValue = (customizations as MediaUser).status;
  }

  TextEditingController nameController     = TextEditingController(
    text: customizations.name,
  );
  TextEditingController ratingController   = TextEditingController(
    text: customizations.userScore == -1
      ? ''
      : customizations.userScore.toString()
  );
  TextEditingController progressController = TextEditingController(
    text: '',
  );
  TextEditingController newTagController   = TextEditingController(
    text: '',
  );

  int maxProgressValue = 0;

  if (!isWishlist) {
    customizations as MediaUser;
    try {
      String progressString = {
        Anime   : customizations.nrEpisodesSeen,
        Book    : customizations.bookReadPages,
        Game    : customizations.gameTime,
        Manga   : customizations.mangaReadChapters,
        Movie   : customizations.movieSecondsWatched,
        TVSeries: customizations.nrEpisodesSeen,
      }[MT].toString();
      progressController = TextEditingController(
        text: progressString
      );
    }
    catch(e) {
      throw UnimplementedError('Progress for type $MT is not implemented!');
    }

    if (MT == Anime) {
      maxProgressValue = AnimeService
        .instance
        .items
        .where((anime) => anime.mediaId == mt.getMediaId())
        .first
        .nrEpisodes;
    }
    else if (MT == Book) {
      maxProgressValue = BookService
        .instance
        .items
        .where((book) => book.mediaId == mt.getMediaId())
        .first
        .totalPages;
    }
    else if (MT == Game) {
      // Games never end
      maxProgressValue = -1;
    }
    else if (MT == Manga) {
      maxProgressValue = MangaService
        .instance
        .items
        .where((manga) => manga.mediaId == mt.getMediaId())
        .first
        .totalPages;
    }
    else if (MT == Movie) {
      maxProgressValue = -1;
      // Who tf updates the movie watch time during the movie?
    }
    else if (MT == TVSeries) {
      throw UnimplementedError('Number of episodes for TV Series is not implemented yet');
      // maxProgressValue = TVSeriesService
      //   .instance
      //   .items
      //   .where((series) => series.mediaId == mt.getMediaId())
      //   .first
      //   .
    }
    else {
      throw UnimplementedError('Tracking not implemented for this media type');
    }
  }
  
  return showDialog(
    context: context,
    builder: (context) {
      List<String> sources = getAvailableSources(mt.media);
      List<String> selectedSources = getSelectedSources(mt.media); 

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
       
          void setFullState() {
            resetState();
            setState(() {});
          };

          return AlertDialog(
            title: Text('$mediaType settings'),
            content: SizedBox(
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Custom name',
                      style: titleStyle,
                    ),
                    TextField( // Custom name
                      controller: nameController,
                      maxLength: 64,
                      decoration: InputDecoration(
                        labelText: 'Enter a custom name',
                        suffixIcon: IconButton(
                          icon: saveIcon(context),
                          onPressed: () async {
                            await serviceInstance
                              .update(
                                customizations.mediaId,
                                {'name' : nameController
                                  .text
                                  .trim(),
                                },
                              );
                            setFullState();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Personal rating',
                      style: titleStyle,
                    ),
                    TextField(  // Custom rating
                      controller: ratingController,
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: 'Enter your rating (out of 100)',
                        suffixIcon: IconButton(
                          icon: saveIcon(context),
                          onPressed: () async {
                            int score = int.parse(ratingController.text);
                            if (score >= 0 && score <= 100) {
                              await serviceInstance
                                .update(customizations.mediaId, {
                                  'userscore' : score,
                                }
                              );
                              setFullState();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (!isWishlist)
                      Column(
                        children: [
                          Text(
                            maxProgressValue <= 0
                              ? 'Update progress'
                              : 'Update progress (out of $maxProgressValue)',
                            style: titleStyle,
                          ),
                          TextField(  // Progress
                            controller: progressController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: 'Update your progress ($measureUnit)',
                              suffixIcon: IconButton(
                                icon: saveIcon(context),
                                onPressed: () async {
                                  int    progressValue = int.parse(progressController.text);
                                  if (progressValue < 0) {
                                    return;
                                  }
                                  if (maxProgressValue > -1 && progressValue > maxProgressValue) {
                                    return;
                                  }

                                  await serviceInstance
                                    .update(
                                      customizations.mediaId,
                                      {measureAttributeName: progressValue},
                                    );
                                  setFullState();
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$mediaType status',
                            style: titleStyle,
                          ),
                          for (String status in statusOptions)
                            Row(
                              children: [
                                Radio(
                                  value: status,
                                  groupValue: statusValue,
                                  onChanged: (_) async {
                                    statusValue = status;
                                    await MediaUserService
                                      .instance
                                      .update(mt.getMediaId(), {
                                        'status': status,
                                      }
                                    );
                                    setFullState();
                                  },
                                ),
                                Text(
                                  status,
                                  style: subtitleStyle,
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    Text(
                      '$mediaType tags',
                      style: titleStyle,
                    ),
                    for (UserTag userTag in UserTagService.instance.items)
                      Row(
                        children: [
                          Checkbox(
                            value: mutIds.contains(userTag.id),
                            onChanged: (value) async {
                              MediaUserTag mut = MediaUserTag(
                                mediaId  : mt.getMediaId(),
                                userId   : UserSystem.instance.getCurrentUserId(),
                                userTagId: userTag.id,
                              );

                              if (value == true) {
                                await MediaUserTagService.instance.create(mut);
                                mutIds.add(mut.userTagId);
                              }
                              else {
                                await MediaUserTagService.instance.delete([mut.mediaId, mut.userTagId]);
                                mutIds.remove(mut.userTagId);
                              }
                              setFullState();
                            },
                          ),
                          Text(
                            userTag.name,
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    TextField(
                      controller: newTagController,
                      maxLength: 32,
                      decoration: InputDecoration(
                        labelText: 'Make a new $mediaType tag',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            String tagName = newTagController.text;
                            bool prezentAlready = UserTagService
                              .instance
                              .items
                              .where((userTag) => userTag.name == tagName)
                              .length != 0;
                            if (prezentAlready) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$tagName already exists')),
                              );
                            }
                            else {
                              UserTag userTag = UserTag(
                                userId: UserSystem.instance.getCurrentUserId(),
                                name: tagName,
                                mediaType: getMediaTypeDbName(MT),
                              );
                              await UserTagService
                                .instance
                                .create(userTag);
                            }
                            setFullState();
                          },
                        ),
                      ),
                    ),

                    Text('Edit Sources', style: titleStyle),
                  ...sources.map((source) {
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedSources.contains(source), 
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                if (!selectedSources.contains(source)) {
                                  selectedSources.add(source); 
                                  print(selectedSources);
                                }
                              } else {
                                selectedSources.remove(source); 
                              }
                            });
                          },
                        ),
                        Text(source, style: subtitleStyle),
                      ],
                    );
                  }).toList(),
                  ],
                ),
              ),
            ),
            actions: [
            TextButton(
              onPressed: () async {
                List<String> existingSources = getSelectedSources(mt.media);
                var sourcesToAdd = selectedSources.where((s) => !existingSources.contains(s)).toList();
                var sourcesToRemove = existingSources.where((s) => !selectedSources.contains(s)).toList();

                for (var sourceName in sourcesToAdd) {
                   var source = SourceService.instance.items.firstWhere((s) => s.name == sourceName);
                   if (source != null) {
                   var mus = MediaUserSource(
                      mediaId: mt.getMediaId(),
                      userId: UserSystem.instance.getCurrentUserId(),
                      sourceId: source.id,
                    );
                    await MediaUserSourceService.instance.create(mus);
                  }
                }

                for (var sourceName in sourcesToRemove) {
                  var source = SourceService.instance.items.firstWhere((s) => s.name == sourceName);
                  if (source != null) {
                    await MediaUserSourceService.instance.delete([mt.getMediaId(), source.id]);
                  }
                }

              },
              child: Text("Save Sources"),
            ),
          ],
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

// TODO: refactoring
Widget getAdditionalButtons<MT extends MediaType>(MT mt, BuildContext context, Function() resetState, bool isWishlist) {
  if (MT == Anime) {
    return getAdditionalButtonsForAnime(mt as Anime, context, resetState, isWishlist);
  }
  if (MT == Book) {
    return getAdditionalButtonsForBook(mt as Book, context, resetState, isWishlist);
  }
  if (MT == Game) {
    return getAdditionalButtonsForGame(mt as Game, context, resetState, isWishlist);
  }
  if (MT == Manga) {
    return getAdditionalButtonsForManga(mt as Manga, context, resetState, isWishlist);
  }
  if (MT == Movie) {
    return getAdditionalButtonsForMovie(mt as Movie, context, resetState, isWishlist);
  }
  if (MT == TVSeries) {
    return getAdditionalButtonsForTVSeries(mt as TVSeries, context, resetState, isWishlist);
  }
  throw UnimplementedError('getAdditionalButtons was not defined for this type');
}
