import 'dart:async';
import 'package:mediamaster/Widgets/themes.dart';
import 'package:pair/pair.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'Helpers/getters.dart';
import 'Helpers/steam_import.dart';
import 'Models/user_tag.dart';
import 'Models/book.dart';
import 'Models/game.dart';
import 'Models/note.dart';
import 'Models/manga.dart';
import 'Models/movie.dart';
import 'Models/anime.dart';
import 'Models/genre.dart';
import 'Models/media.dart';
import 'Models/wishlist.dart';
import 'Models/tv_series.dart';
import 'Models/media_user.dart';
import 'Models/general/media_type.dart';
import 'Services/game_service.dart';
import 'Services/note_service.dart';
import 'Services/genre_service.dart';
import 'Services/media_service.dart';
import 'Services/provider_service.dart';
import 'Services/user_tag_service.dart';
import 'Services/wishlist_service.dart';
import 'Services/media_user_service.dart';
import 'Services/media_user_tag_service.dart';
import 'Services/media_genre_service.dart';
import 'Widgets/game_widgets.dart';
import 'Widgets/media_widgets.dart';

import 'Main.dart';
import 'UserSystem.dart';

class Library<MT extends MediaType> extends StatefulWidget {
  late final bool isWishlist;
  Library({super.key, required this.isWishlist});

  @override
  LibraryState<MT> createState() => LibraryState<MT>(isWishlist: isWishlist);
}

class LibraryState<MT extends MediaType> extends State<Library> {
  late final isWishlist;
  
  int selectedMediaId = -1;
  
  TextEditingController searchController = TextEditingController();
  String searchFilterQuery = '';
  
  bool increasingSorting = true;
  String selectedSortingMethod = 'By original name';
  Map<String, dynamic> mediaOrderComparators = {
    'By original name': (MT a, MT b, int increasing) {
      return increasing * a.media.originalName.compareTo(b.media.originalName);
    },
    'By given name': null, // TODO: This cannot be set before the constructor is called as member functions are needed. A workaround is to just add it in the constructor
    'By given rating': null, // TODO: This cannot be set before the constructor is called as member functions are needed. A workaround is to just add it in the constructor
    'By critic score': (MT a, MT b, int increasing) {
      return increasing * a.media.criticScore.compareTo(b.media.criticScore);
    },
    'By comunity score': (MT a, MT b, int increasing) {
      return increasing * a.media.communityScore.compareTo(b.media.communityScore);
    },
    'By release date': (MT a, MT b, int increasing) {
      if (a.media.releaseDate == null && b.media.releaseDate == null) {
        return false;
      }
      if (a.media.releaseDate == null) {
        return increasing;
      }
      if (b.media.releaseDate == null) {
        return -increasing;
      }
      return increasing * a.media.releaseDate!.compareTo(b.media.releaseDate!);
    },
    if (MT == Game)
      'By time to beat': (MT a, MT b, int increasing) {
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
    if (MT == Game)
      'By time to 100%': (MT a, MT b, int increasing) {
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
     // TODO: ADD OTHER SORTING METHODS
  };
  
  bool filterAll = true;
  Set<int> selectedGenresIds = {};
  Set<int> selectedTagsIds   = {};

  String get nameLW    => isWishlist ? 'wishlist' : 'library';
  String get nameLWCap => isWishlist ? 'Wishlist' : 'Library';

  String getCustomName(int mediaId) {
    return getCustomizations(mediaId, isWishlist).name;
  }

  int getCustomRating(int mediaId) {
    return getCustomizations(mediaId, isWishlist).userScore;
  }

  Widget getCustomIcon(MT mt) {
    String iconUrl = getCustomizations(mt.media.id, isWishlist).icon;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            iconUrl,
          ),
        ),
      ),
    );
  }

  void _setSearchText() {
    searchFilterQuery = searchController.text.toLowerCase();
  }

  void _clearSearchFilter() {
    searchFilterQuery = '';
  }

  @override
  LibraryState({required this.isWishlist}) {
    // TODO: This cannot be set before the constructor as member functions are required
    mediaOrderComparators['By given name'] = (MT a, MT b, int increasing) {
      return increasing * getCustomName(a.media.id).compareTo(getCustomName(b.media.id));
    };
    // TODO: This cannot be set before the constructor as member functions are required
    mediaOrderComparators['By given rating'] = (MT a, MT b, int increasing) {
      return increasing * getCustomRating(a.media.id).compareTo(getCustomRating(b.media.id));
    };
  }

  @override
  void initState() {
    super.initState();
  }
  
  // Create and return a list view of the filtered media
  ListView _mediaListBuilder(BuildContext context) {
    List<ListTile> listTiles = List.empty(growable: true);
    List<Pair<MT, int>> mediaIndices = List.empty(growable: true);
    List<MT> entries = getAllFromService(MT, isWishlist == false ? 'MediaUser': 'Wishlist')
      .map((x) => x as MT)
      .toList();

    for (int i = 0; i < entries.length; ++i) {
      int id = entries.elementAt(i).getMediaId();
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
          MediaGenreService
            .instance
            .items
            .where((mg) =>
              mg.mediaId == id &&
              selectedGenresIds.contains(mg.genreId)
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
        mediaIndices.add(Pair(entries.elementAt(i), i));
      }
    }

    mediaIndices.sort((p0, p1) {
      return mediaOrderComparators[selectedSortingMethod](
        p0.key,
        p1.key,
        increasingSorting ? 1 : -1,
      );
    });

    for (int i = 0; i < mediaIndices.length; ++i) {
      final mt = mediaIndices[i].key;
      final mediaName = getCustomName(mt.media.id);
      if (searchFilterQuery == '' || mediaName.toLowerCase().contains(searchFilterQuery)) {
        final customIcon = getCustomIcon(mt);
        listTiles.add(
          ListTile(
            leading: customIcon,
            title: Text(mediaName),
            onTap: () {
              setState(() {
                selectedMediaId = mt.getMediaId();
              });
            },
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              onPressed: () {
                _showDeleteConfirmationDialog(
                  context,
                  mt.getMediaId(),
                );
              },
              style: redNotFilledButton(context)
                .filledButtonTheme
                .style,
            ),
          ),
        );
      }
    }

    return ListView(
      children: listTiles,
    );
  }

  MT? mediaAlreadyInDB(String originalName) {
    String dbTypeName = getMediaTypeDbName(MT);

    // Notat
    List<int> mediaIds = MediaService
      .instance
      .items
      .where((media) =>
        media.originalName == originalName &&
        media.mediaType == dbTypeName
      )
      .map((media) => media.id)
      .toList();
    
    if (mediaIds.isEmpty) {
      return null;
    }

    dynamic serviceInstance;
    try {
      serviceInstance = getServiceInstanceForType(MT);
    }
    catch (err) {
      throw UnimplementedError('Media type already in db is not implemented, because of $err');
    }

    // TODO: Sometimes there is an error with the database and things get created only as Media but not MediaType (or at least that is what the local version has)
    List<dynamic> mts = serviceInstance
      .items
      .where((entry) => entry.mediaId == mediaIds.first)
      .toList();
    if (mts.isEmpty) {
      // The error occured. The reasons why this happened can be many. I will for now just leave it at nothing
      return null;
    }

    return mts.first as MT;
  }

  bool mediaAlreadyInWishlist(String originalName) {
    String dbTypeName = getMediaTypeDbName(MT);

    Set<int> mediaIds = MediaService
      .instance
      .items
      .where((media) =>
        media.originalName == originalName &&
        dbTypeName == media.mediaType
      )
      .map((media) => media.id)
      .toSet();

    return WishlistService
      .instance
      .items
      .where((wish) =>
        mediaIds.contains(wish.mediaId)
      )
      .isNotEmpty;
  }

  bool mediaAlreadyInLibrary(String originalName) {
    String dbTypeName = getMediaTypeDbName(MT);
    List<Media> medias = MediaService
      .instance
      .items
      .where((media) =>
        media.originalName == originalName &&
        media.mediaType == dbTypeName
      )
      .toList();

    if (medias.isEmpty) {
      return false;
    }

    int id = medias.first.id;
    
    return MediaUserService
      .instance
      .items
      .where((mu) => mu.mediaId == id)
      .isNotEmpty;
  }

  MT? getSelectedMT() {
    if (selectedMediaId == -1) {
      return null;
    }

    dynamic serviceInstance = getServiceInstanceForType(MT);

    List<dynamic> mts = serviceInstance
      .items
      .where((mt) => mt.mediaId == selectedMediaId)
      .map((mt) => mt as MT)
      .toList();
    
    if (mts.isEmpty) {
      selectedMediaId = -1;
      return null;
    }
    return mts.first as MT;
  }

  @override
  Widget build(BuildContext context) {
    _setSearchText();

    IconButton? butonSearchReset;
    if (searchFilterQuery == '') {
      butonSearchReset = IconButton(
        onPressed: () {
          /*TODO: The search box gets activated only if you hold down at least 2 frames, 
          I do not know the function to activate it when pressing this button. 
          I also do not know if this should be our priority right now*/
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

    String oppositeLibraryWishlistBig = isWishlist ? 'Library' : 'Wishlist';

    TextField textField = TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Search ${getForType(MT, 'dbName')} in $nameLW',
        suffixIcon: butonSearchReset,
      ),
    );

    var mediaListWidget = _mediaListBuilder(context);
    MT? selectedMT = getSelectedMT();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Text('${getMediaTypeDbNameCapitalize(MT)} $nameLWCap'),
              SizedBox(
                width: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Library<MT>(
                        isWishlist: !isWishlist,
                      ),
                    ),
                  );
                },
                style: navigationButton(context)
                  .filledButtonTheme
                  .style,
                child: Text('Switch to $oppositeLibraryWishlistBig'),
              ),
            ],
          ),
        ),
        
        
        actions: [
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
            onPressed: () {}, // TODO: profile page
            style: navigationButton(context)
              .filledButtonTheme
              .style,
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
      body: Row(
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
                      tooltip: 'Sort ${getForType(MT, "dbNamePlural")}',
                    ),
                    IconButton(
                      onPressed: () {
                        _showFilterMediaDialog(context);
                      },
                      icon: const Icon(Icons.filter_alt),
                      tooltip: 'Filter ${getForType(MT, "dbNamePlural")}',
                    ),
                    if (!isWishlist && MT == Game) // Steam import button
                      IconButton(
                        onPressed: () async {
                          await importSteam(context, this);
                        },
                        icon: Icon(
                          Icons.library_add_outlined,
                        ),
                        tooltip: 'Import from Steam',
                      ),
                    if (MT == Game) // IGDB import button
                      IconButton(
                        onPressed: () {
                          showIGDBImportDialog(context, this as LibraryState<Game>);
                        },
                        icon: const Icon(Icons.add_link),
                        tooltip: 'Add game using IGDB id',
                      ),
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
                        tooltip: 'Add ${getForType(MT, "dbName")} to $nameLW',
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: mediaListWidget,
                ),
              ],
            )
          ),
          Expanded(
            flex: 10,
            child: Container(
              child: _displayMedia(selectedMT),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSearchMediaDialog(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<dynamic> searchResults = [];

    bool noSearchResults = true; // Flag to track if there are no search results

    String mediaType = '';
    try {
      mediaType = getMediaTypeDbNameCapitalize(MT);
    }
    catch (err) {
      throw UnimplementedError('Search dialog for this media type is not implemented, because of $err');
    }

    bool isChosen = false;
    bool searchMade = false; // Flag to track if there was a search made or not.

    List<Widget> noResultsWidgets = [
      Text(
        'There are no results that match the search',
        style: TextStyle(
          fontSize: 16,
        ),
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
            if (isChosen) {
              return AlertDialog(
                content: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: loadingWidget(
                      context
                    ),
                  ),
                ),
              );
            }
            else {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Search for a ${mediaType.toLowerCase()}'),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: 350,
                  height: searchMade
                      ? (noSearchResults
                        ? 170
                        : 400)
                      : 100, // Set height based on the presence of search results
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: '$mediaType name',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () async {
                              String query = searchController.text;
                              if (query.isNotEmpty) {
                                searchResults = await getOptionsForType(MT, query);
                                if (context.mounted) {
                                  setState(() {
                                    searchMade = true;
                                    noSearchResults = searchResults
                                      .isEmpty; // Update noSearchResults flag
                                  }); // Trigger rebuild to show results and update flag
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              if (searchMade && noSearchResults)
                                ...noResultsWidgets,
                              ...searchResults.map((result) {
                                String mediaName = result['name'];

                                if (mediaAlreadyInLibrary(mediaName)) {
                                  return ListTile(
                                    title: Text(mediaName),
                                    subtitle: Text(
                                      '$mediaType is already in library.',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 220, 20, 20),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      // _addMediaType(result);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                                else if (mediaAlreadyInWishlist(mediaName)) {
                                  return ListTile(
                                    title: Text(mediaName),
                                    subtitle: Text(
                                      '$mediaType is already in wishlist (will get moved over here).',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                    ),
                                    onTap: () async {
                                      isChosen = true;
                                      setState(() {});
                                      try {
                                        await addMediaType(result);
                                      }
                                      catch(e) {
                                        print(e);
                                      }
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  );
                                }
                                else {
                                  return ListTile(
                                    title: Text(mediaName),
                                    onTap: () async {
                                      isChosen = true;
                                      setState(() {});
                                      try {
                                        await addMediaType(result);
                                      }
                                      catch(e) {
                                        print(e);
                                      }
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
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
            }
          },
        );
      },
    );
  }

  Future<void> _showSortMediaDialog(BuildContext context) {
    // Helper function, should be called when rendering is to be remade
    void resetGlobalState() {
      setState(() {});
    }

    String mediaTypePlural = '';
    try {
      mediaTypePlural = getMediaTypeDbNamePlural(MT);
    }
    catch (err) {
      throw UnimplementedError('Sorting is not implemented for this media type, because of $err');
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // When something changes call this function to redraw everything (both the dialog and the library/wishlist)
            var resetState = () {
              setState(() {});
              resetGlobalState();
            };
            
            Widget option(String description, String value, String groupValue, void Function() onChanged) {
              return Row(
                children: [
                  Radio(
                    value: value,
                    groupValue: groupValue,
                    onChanged: (_) {
                      onChanged();
                      resetState();
                    },
                  ),
                  Text(
                    description,
                    style: subtitleStyle,
                  ),
                ],
              );
            }
            
            return AlertDialog(
              title: Text('Sort $mediaTypePlural'),
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Sort direction',
                        style: titleStyle,
                      ),
                      option(
                        'Increasing',
                        'increasing',
                        increasingSorting
                          ? 'increasing'
                          : 'decreasing',
                        () => increasingSorting = true,
                      ),
                      option(
                        'Decreasing',
                        'decreasing',
                        increasingSorting
                          ? 'increasing'
                          : 'decreasing',
                        () => increasingSorting = false,
                      ),
                      Text(
                        'Sort parameter',
                        style: titleStyle,
                      ),
                      for (String sortingMethod in mediaOrderComparators.keys)
                        option(
                          sortingMethod,
                          sortingMethod,
                          selectedSortingMethod,
                          () => selectedSortingMethod = sortingMethod,
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

  Future<void> _showFilterMediaDialog(BuildContext context) {
    // Helper function, should be called when a variable gets changed
    void resetGlobalState() {
      setState(() {});
    }

    String mediaType = '';
    try {
      mediaType = getMediaTypeDbNamePlural(MT);
    }
    catch (err) {
      throw UnimplementedError('Filtering is not implemented for this media type, because of $err');
    }

    List<UserTag> userTags = List.from(UserTagService.instance.items, growable: false);
    List<Genre>   genres   = List.from(  GenreService.instance.items, growable: false);

    userTags.sort((t0, t1) => t0.name.compareTo(t1.name));
      genres.sort((g0, g1) => g0.name.compareTo(g1.name));

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void resetState() {
              resetGlobalState();
              setState(() {});
            };

            Widget radioOption(String description, String value, String groupValue, void Function() onChanged) {
              return Row(
                children: [
                  Radio(
                    value: value,
                    groupValue: groupValue,
                    onChanged: (_) {
                      onChanged();
                      resetState();
                    },
                  ),
                  Text(
                    description,
                    style: subtitleStyle,
                  ),
                ],
              );
            }
            
            Widget checkboxOption(String description, bool value, void Function(bool?) onChanged) {
              return Row(
                children: [
                  Checkbox(
                    value: value,
                    onChanged: (value) {
                      onChanged(value);
                      resetState();
                    },
                  ),
                  Text(
                    description,
                    style: subtitleStyle,
                  ),
                ],
              );
            }
            
            return AlertDialog(
              title: Text('Filter $mediaType'),
              content: SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Filter type',
                        style: titleStyle,
                      ),
                      radioOption(
                        'All',
                        'All',
                        filterAll
                          ? 'All'
                          : 'Any',
                        () => filterAll = true,
                      ),
                      radioOption(
                        'Any',
                        'Any',
                        filterAll
                          ? 'All'
                          : 'Any',
                        () => filterAll = false,
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
                      for (UserTag userTag in userTags)
                        checkboxOption(
                          userTag.name,
                          selectedTagsIds.contains(userTag.id),
                          (value) {
                            value == null
                              ? throw Exception('How did this tag filter checkbox get blocked?')
                              : value
                                ? selectedTagsIds.add(userTag.id)
                                : selectedTagsIds.remove(userTag.id);
                          },
                        ),
                      Row(
                        children: [
                          Text(
                            'Genres',
                            style: titleStyle,
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
                        checkboxOption(
                          genre.name,
                          selectedGenresIds.contains(genre.id),
                          (value) {
                            value == null
                              ? throw Exception('How did this genre filter checkbox get blocked?')
                              : value
                                ? selectedGenresIds.add(genre.id)
                                : selectedGenresIds.remove(genre.id);
                          },
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

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int mediaId) {
    String mediaType = '';
    try {
      mediaType = getMediaTypeDbName(MT);
    }
    catch (err) {
      throw UnimplementedError('Delete is not implemented for this media type, because of $err');
    }

    String customName = getCustomName(mediaId);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove $customName'),
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
                await _removeMediaCascade(mediaId);
                Navigator.of(context).pop();
                if (selectedMediaId == mediaId) {
                  selectedMediaId = -1;
                }
                setState(() {});
              },
              child: const Text('Delete'),
              style: redFillButton(context)
                .filledButtonTheme
                .style,
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeMediaCascade(int mediaId) async {
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
    MediaGenreService
      .instance
      .items
      .where((mg) => mg.mediaId == mediaId)
      .forEach((mg) =>
        toDo.add(
          MediaGenreService
            .instance
            .delete([mediaId, mg.genreId])
        )
      );
    if (isWishlist) {
      toDo.add(WishlistService.instance.delete(mediaId));
    }
    else {
      toDo.add(MediaUserService.instance.delete(mediaId));
    }
    await Future.wait(toDo);
    setState(() {});
  }

  // This function receives the result of getInfoIGDB and creates (if needed) the game in the db. It returns extra data and the game (created or received from the db)
  Future<Pair<Map<String, dynamic>, Game>> createGame(Map<String, dynamic> gameData) async {
    String name = gameData['originalname'];
    Game? nullableGame = mediaAlreadyInDB(name) as Game?;
    gameData[getAttributeNameForType(MT)] = gameData[getOldAttributeNameForType(MT)];
    
    if (name[name.length - 1] == ')' && name.length >= 7) {
      name = name.substring(0, name.length - 7);
    }

    if (nullableGame == null) {
      var options = await Future.wait([getOptionsPCGW(name), getOptionsHLTB(name)]);
      var optionsPCGW = options.first;
      var optionsHLTB = options.elementAt(1);
      var results = await Future.wait([
        optionsPCGW.isEmpty ? Future.value(Map<String, dynamic>()) : getInfoPCGW(options[0][0]),
        optionsHLTB.isEmpty ? Future.value(Map<String, dynamic>()) : getInfoHLTB(options[1][0]),
      ]);
      
      // Get information from PCGamingWiki
      Map<String, dynamic> resultPCGW = results[0];
      if (resultPCGW.containsKey('windows')) {
        if (resultPCGW['windows'].containsKey('OS')) {
          gameData['osminimum'] = resultPCGW['windows']['OS']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['osrecommended'] = resultPCGW['windows']['OS']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
        }
        if (resultPCGW['windows'].containsKey('CPU')) {
          gameData['cpuminimum'] = resultPCGW['windows']['CPU']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['cpurecommended'] = resultPCGW['windows']['CPU']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
        }
        if (resultPCGW['windows'].containsKey('RAM')) {
          gameData['ramminimum'] = resultPCGW['windows']['RAM']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['ramrecommended'] = resultPCGW['windows']['RAM']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
        }
        if (resultPCGW['windows'].containsKey('HDD')) {
          gameData['hddminimum'] = resultPCGW['windows']['HDD']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['hddrecommended'] = resultPCGW['windows']['HDD']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
        }
        if (resultPCGW['windows'].containsKey('GPU')) {
          gameData['gpuminimum'] = resultPCGW['windows']['GPU']['minimum']?.replaceAll(RegExp(r'\s+'), ' ');
          gameData['gpurecommended'] = resultPCGW['windows']['GPU']['recommended']?.replaceAll(RegExp(r'\s+'), ' ');
        }
      }

      // Get information from HLTB
      Map<String, dynamic> resultHLTB = results[1];
      if (resultHLTB.containsKey('Main Story')) {
        gameData['hltbmaininseconds'] = (double.parse(resultHLTB['Main Story'].split(' Hours')[0]) * 3600).round();
      }
      if (resultHLTB.containsKey('Main + Sides')) {
        gameData['hltbmainsideinseconds'] = (double.parse(resultHLTB['Main + Sides'].split(' Hours')[0]) * 3600).round();
      }
      if (resultHLTB.containsKey('Completionist')) {
        gameData['hltbcompletionistinseconds'] = (double.parse(resultHLTB['Completionist'].split(' Hours')[0]) * 3600).round();
      }
      if (resultHLTB.containsKey('All Styles')) {
        gameData['hltballstylesinseconds'] = (double.parse(resultHLTB['All Styles'].split(' Hours')[0]) * 3600).round();
      }
      if (resultHLTB.containsKey('Co-Op')) {
        gameData['hltbcoopinseconds'] = (double.parse(resultHLTB['Co-Op'].split(' Hours')[0]) * 3600).round();
      }
      if (resultHLTB.containsKey('Vs.')) {
        gameData['hltbversusinseconds'] = (double.parse(resultHLTB['Vs.'].split(' Hours')[0]) * 3600).round();
      }

      nullableGame = await GameService.instance.create(gameData);
    }

    gameData['name'] = name;
    return Pair(gameData, nullableGame);
  }

  // Despite its name, this function only connects the User and the MT. Speciffic data is being sent throught the data parameter
  Future<void> addToLibraryOrWishlist(Map<String, dynamic> data, MT mt) async {
    final String placeholderImage = 'https://static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg';
    String coverImage = placeholderImage, icon = placeholderImage, backgroundImage = placeholderImage;

    if (data.containsKey('coverimage')) {
      icon = coverImage = backgroundImage = data['coverimage'];
    }

    if (data.containsKey('artworks') && data['artworks'].isNotEmpty) {
      if (data['artworks'] is List) {
        backgroundImage = data['artworks'][0];
      }
      else {
        backgroundImage = data['artworks'];
      }
    }

    if (data.containsKey('icon')) {
      icon = data['icon'];
    }

    if (isWishlist) {
      if (mediaAlreadyInLibrary(data['originalname']) || mediaAlreadyInWishlist(data['originalname'])) {
        return;
      }

      Wishlist wish = Wishlist(
        mediaId: mt.getMediaId(),
        userId: UserSystem.instance.getCurrentUserId(),
        name: data['name'],
        userScore: -1,
        addedDate: DateTime.now(),
        coverImage: coverImage,
        series: (data['seriesname'] == null || data['seriesname'].isEmpty) ? data['name'] : data['seriesname'][0],
        icon: icon,
        backgroundImage: backgroundImage,
        lastInteracted: DateTime.now(),
      );

      await WishlistService.instance.create(wish);
    }
    else {
      if (mediaAlreadyInLibrary(data['originalname'])) {
        return;
      }

      MediaUser mu = MediaUser(
        mediaId: mt.getMediaId(),
        userId: UserSystem.instance.getCurrentUserId(),
        name: data['name'],
        userScore: -1,
        addedDate: DateTime.now(),
        coverImage: coverImage,
        status: getDefaultStatusForType(MT),
        series: (data['seriesname'] == null || data['seriesname'].isEmpty) ? data['name'] : data['seriesname'][0] ?? data['name'],
        icon: icon,
        backgroundImage: backgroundImage,
        lastInteracted: DateTime.now(),
      );

      if (mediaAlreadyInWishlist(data['originalname'])) {
        Wishlist wishlist = WishlistService
          .instance
          .items
          .where((wish) => wish.mediaId == mt.getMediaId())
          .first;
        
        // Move customizations over
        mu.name            = wishlist.name;
        mu.userScore       = wishlist.userScore;
        mu.coverImage      = wishlist.coverImage;
        mu.icon            = wishlist.icon;
        mu.backgroundImage = wishlist.backgroundImage;

        await WishlistService.instance.delete(mt.getMediaId());
      }

      await MediaUserService.instance.create(mu);
    }

    setState(() {});
  }

  Future<void> importIGDB(int igdbId, Map<String, dynamic> userData) async {
    Pair<Map<String, dynamic>, Game> result = await createGame(await getInfoIGDB({'id': igdbId}));
    await addToLibraryOrWishlist({
        ...result.key,
        ...userData,
      },
      result.value as MT,
    );
  }

  // This function creates the Media object and the speciffic MediaType object in the database. After that it connects the user to the MediaType object with either MediaUser or Wishlist
  Future<void> addMediaType(Map<String, dynamic> option) async {
    if (UserSystem.instance.currentUserData == null) {
      return;
    }

    // TODO: when adding a mediaType, you also add the others in the series, which are added with minimum content,
    // so if the media is already in db but has minimum content, we should still do the api calls at this stage
    Pair<Map<String, dynamic>, MT> result;

    if (MT == Game) {
      result = await createGame(await getInfoIGDB(option)) as Pair<Map<String, dynamic>, MT>;
    }
    else if (MT == Anime || MT == Book || MT == Manga || MT == Movie || MT == TVSeries) {
      var data = await getInfoForType(MT, option);
      data[getAttributeNameForType(MT)] = data[getOldAttributeNameForType(MT)];
      String name = data['originalname'];
      MT? nullableMT = mediaAlreadyInDB(name);

      if (nullableMT == null) {
        nullableMT = await getServiceInstanceForType(MT).create(data);
      }

      data['name'] = data['originalname'];
      result = Pair(data, nullableMT as MT);
    }
    else {
      throw UnimplementedError('AddMediaType with for type $MT is not implemented!');
    }

    await addToLibraryOrWishlist(result.key, result.value);
  }

  Widget _displayMedia(MT? mt) {  
    String mediaType = '';
    try {
      mediaType = getMediaTypeDbName(MT);
    }
    catch (err) {
      throw UnimplementedError('Display media for this media type is not implemented, because of $err');
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

    Widget additionalButtons = getAdditionalButtons(mt, context, () {setState(() {});}, isWishlist);

    // TODO: Notes button
    // return StatefulBuilder(
    //   builder: (context, setState) {
        
    //   },
    // );

    return displayMedia(
      mt.media,
      additionalButtons,
      renderNotes(
        NoteService
          .instance
          .items
          .where((note) => note.mediaId == mt.getMediaId())
          .toList()
      ),
      isWishlist
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
            height: 150,
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
                await NoteService.instance.create(Note(
                  mediaId: mediaId,
                  userId: UserSystem.instance.getCurrentUserId(),
                  content: controller.text,
                  creationDate: DateTime.now(),
                  modifiedDate: DateTime.now(),
                ));
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
    Widget textToDisplay = const Center(
      child: Text(
        '+',
        style: TextStyle(
          fontSize: 70,
          color: Colors.black26,
        ),
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
              child: Container(
                width: double.infinity,
                child: textToDisplay,
              ),
            ),
          ),
          if (note != null)
            Positioned(
              right: 20,
              top: 20,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: removeNote,
                color: const Color.fromARGB(255, 255, 0, 0),
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
