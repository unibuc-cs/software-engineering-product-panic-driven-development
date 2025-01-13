import 'package:flutter/material.dart';
import 'package:mediamaster/Models/anime.dart';
import 'package:mediamaster/Models/book.dart';
import 'package:mediamaster/Models/game.dart';
import 'package:mediamaster/Models/manga.dart';
import 'package:mediamaster/Models/general/media_type.dart';
import 'package:mediamaster/Models/movie.dart';
import 'package:mediamaster/Models/tv_series.dart';
import 'package:mediamaster/Services/anime_service.dart';
import 'package:mediamaster/Services/book_service.dart';
import 'package:mediamaster/Services/game_service.dart';
import 'package:mediamaster/Services/genre_service.dart';
import 'package:mediamaster/Services/manga_service.dart';
import 'package:mediamaster/Services/media_service.dart';
import 'package:mediamaster/Services/media_user_genre_service.dart';
import 'package:mediamaster/Services/media_user_service.dart';
import 'package:mediamaster/Services/media_user_tag_service.dart';
import 'package:mediamaster/Services/movie_service.dart';
import 'package:mediamaster/Services/note_service.dart';
import 'package:mediamaster/Services/tag_service.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:mediamaster/Models/note.dart';
import 'package:mediamaster/Services/tv_series_service.dart';
import 'package:mediamaster/Services/wishlist_service.dart';
import 'package:mediamaster/Widgets/game_widgets.dart';
import 'package:mediamaster/Widgets/media_widgets.dart';
import 'package:pair/pair.dart';
import 'dart:async';
import 'Services/provider_service.dart';

import 'Models/genre.dart';
import 'Models/tag.dart';
import 'Models/media.dart';
import 'Models/media_user.dart';

import 'UserSystem.dart';
import 'Main.dart';

class Library<MT extends MediaType> extends StatefulWidget {
  const Library({super.key});

  @override
  LibraryState<MT> createState() => LibraryState<MT>();
}

dynamic getServiceForType(Type type) {
  if (type == Game) {
    return GameService.instance;
  }
  if (type == Book) {
    return BookService.instance;
  }
  if (type == Anime) {
    return AnimeService.instance;
  }
  if (type == Manga) {
    return MangaService.instance;
  }
  if (type == Movie) {
    return MovieService.instance;
  }
  if (type == TVSeries) {
    return TVSeriesService.instance;
  }
  throw UnimplementedError('GetUserMedia of type $type is not implemented!');
}

class LibraryState<MT extends MediaType> extends State<Library> {
  int selectedMediaId = -1;
  String filterQuery = '';
  TextEditingController searchController = TextEditingController();
  bool increasingSorting = true;
  int selectedSortingMethod = 0;
  var mediaOrderComparators = [
    Pair<String, dynamic>(
      'By original name',
      (MT a, MT b, int increasing) async {
        return increasing *
            (await a.media).originalName.compareTo((await b.media).originalName);
      },
    ),
    Pair<String, dynamic>(
      'By critic score',
      (MT a, MT b, int increasing) async {
        return increasing * (await a.media).criticScore.compareTo((await b.media).criticScore);
      },
    ),
    Pair<String, dynamic>(
      'By comunity score',
      (MT a, MT b, int increasing) async {
        return increasing *
            (await a.media).communityScore.compareTo((await b.media).communityScore);
      },
    ),
    Pair<String, dynamic>(
      'By release date',
      (MT a, MT b, int increasing) async {
        return increasing * (await a.media).releaseDate.compareTo((await b.media).releaseDate);
      },
    ),
    if (MT == Game)
      Pair<String, dynamic>(
        'By time to beat',
        (MT a, MT b, int increasing) {
          int ta = getMinTimeToBeat(a as Game);
          int tb = getMinTimeToBeat(b as Game);

          if (tb == -1) {
            return -1;
          }
          if (ta == -1) {
            return 1;
          }
          return increasing * ta.compareTo(tb);
        },
      ),
    if (MT == Game)
      Pair<String, dynamic>(
        'By time to 100%',
        (MT a, MT b, int increasing) {
          if ((b as Game).HLTBCompletionistInSeconds == -1) {
            return -1;
          }
          if ((a as Game).HLTBCompletionistInSeconds == -1) {
            return 1;
          }
          return increasing *
              a.HLTBCompletionistInSeconds.compareTo(
                  b.HLTBCompletionistInSeconds);
        },
      ),
     // TODO: ADD OTHER SORTING METHODS
  ];
  bool filterAll = true;
  Set<Genre> selectedGenresIds = {};
  Set<Tag> selectedTagsIds = {};

  @override
  void initState() {
    super.initState();
  }

  Future<String> getCustomName(MT mt) async {
    return await (await getCustomizations(await mt.media)).name;
  }

  // Create and return a list view of the filtered media
  Future<ListView> mediaListBuilder(BuildContext context) async {
    List<ListTile> listTiles = List.empty(growable: true);
    List<MT> userMedia = UserSystem.instance.getUserMedia(MT).map((x) => x as MT).toList();
    List<Pair<MT, int>> mediaIndices = List.empty(growable: true);

    for (int i = 0; i < userMedia.length; ++i) {
      int id = userMedia.elementAt(i).getMediaId();
      bool shouldAdd = true;
      if (selectedGenresIds.isNotEmpty || selectedTagsIds.isNotEmpty) {
        int conditionsMet = MediaUserTagService
          .instance
          .items
          .where((mut) =>
            mut.mediaId == id &&
            selectedTagsIds.contains(mut.tagId)
          )
          .length +
          MediaUserGenreService
            .instance
            .items
            .where((mug) =>
              mug.mediaId == id &&
              selectedGenresIds.contains(mug.genreId)
            )
            .length;
        if (filterAll) {
          shouldAdd = (selectedGenresIds.length + selectedTagsIds.length == conditionsMet);
        }
        else if (conditionsMet == 0) {
          shouldAdd = false;
        }
      }
      if (shouldAdd) {
        mediaIndices.add(Pair(userMedia.elementAt(i), i));
      }
    }

    mediaIndices.sort((p0, p1) {
      return mediaOrderComparators[selectedSortingMethod].value(
        p0.key,
        p1.key,
        increasingSorting ? 1 : -1,
      );
    });

    Icon leadingIcon = Icon(Icons.abc);
    if (MT == Game) {
      leadingIcon = Icon(Icons.videogame_asset);
    }
    else {
      throw UnimplementedError('Leading Icon for media type not declared.');
    }

    for (int i = 0; i < mediaIndices.length; ++i) {
      final mt = mediaIndices[i].key;
      final idx = mediaIndices[i].value;
      final mediaName = await getCustomName(mt);
      if (filterQuery == '' || mediaName.toLowerCase().contains(filterQuery)) {
        listTiles.add(
          ListTile(
            leading: leadingIcon,
            title: Text(mediaName),
            onTap: () {
              setState(() {
                selectedMediaId = mt.getMediaId();
              });
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(
                  context,
                  idx,
                );
              },
            ),
          ),
        );
      }
    }

    return ListView(
      children: listTiles,
    );
  }

  void _setSearchText() {
    filterQuery = searchController.text.toLowerCase();
  }

  void _clearSearchFilter() {
    filterQuery = '';
  }

  String getMediaTypeDbName() {
    if (MT == Game) {
      return 'game';
    }
    if (MT == Book) {
      return 'book';
    }
    if (MT == Anime) {
      return 'anime';
    }
    if (MT == Manga) {
      return 'manga';
    }
    if (MT == Movie) {
      return 'movie';
    }
    if (MT == TVSeries) {
      return 'tv_series';
    }
    throw UnimplementedError('Media type already in db is not implemented');
  }

  // TODO: Remove year from game name before call.
  MT? mediaAlreadyInDB(String name) {
    String dbName = getMediaTypeDbName();

    // Notat
    List<int> media = MediaService
      .instance
      .items
      .where((media) => media.originalName == name && media.mediaType == dbName)
      .map((media) => media.id)
      .toList();
    
    if (media.isEmpty) {
      return null;
    }

    if (MT == Game) {
      return GameService
        .instance
        .items
        .where((game) => game.mediaId == media.first)
        .first as MT;
    }

    throw UnimplementedError('Media type already in db is not implemented');
  }

  bool mediaAlreadyInWishlist(String name) {
    String dbName = getMediaTypeDbName();

    Map<int, String> mediaId2mediaType = Map.from({});
    MediaService
      .instance
      .items
      .map((media) => mediaId2mediaType[media.id] = media.mediaType);
    return WishlistService
      .instance
      .items
      .where((wish) =>
        wish.name == name &&
        mediaId2mediaType[wish.mediaId] == dbName
      )
      .isNotEmpty;
  }

  bool mediaAlreadyInLibrary(String name) {
    String dbName = getMediaTypeDbName();
    List<Media> media = MediaService
      .instance
      .items
      .where((media) =>
        media.originalName == name &&
        media.mediaType == dbName
      ).toList();

    if (media.isEmpty) {
      return false;
    }

    int id = media.first.id;
    
    return MediaUserService
      .instance
      .items
      .where((mu) => mu.mediaId == id)
      .isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _setSearchText();

    IconButton? butonSearchReset;
    if (filterQuery == '') {
      butonSearchReset = IconButton(
        onPressed: () {
          /*TODO: The search box gets activated only if you hold down at least 2 frames, I do not know the function to activate it when pressing this button. I also do not know if this should be our priority right now*/
        },
        icon: const Icon(Icons.search),
      );
    }
    else {
      butonSearchReset = IconButton(
        onPressed: () {
          setState(() {
            _clearSearchFilter();
            searchController.clear();
          });
        },
        icon: const Icon(Icons.clear),
      );
    }

    String mediaType = '';
    if (MT == Game) {
      mediaType = 'game';
    }
    else {
      throw UnimplementedError('Build not implemented for this media type');
    }

    TextField textField = TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Search $mediaType in library',
        suffixIcon: butonSearchReset,
      ),
    );

    var mediaListWidget = mediaListBuilder(context);
    MT? selectedMT = getSelectedMT();

    // TODO: This might not work because we have a builder within a builder
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediaMaster'),
        actions: [
          TextButton(
            onPressed: () {}, // TODO: profile page
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color.fromARGB(219, 10, 94, 87)),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: Text(UserSystem.instance.currentUserData!['name']),
          ),
          IconButton(
              onPressed: () {
                UserSystem.instance.logout();
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Log out'),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([mediaListWidget, _displayMedia(selectedMT)]),
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showSortMediaDialog(context);
                          },
                          icon: const Icon(Icons.sort),
                          tooltip: 'Sort ${mediaType}s',
                        ),
                        IconButton(
                          onPressed: () {
                            _showFilterMediaDialog(context);
                          },
                          icon: const Icon(Icons.filter_alt),
                          tooltip: 'Filter ${mediaType}s',
                        ),
                        IconButton(
                          onPressed: () {
                            AdaptiveTheme.of(context).mode ==
                                    AdaptiveThemeMode.light
                                ? AdaptiveTheme.of(context).setDark()
                                : AdaptiveTheme.of(context).setLight();
                          },
                          icon: const Icon(Icons.dark_mode),
                          tooltip: 'Toggle dark mode',
                        ),
                        TextButton(
                          onPressed: () { // TODO: Change the button to switch to wishlist
                            // Navigator.pop(context);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => MyWishlist<MT>()
                            //   )
                            // );
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(219, 10, 94, 87)),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                          child: const Text('Wishlist'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: IconButton(
                            onPressed: () {
                              _showSearchMediaDialog(context);
                            },
                            icon: const Icon(Icons.add_circle),
                            tooltip: 'Add $mediaType to library',
                          ),
                        ),
                        Expanded(
                          child: textField,
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    if (snapshot.hasData)
                      Expanded(
                        child: snapshot.data!.first,
                      ),
                  ],
                )
              ),
              if (snapshot.hasData)
                Expanded(
                  flex: 10,
                  child: Container(
                    child: snapshot.data!.elementAt(1),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  MT? getSelectedMT() {
    if (selectedMediaId == -1) {
      return null;
    }

    dynamic service = getServiceForType(MT);

    List<dynamic> mts = service
      .items
      .where((mt) => mt.mediaId == selectedMediaId)
      .toList();
    
    if (mts.isEmpty) {
      return null;
    }
    return mts.first as MT;
  }

  // TODO: FIX THIS FUNCTION
  // TODO: FIX THIS FUNCTION
  Future<void> _showSearchMediaDialog(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    List<dynamic> searchResults = [];

    bool noSearch = true; // Flag to track if there are no search results

    String mediaType = '';
    if (MT == Game) {
      mediaType = 'Game';
    }
    else {
      throw UnimplementedError('Search dialog for this media type is not implemented');
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Search for a Game'),
              content: SizedBox(
                height: noSearch
                    ? 100
                    : 400, // Set height based on the presence of search results
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: '$mediaType Name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            String query = searchController.text;
                            if (query.isNotEmpty) {
                              searchResults = await getOptionsIGDB(query);
                              setState(() {
                                noSearch = searchResults
                                    .isEmpty; // Update noSearch flag
                              }); // Trigger rebuild to show results and update flag
                            }
                          },
                        ),
                      ),
                    ),
                    if (searchResults.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 2),
                              ...searchResults.map((result) {
                                String mediaName = result['name'];

                                if (mediaAlreadyInLibrary(mediaName)) {
                                  return ListTile(
                                    title: Text(mediaName),
                                    subtitle: Text(
                                      '$mediaType is already in library.',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                    ),
                                    onTap: () {
                                      _addGame(result);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                                else if (mediaAlreadyInWishlist(mediaName)) {
                                  return ListTile(
                                    title: Text(mediaName),
                                    subtitle: Text(
                                      '$mediaType is in wishlist.',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                    ),
                                    onTap: () {
                                      _addGame(result);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                                else {
                                  return ListTile(
                                    title: Text(mediaName),
                                    onTap: () {
                                      _addGame(result);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSortMediaDialog(BuildContext context) async {
    // Helper function, should be called when a variable gets changed
    void resetState() {
      setState(() {});
    }

    String mediaType = '';
    if (MT == Game) {
      mediaType = 'games';
    }
    else {
      throw UnimplementedError('Sorting is not implemented for this media type');
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Sort $mediaType'),
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Sort direction',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: increasingSorting,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  increasingSorting = true;
                                  resetState();
                                }
                              });
                            },
                          ),
                          const Text(
                            'Increasing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: !increasingSorting,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  increasingSorting = false;
                                  resetState();
                                }
                              });
                            },
                          ),
                          const Text(
                            'Decreasing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Sort parameter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (int i = 0; i < mediaOrderComparators.length; ++i)
                        Row(
                          children: [
                            Checkbox(
                              value: i == selectedSortingMethod,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedSortingMethod = i;
                                    resetState();
                                  }
                                });
                              },
                            ),
                            Text(
                              mediaOrderComparators[i].key,
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
      });
  }

  Future<void> _showFilterMediaDialog(BuildContext context) async {
    // Helper function, should be called when a variable gets changed
    void resetState() {
      setState(() {});
    }

    String mediaType = '';
    if (MT == Game) {
      mediaType = 'games';
    }
    else {
      throw UnimplementedError('Sorting is not implemented for this media type');
    }

    List<Tag> tags = TagService.instance.items; // TODO: I don't know if we want all tags
    List<Genre> genres = GenreService.instance.items; // TODO: I don't know if we want all genres

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Filter $mediaType'),
              content: SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Filter type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: filterAll,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  filterAll = true;
                                  resetState();
                                }
                              });
                            },
                          ),
                          const Text(
                            'All',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: !filterAll,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  filterAll = false;
                                  resetState();
                                }
                              });
                            },
                          ),
                          const Text(
                            'Any',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Tags',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              selectedTagsIds.clear();
                              resetState();
                            }),
                            icon: const Icon(
                              Icons.clear,
                            ),
                          ),
                        ],
                      ),
                      for (Tag tag in tags)
                        Row(
                          children: [
                            Checkbox(
                              value: selectedTagsIds.contains(tag),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedTagsIds.add(tag);
                                  } else {
                                    selectedTagsIds.remove(tag);
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
                      Row(
                        children: [
                          const Text(
                            'Genres',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              selectedGenresIds.clear();
                              resetState();
                            }),
                            icon: const Icon(
                              Icons.clear,
                            ),
                          ),
                        ],
                      ),
                      for (Genre genre in genres)
                        Row(
                          children: [
                            Checkbox(
                              value: selectedGenresIds.contains(genre),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedGenresIds.add(genre);
                                  } else {
                                    selectedGenresIds.remove(genre);
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
      }
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int mediaId) async {
    String mediaType = '';
    if (MT == Game) {
      mediaType = 'game';
    }
    else {
      throw UnimplementedError('Delete is not implemented for this media type');
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete $mediaType'),
          content: Text('Are you sure you want to delete this $mediaType?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                List<Future<void>> toDo = [];
                MediaUserTagService
                  .instance
                  .items
                  .where((mut) => mut.mediaId == mediaId)
                  .forEach((mut) =>
                    toDo.add(
                      MediaUserTagService
                        .instance
                        .delete([mediaId, mut.tagId])
                    )
                  );
                MediaUserGenreService
                  .instance
                  .items
                  .where((mug) => mug.mediaId == mediaId)
                  .forEach((mug) =>
                    toDo.add(
                      MediaUserGenreService
                        .instance
                        .delete([mediaId, mug.genreId])
                    )
                  );
                toDo.add(MediaUserService.instance.delete(mediaId));
                await Future.wait(toDo);
                setState(() {
                  selectedMediaId = -1; // TODO: Might want to move to some random media instead of this
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // TODO: FIX THIS FUNCTION
  Future<void> _addGame(Map<String, dynamic> result) async {
    if (UserSystem.instance.currentUserData == null) {
      return;
    }

    var selectedGame = await getInfoIGDB(result);
    Map<String, dynamic> gameData = Map.fromEntries(selectedGame.entries);
    gameData['igdbid'] = gameData['id'];
    String name = selectedGame['originalname'];

    if (name[name.length - 1] == ')' && name.length >= 7) {
      name = name.substring(0, name.length - 7);
    }

    Game? nullableGame = mediaAlreadyInDB(name) as Game?;

    if (nullableGame == null) {
      // Get information from PCGamingWiki
      var optionsPCGW = await getOptionsPCGW(name);
      Map<String, dynamic> resultPCGW = {};
      if (optionsPCGW.isNotEmpty) {
        // This is kind of a hack but we will do it legit in the future
        resultPCGW = await getInfoPCGW(optionsPCGW[0]);
      }
      Map<String, dynamic> answersPCGW = {};
      if (resultPCGW.containsKey('windows')) {
        if (resultPCGW['windows'].containsKey('OS')) {
          answersPCGW['OSMinimum'] = resultPCGW['windows']['OS']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          answersPCGW['OSRecommended'] = resultPCGW['windows']['OS']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['osminimum'] = answersPCGW['OSMinimum'];
          gameData['osrecommended'] = answersPCGW['OSRecommended'];
        }
        if (resultPCGW['windows'].containsKey('CPU')) {
          answersPCGW['CPUMinimum'] = resultPCGW['windows']['CPU']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          answersPCGW['CPURecommended'] = resultPCGW['windows']['CPU']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['cpuminimum'] = answersPCGW['CPUMinimum'];
          gameData['cpurecommended'] = answersPCGW['CPURecommended'];
        }
        if (resultPCGW['windows'].containsKey('RAM')) {
          answersPCGW['RAMMinimum'] = resultPCGW['windows']['RAM']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          answersPCGW['RAMRecommended'] = resultPCGW['windows']['RAM']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['ramminimum'] = answersPCGW['RAMMinimum'];
          gameData['ramrecommended'] = answersPCGW['RAMRecommended'];
        }
        if (resultPCGW['windows'].containsKey('HDD')) {
          answersPCGW['HDDMinimum'] = resultPCGW['windows']['HDD']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          answersPCGW['HDDRecommended'] = resultPCGW['windows']['HDD']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['hddminimum'] = answersPCGW['HDDMinimum'];
          gameData['hddrecommended'] = answersPCGW['HDDRecommended'];
        }
        if (resultPCGW['windows'].containsKey('GPU')) {
          answersPCGW['GPUMinimum'] = resultPCGW['windows']['GPU']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          answersPCGW['GPURecommended'] = resultPCGW['windows']['GPU']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['gpuminimum'] = answersPCGW['GPUMinimum'];
          gameData['gpurecommended'] = answersPCGW['GPURecommended'];
        }
      }

      // Get information from HLTB
      var optionsHLTB = await getOptionsHLTB(name);
      Map<String, dynamic> resultHLTB = {};
      if (optionsHLTB.isNotEmpty) {
        // This is kind of a hack but we will do it legit in the future
        resultHLTB = await getInfoHLTB(optionsHLTB[0]);
      }
      Map<String, dynamic> answersHLTB = {};
      if (resultHLTB.containsKey('Main Story')) {
        answersHLTB['Main Story'] = (double.parse(resultHLTB['Main Story'].split(' Hours')[0]) * 3600).round();
        gameData['hltbmaininseconds'] = answersHLTB['Main Story'];
      }
      if (resultHLTB.containsKey('Main + Sides')) {
        answersHLTB['Main + Sides'] = (double.parse(resultHLTB['Main + Sides'].split(' Hours')[0]) * 3600).round();
        gameData['hltbmainsideinseconds'] = answersHLTB['Main + Sides'];
      }
      if (resultHLTB.containsKey('Completionist')) {
        answersHLTB['Completionist'] = (double.parse(resultHLTB['Completionist'].split(' Hours')[0]) * 3600).round();
        gameData['hltbcompletionistinseconds'] = answersHLTB['Completionist'];
      }
      if (resultHLTB.containsKey('All Styles')) {
        answersHLTB['All Styles'] = (double.parse(resultHLTB['All Styles'].split(' Hours')[0]) * 3600).round();
        gameData['hltballstylesinseconds'] = answersHLTB['All Styles'];
      }
      if (resultHLTB.containsKey('Co-Op')) {
        answersHLTB['Co-Op'] = (double.parse(resultHLTB['Co-Op'].split(' Hours')[0]) * 3600).round();
        gameData['hltbcoopinseconds'] = answersHLTB['Co-Op'];
      }
      if (resultHLTB.containsKey('Vs.')) {
        answersHLTB['Vs.'] = (double.parse(resultHLTB['Vs.'].split(' Hours')[0]) * 3600).round();
        gameData['hltbversusinseconds'] = answersHLTB['Vs.'];
      }

      nullableGame = await GameService.instance.create(gameData);
    }

    Game game = nullableGame;

    if (!mediaAlreadyInLibrary(name)) {
      MediaUser mu = MediaUser(
        mediaId: game.mediaId,
        userId: UserSystem.instance.getCurrentUserId(),
        name: name,
        userScore: -1,
        addedDate: DateTime.now(),
        coverImage: selectedGame['coverimage'] ?? '//static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg',
        status: 'Plan To Play',
        series: selectedGame['seriesname'] == null ? name : selectedGame['seriesname'][0],
        icon: selectedGame['coverimage'] ?? '//static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg',
        backgroundImage: selectedGame['artworks'] == null ? '//static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg' : selectedGame['artworks'][0],
        lastInteracted: DateTime.now(),
      );

      await MediaUserService.instance.create(mu);
    }

    setState(() {});
  }

  Future<Widget> _displayMedia(MT? mt) async {
    String mediaType = '';
    Widget additionalButtons = Container();
    if (MT == Game) {
      mediaType = 'game';
    }
    else {
      throw UnimplementedError('Display media for this media type is not implemented');
    }

    if (mt == null) {
      return Container(
        color: Colors.black.withAlpha(128),
        child: Center(
          child: Text(
            'Choose a $mediaType',
            style: const TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        )
      );
    }

    if (MT == Game) {
      additionalButtons = await getAdditionalButtons(mt as Game, context, () {setState(() {});});
    }
    else {
      throw UnimplementedError('Get additional buttons for this media type is not implemented');
    }

    return await displayMedia(
      await mt.media,
      additionalButtons,
      renderNotes(
        NoteService
          .instance
          .items
          .where((note) => note.mediaId == mt.mediaId)
          .toList()
      ),
    );
  }

  Future<void> _showNewStickyDialog(int mediaId) {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New sticky note'),
          content: SizedBox(
            width: 350,
            child: TextFormField(
              controller: controller,
              autocorrect: false,
              minLines: 10,
              maxLines: 10,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Note note = Note(
                  mediaId: mediaId,
                  userId: UserSystem.instance.getCurrentUserId(),
                  content: controller.text,
                  creationDate: DateTime.now(),
                  modifiedDate: DateTime.now(),
                );
                await NoteService.instance.create(note);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget renderStickyNote(Note? note, int mediaId) {
    Widget textToDisplay = const Text(
      '+',
      style: TextStyle(
        fontSize: 70,
        color: Colors.black26,
      ),
    );
    var onClick = () {
      _showNewStickyDialog(mediaId);
    };

    if (note != null) {
      onClick = () {};
      textToDisplay = Text(
        note.content,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black87,
        ),
      );
    }

    void removeNote() async {
      await NoteService.instance.delete((note as Note).id);
      setState(() {});
    }

    return GestureDetector(
      onTap: onClick,
      child: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 216, 216, 151),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: textToDisplay,
            ),
          ),
          if (note != null)
            Positioned(
              right: 20,
              top: 20,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: removeNote,
                color: const Color.fromARGB(255, 192, 0, 0),
              ),
            ),
        ],
      )
    );
  }

  Widget renderNotes(List<Note> notes) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      primary: false,
      children: [
        for (Note note in notes)
          renderStickyNote(note, -1),
        renderStickyNote(null, selectedMediaId),
      ],
    );
  }
}
