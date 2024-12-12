import 'package:flutter/material.dart';
import 'package:mediamaster/Models/game.dart';
import 'package:mediamaster/Models/media_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:mediamaster/Models/note.dart';
import 'package:pair/pair.dart';
import 'dart:async';
import 'Services/ApiService.dart';

import 'Models/genre.dart';
import 'Models/publisher.dart';
import 'Models/platform.dart';
import 'Models/creator.dart';
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

class LibraryState<MT extends MediaType> extends State<Library> {
  int selectedMediaId = 0;
  String filterQuery = "";
  TextEditingController searchController = TextEditingController();
  bool increasingSorting = true;
  int selectedSortingMethod = 0;
  var mediaOrderComparators = [
    Pair<String, dynamic>(
      "By original name",
      (MT a, MT b, int increasing) async {
        return increasing *
            (await a.media).originalName.compareTo((await b.media).originalName);
      },
    ),
    Pair<String, dynamic>(
      "By critic score",
      (MT a, MT b, int increasing) async {
        return increasing * (await a.media).criticScore.compareTo((await b.media).criticScore);
      },
    ),
    Pair<String, dynamic>(
      "By comunity score",
      (MT a, MT b, int increasing) async {
        return increasing *
            (await a.media).communityScore.compareTo((await b.media).communityScore);
      },
    ),
    Pair<String, dynamic>(
      "By release date",
      (MT a, MT b, int increasing) async {
        return increasing * (await a.media).releaseDate.compareTo((await b.media).releaseDate);
      },
    ),
    // TODO: Think if there is some simple/easy way to add these
    /*
    Pair<String, dynamic>( // TODO: FIX THIS
      "By time to beat",
      (Game a, Game b, int increasing) {
        int ta = a.getMinTimeToBeat();
        int tb = b.getMinTimeToBeat();

        if (tb == -1) {
          return -1;
        }
        if (ta == -1) {
          return 1;
        }
        return increasing * ta.compareTo(tb);
      },
    ),
    Pair<String, dynamic>( // TODO: FIX THIS
      "By time to 100%",
      (Game a, Game b, int increasing) {
        if (b.HLTBCompletionistInSeconds == -1) {
          return -1;
        }
        if (a.HLTBCompletionistInSeconds == -1) {
          return 1;
        }
        return increasing *
            a.HLTBCompletionistInSeconds.compareTo(
                b.HLTBCompletionistInSeconds);
      },
    ),
    */
     // TODO: ADD OTHER SORTING METHODS
  ];
  bool filterAll = true;
  Set<Genre> selectedGenresIds = {};
  Set<Tag> selectedTagsIds = {};
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  // Create and return a list view of the filtered media
  Future<ListView> mediaListBuilder(BuildContext context) async {
    List<ListTile> listTiles = List.empty(growable: true);
    List<MT> userMedia = List<MT>.empty();
    if (MT == Game) {
      userMedia = (await UserSystem().getUserMedia("game")).map((x) => x as MT).toList();
    }
    List<Pair<MT, int>> mediaIndices = List.empty(growable: true);

    for (int i = 0; i < userMedia.length; ++i) {
      int id = userMedia.elementAt(i).getMediaId();
      bool shouldAdd = true;
      if (selectedGenresIds.isNotEmpty || selectedTagsIds.isNotEmpty) {
        int conditionsMet = (await supabase.from("mediausertag").select().eq("userid", UserSystem().getCurrentUserId()).eq("mediaid", id).inFilter("tagid", selectedTagsIds.toList())).length;
        if (filterAll || conditionsMet == 0) {
          conditionsMet += (await supabase.from("mediausergenre").select().eq("userid", UserSystem().getCurrentUserId()).eq("mediaid", id).inFilter("genreid", selectedGenresIds.toList())).length;
        }

        if (filterAll) {
          shouldAdd =
              (selectedGenresIds.length + selectedTagsIds.length == conditionsMet);
        } else if (conditionsMet == 0) {
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
      throw UnimplementedError("Leading Icon for media type not declared.");
    }

    for (int i = 0; i < mediaIndices.length; ++i) {
      final mt = mediaIndices[i].key;
      final idx = mediaIndices[i].value;
      if (filterQuery == "" ||
          (await mt.media).originalName.toLowerCase().contains(filterQuery)) {
        listTiles.add(
          ListTile(
            leading: leadingIcon,
            title: Text((await mt.media).originalName), // TODO: Fix this to use user customization
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

  // TODO: Remove year from game name before call.
  Future<MT?> mediaAlreadyInDB(String name) async {
    String dbName = "";
    if (MT == Game) {
      dbName = "game";
    }
    else {
      throw UnimplementedError("Media type already in db is not implemented");
    }

    List<dynamic> media = (await supabase.from("media").select("id").eq("originalname", name).eq("mediatype", dbName)).map((x) => x["id"]).toList();

    if (media.isEmpty) {
      return null;
    }

    if (MT == Game) {
      return Game.from(await supabase.from(dbName).select().eq("mediaid", media.first).single()) as MT;
    }

    throw UnimplementedError("Media type already in db is not implemented");
  }

  Future<bool> mediaAlreadyInWishlist(String name) async {
    String dbName = "";
    if (MT == Game) {
      dbName = "game";
    }
    else {
      throw UnimplementedError("Media type already in wishlist is not implemented");
    }

    return (await supabase.from("media").select("id").eq("originalname", name).eq("mediatype", dbName)).isNotEmpty;
  }

  Future<bool> mediaAlreadyInLibrary(String name) async {
    String dbName = "";
    if (MT == Game) {
      dbName = "game";
    }
    else {
      throw UnimplementedError("Media type already in library is not implemented");
    }

    var id = (await supabase.from("media").select("id").eq("originalname", name).eq("mediatype", dbName).single())["id"];
    return (await supabase.from("mediauser").select().eq("mediaid", id)).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _setSearchText();

    IconButton? butonSearchReset;
    if (filterQuery == "") {
      butonSearchReset = IconButton(
        onPressed: () {
          /*TODO: The search box gets activated only if you hold down at least 2 frames, I do not know the function to activate it when pressing this button. I also do not know if this should be our priority right now*/
        },
        icon: const Icon(Icons.search),
      );
    } else {
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

    String mediaType = "";
    if (MT == Game) {
      mediaType = "game";
    }
    else {
      throw UnimplementedError("Build not implemented for this media type");
    }

    TextField textField = TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: "Search $mediaType in library",
        suffixIcon: butonSearchReset,
      ),
    );

    var mediaListWidget = mediaListBuilder(context);
    Future<MT?> selectedMT = getSelectedMT();

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
            child: Text(UserSystem().currentUser!.username),
          ),
          IconButton(
              onPressed: () {
                UserSystem().logout();
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Log out'),
        ],
      ),
      body: FutureBuilder(
        future: selectedMT,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: Future.wait([mediaListWidget, _displayMedia(snapshot.data)]),
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
                        Expanded(
                          child: snapshot.data!.first,
                        ),
                      ],
                    )
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: snapshot.data!.elementAt(1),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<MT?> getSelectedMT() async {
    if (selectedMediaId == -1) {
      return null;
    }

    String mtDbName = "";
    if (MT == Game) {
      mtDbName = "game";
    }
    else {
      throw UnimplementedError("getSelectedMT is not implemented for this media type");
    }

    List<Map<String, dynamic>> list = (await supabase.from(mtDbName).select().eq("mediaid", selectedMediaId));
    if (list.isEmpty) {
      return null;
    }

    if (MT == Game) {
      return Game.from(list.first) as MT;
    }
    else {
      throw UnimplementedError("getSelectedMT is not implemented for this media type");
    }
  }

  // TODO: FIX THIS FUNCTION
  Future<void> _showSearchMediaDialog(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    List<dynamic> searchResults = [];

    bool noSearch = true; // Flag to track if there are no search results

    String mediaType = "";
    if (MT == Game) {
      mediaType = "Game";
    }
    else {
      throw UnimplementedError("Search dialog for this media type is not implemented");
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

                                return FutureBuilder(
                                  future: Future.wait([mediaAlreadyInLibrary(mediaName), mediaAlreadyInWishlist(mediaName)]),
                                  builder: (context, snapshot) {
                                    if (snapshot.data!.first) {
                                      return ListTile(
                                        title: Text(mediaName),
                                        subtitle: Text(
                                          "$mediaType is already in library.",
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 255, 0, 0),
                                          ),
                                        ),
                                        onTap: () {
                                          _addGame(result);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    } else if (snapshot.data!.elementAt(1)) {
                                      return ListTile(
                                        title: Text(mediaName),
                                        subtitle: Text(
                                          "$mediaType is in wishlist.",
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 255, 0, 0),
                                          ),
                                        ),
                                        onTap: () {
                                          _addGame(result);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    } else {
                                      return ListTile(
                                        title: Text(mediaName),
                                        onTap: () {
                                          _addGame(result);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }
                                  },
                                );
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

    String mediaType = "";
    if (MT == Game) {
      mediaType = "games";
    }
    else {
      throw UnimplementedError("Sorting is not implemented for this media type");
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

    String mediaType = "";
    if (MT == Game) {
      mediaType = "games";
    }
    else {
      throw UnimplementedError("Sorting is not implemented for this media type");
    }

    List<Tag> tags = await Tag.getAllTags(); // TODO: I don't know if we want all tags
    List<Genre> genres = await Genre.getAllGenres(); // TODO: I don't know if we want all genres

    if (context.mounted) {
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
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int mediaId) async {
    String mediaType = "";
    if (MT == Game) {
      mediaType = "game";
    }
    else {
      throw UnimplementedError("Delete is not implemented for this media type");
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: Text('Are you sure you want to delete this $mediaType?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: We might also want to remove the mediausertag and mediausergenre but I am not sure for now
                // TODO: Endpoint this
                Supabase
                  .instance
                  .client
                  .from("mediauser")
                  .delete()
                  .eq("mediaid", mediaId)
                  .eq("userid", UserSystem().currentUser.id);
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
    if (UserSystem().currentUser == null) {
      return;
    }

    var selectedGame = await getInfoIGDB(result);
    String name = selectedGame['name'];

    if (name[name.length - 1] == ')' && name.length >= 7) {
      name = name.substring(0, name.length - 7);
    }

    Game? nullableGame = await mediaAlreadyInDB(name) as Game?;

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
        answersPCGW['OSMinimum'] = resultPCGW['windows']['OS']['minimum']
            ?.replaceAll(RegExp(r'\s+'), ' ');
        answersPCGW['OSRecommended'] = resultPCGW['windows']['OS']
                ['recommended']
            ?.replaceAll(RegExp(r'\s+'), ' ');
      }
      if (resultPCGW['windows'].containsKey('CPU')) {
        answersPCGW['CPUMinimum'] = resultPCGW['windows']['CPU']['minimum']
            ?.replaceAll(RegExp(r'\s+'), ' ');
        answersPCGW['CPURecommended'] = resultPCGW['windows']['CPU']
                ['recommended']
            ?.replaceAll(RegExp(r'\s+'), ' ');
      }
      if (resultPCGW['windows'].containsKey('RAM')) {
        answersPCGW['RAMMinimum'] = resultPCGW['windows']['RAM']['minimum']
            ?.replaceAll(RegExp(r'\s+'), ' ');
        answersPCGW['RAMRecommended'] = resultPCGW['windows']['RAM']
                ['recommended']
            ?.replaceAll(RegExp(r'\s+'), ' ');
      }
      if (resultPCGW['windows'].containsKey('HDD')) {
        answersPCGW['HDDMinimum'] = resultPCGW['windows']['HDD']['minimum']
            ?.replaceAll(RegExp(r'\s+'), ' ');
        answersPCGW['HDDRecommended'] = resultPCGW['windows']['HDD']
                ['recommended']
            ?.replaceAll(RegExp(r'\s+'), ' ');
      }
      if (resultPCGW['windows'].containsKey('GPU')) {
        answersPCGW['GPUMinimum'] = resultPCGW['windows']['GPU']['minimum']
            ?.replaceAll(RegExp(r'\s+'), ' ');
        answersPCGW['GPURecommended'] = resultPCGW['windows']['GPU']
                ['recommended']
            ?.replaceAll(RegExp(r'\s+'), ' ');
      }
    }

    // Get information from HLTB
    var optionsHLTB = await getOptionsHLTB(selectedGame['name']);
    Map<String, dynamic> resultHLTB = {};
    if (optionsHLTB.isNotEmpty) {
      // This is kind of a hack but we will do it legit in the future
      resultHLTB = await getInfoHLTB(optionsHLTB[0]);
    }
    Map<String, dynamic> answersHLTB = {};
    if (resultHLTB.containsKey('Main Story')) {
      answersHLTB['Main Story'] =
          (double.parse(resultHLTB['Main Story'].split(' Hours')[0]) * 3600)
              .round();
    }
    if (resultHLTB.containsKey('Main + Sides')) {
      answersHLTB['Main + Sides'] =
          (double.parse(resultHLTB['Main + Sides'].split(' Hours')[0]) * 3600)
              .round();
    }
    if (resultHLTB.containsKey('Completionist')) {
      answersHLTB['Completionist'] =
          (double.parse(resultHLTB['Completionist'].split(' Hours')[0]) * 3600)
              .round();
    }
    if (resultHLTB.containsKey('All Styles')) {
      answersHLTB['All Styles'] =
          (double.parse(resultHLTB['All Styles'].split(' Hours')[0]) * 3600)
              .round();
    }
    if (resultHLTB.containsKey('Co-Op')) {
      answersHLTB['Co-Op'] =
          (double.parse(resultHLTB['Co-Op'].split(' Hours')[0]) * 3600).round();
    }
    if (resultHLTB.containsKey('Vs.')) {
      answersHLTB['Vs.'] =
          (double.parse(resultHLTB['Vs.'].split(' Hours')[0]) * 3600).round();
    }

    if (nullableGame == null) {
      Media media = Media(
        originalName: name,
        description:
            selectedGame['summary'] ?? "There is no summary for this game.",
        releaseDate: selectedGame['first_release_date'] != null
            ? selectedGame['first_release_date'] as DateTime
            : DateTime(1800),
        criticScore: selectedGame['critic_rating'] != 0
            ? selectedGame['critic_rating']
            : 0,
        communityScore:
            selectedGame['user_rating'] != 0 ? selectedGame['user_rating'] : 0,
        mediaType: "Game",
      );

      // TODO: Endpoint
      media.id = (await supabase.from("media").insert(media.toSupa()).select()).map(Media.from).first.id;

      Game newGame = Game(
        mediaId: media.id,
        parentGameId:
            -1 /*TODO in the next semester: Add parameter/call to API to check if this is a DLC*/,
        IGDBId: selectedGame['id'],
        OSMinimum: answersPCGW.containsKey('OSMinimum') &&
                answersPCGW['OSMinimum'] != null
            ? answersPCGW['OSMinimum']
            : "N/A",
        OSRecommended: answersPCGW.containsKey('OSRecommended') &&
                answersPCGW['OSRecommended'] != null
            ? answersPCGW['OSRecommended']
            : "N/A",
        CPUMinimum: answersPCGW.containsKey('CPUMinimum') &&
                answersPCGW['CPUMinimum'] != null
            ? answersPCGW['CPUMinimum']
            : "N/A",
        CPURecommended: answersPCGW.containsKey('CPURecommended') &&
                answersPCGW['CPURecommended'] != null
            ? answersPCGW['CPURecommended']
            : "N/A",
        RAMMinimum: answersPCGW.containsKey('RAMMinimum') &&
                answersPCGW['RAMMinimum'] != null
            ? answersPCGW['RAMMinimum']
            : "N/A",
        RAMRecommended: answersPCGW.containsKey('RAMRecommended') &&
                answersPCGW['RAMRecommended'] != null
            ? answersPCGW['RAMRecommended']
            : "N/A",
        HDDMinimum: answersPCGW.containsKey('HDDMinimum') &&
                answersPCGW['HDDMinimum'] != null
            ? answersPCGW['HDDMinimum']
            : "N/A",
        HDDRecommended: answersPCGW.containsKey('HDDRecommended') &&
                answersPCGW['HDDRecommended'] != null
            ? answersPCGW['HDDRecommended']
            : "N/A",
        GPUMinimum: answersPCGW.containsKey('GPUMinimum') &&
                answersPCGW['GPUMinimum'] != null
            ? answersPCGW['GPUMinimum']
            : "N/A",
        GPURecommended: answersPCGW.containsKey('GPURecommended') &&
                answersPCGW['GPURecommended'] != null
            ? answersPCGW['GPURecommended']
            : "N/A",
        HLTBMainInSeconds: answersHLTB.containsKey('Main Story')
            ? answersHLTB['Main Story']
            : -1,
        HLTBMainSideInSeconds: answersHLTB.containsKey('Main + Sides')
            ? answersHLTB['Main + Sides']
            : -1,
        HLTBCompletionistInSeconds: answersHLTB.containsKey('Completionist')
            ? answersHLTB['Completionist']
            : -1,
        HLTBAllStylesInSeconds: answersHLTB.containsKey('All Styles')
            ? answersHLTB['All Styles']
            : -1,
        HLTBCoopInSeconds:
            answersHLTB.containsKey('Co-Op') ? answersHLTB['Co-Op'] : -1,
        HLTBVersusInSeconds:
            answersHLTB.containsKey('Vs.') ? answersHLTB['Vs.'] : -1,
      );

      if(selectedGame['publishers'] != null) {
        // get the publishers of the game
        List<String> gamePublishers = (selectedGame['publishers'] as List<dynamic>).map((x) => x.toString()).toList();

        for (String publisherString in gamePublishers) {
          Publisher? publisher = await Publisher.tryGet(publisherString);
          if (publisher == null) {
            // A new publisher. Add it to the database
            publisher = Publisher(
              name: publisherString,
            );
            // TODO: Endpoint
            List<Publisher> list = (await supabase.from("publisher").insert(publisher.toSupa()).select()).map(Publisher.from).toList();
            publisher.id = list.first.id;
          }

          // TODO: Endpoint
          await supabase.from("mediapublisher").insert({"mediaid": newGame.mediaId, "publisherid": publisher.id});
        }
      }

      if(selectedGame['developers'] != null) {
        // get the developers of the game
        List<String> gameCreators = (selectedGame['developers'] as List<dynamic>).map((x) => x.toString()).toList();
        
        for (String creatorString in gameCreators) {
          Creator? creator = await Creator.tryGet(creatorString);
          if (creator == null) {
            // A new developer. Add it to the database
            creator = Creator(
              name: creatorString,
            );
            // TODO: Endpoint
            List<Creator> list = (await supabase.from("creator").insert(creator.toSupa()).select()).map(Creator.from).toList();
            creator.id = list.first.id;
          }

          // TODO: Endpoint
          await supabase.from("mediacreator").insert({"mediaid": newGame.mediaId, "creatorid": creator.id});
        }
      }

      if(selectedGame['platforms'] != null) {
        // get the platforms of the game
        List<dynamic> gamePlatforms = (selectedGame['platforms'] as List<dynamic>).map((x) => x.toString()).toList();
        
        for (String platformString in gamePlatforms) {
          Platform? platform = await Platform.tryGet(platformString);
          if (platform == null) {
            // A new platform. Add it to the database
            platform = Platform(
              name: platformString,
            );
            // TODO: Endpoint
            List<Platform> list = (await supabase.from("platform").insert(platform.toSupa()).select()).map(Platform.from).toList();
            platform.id = list.first.id;
          }

          // TODO: Endpoint
          await supabase.from("mediaplatform").insert({"mediaid": newGame.mediaId, "platformid": platform.id});
        }
      }

      // TODO: Endpoint
      newGame.id = (await supabase.from("game").insert(newGame.toSupa()).select()).map(Game.from).first.id;

      nullableGame = newGame;
    }

    Game game = nullableGame;

    if (!await mediaAlreadyInLibrary(name)) {
      MediaUser mu = MediaUser(
        mediaId: game.mediaId,
        userId: UserSystem().currentUser!.id,
        name: name,
        userScore: -1,
        addedDate: DateTime.now(),
        coverImage: selectedGame["cover"] ?? '//static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg',
        status: "Plan To Play",
        series: name, // TODO: Add parameter/call to game series API
        icon: selectedGame["cover"] ?? '//static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg',
        backgroundImage: selectedGame["artworks"] == null ? '//static.vecteezy.com/system/resources/previews/016/916/479/original/placeholder-icon-design-free-vector.jpg' : selectedGame["artworks"][0],
        lastInteracted: DateTime.now(),
      );

      // TODO: Endpoint
      await supabase.from("mediauser").insert(mu.toSupa());
    }
  }

  // TODO: FIX THIS FUNCTION
  Future<Widget> _displayMedia(MT? mt) async {
    String mediaType = "";
    Widget additionalButtons = Container();
    if (MT == Game) {
      mediaType = "game";
    }
    else {
      throw UnimplementedError("Display media for this media type is not implemented");
    }

    if (mt == null) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Text(
            "Choose a $mediaType",
            style: const TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        )
      );
    }

    if (MT == Game) {
      additionalButtons = Game.getAditionalButtons(mt as Game, context, () {setState(() {});});
    }
    else {
      throw UnimplementedError("Get additional buttons for this media type is not implemented");
    }

    return (await mt.media)
      .displayMedia(
        additionalButtons,
        renderNotes(
          await Note.getNotes(UserSystem().getCurrentUserId(), mt.getMediaId())
        ),
      );
  }

  Future<void> _showNewStickyDialog(int mediaId) {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New sticky note"),
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
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Note note = Note(
                  mediaId: mediaId,
                  userId: UserSystem().currentUser!.id,
                  content: controller.text,
                );
                Supabase.instance.client.from("note").insert(note.toSupa()); // TODO: Use endpoint
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget renderStickyNote(Note? note, int mediaId) {
    Widget textToDisplay = const Text(
      "+",
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
      note as Note;
      await Supabase.instance.client.from("note").delete().eq("id", note.id);
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
