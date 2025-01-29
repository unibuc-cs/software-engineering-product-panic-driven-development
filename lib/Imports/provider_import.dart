import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mediamaster/Helpers/getters.dart';
import 'package:mediamaster/Library.dart';
import 'package:mediamaster/Models/general/media_type.dart';
import 'package:mediamaster/Widgets/themes.dart';
import 'package:mutex/mutex.dart';

Map<String, dynamic> _doNothing(_) => {};

class ProviderImport<MT extends MediaType> {
  Future<List<dynamic>> Function(String) listProvider;
  Future<List<Map<String, dynamic>>> Function(String) optionsProvider;
  Map<String, dynamic> Function(dynamic) customizations;
  int optionsMillisecondsDelay;
  int importMillisecondsDelay;
  String providerName;
  String howToGetIdLink;
  String libraryName; // Trakt is special. It is not "Trakt library", but rather "Trakt watchlist"
  String idName;

  ProviderImport({
    required this.listProvider,
    required this.optionsProvider,
    this.customizations = _doNothing,
    this.optionsMillisecondsDelay = 100,
    required this.providerName,
    required this.howToGetIdLink,
    this.libraryName = 'library',
    this.importMillisecondsDelay = 0,
    this.idName = 'ID',
  });

  Map<String, dynamic> _getBestMatch(String searchName, List<Map<String, dynamic>> searchOptions) {
    Map<String, dynamic> bestMatch = {};
    int bestMatchPercentage = 0;
    searchName = searchName.replaceAll(RegExp(r'\W'), '').toLowerCase();
    if (searchName == '') {
      return {};
    }
    
    for (final searchOption in searchOptions) {
      if (!searchOption.containsKey('name')) {
        continue;
      }
      String name = searchOption['name']
        .replaceAll(RegExp(r'\(.*?\)'), '')
        .replaceAll(RegExp(r'\W'), '')
        .toLowerCase();
      int length = math.max(name.length, searchName.length), matchPercentage = 0;
      String paddedGameName = searchName.padRight(length, ' ');
      name = name.padRight(length, '_');
      for (int i = 0; i < length; i++) {
        if (name[i] == paddedGameName[i]) {
          matchPercentage++;
        }
      }
      matchPercentage = (matchPercentage / length * 100).round();
      if (matchPercentage > bestMatchPercentage) {
        bestMatch = searchOption;
        bestMatchPercentage = matchPercentage;
      }
    }
    if (bestMatchPercentage < 50) {
      bestMatch = {};
    }
    return bestMatch;
  }

  Future<Map<String, Map<String, dynamic>>> _getOptionsForID(String userId) async {
    if (userId.isEmpty) {
      return {};
    }
    final mediasList = await listProvider(userId);
    final futures = <Future<void>>[];
    Map<String, Map<String, dynamic>> medias = {};
    Mutex mutex = Mutex();

    for (var i = 0; i < mediasList.length; i++) {
      futures.add(Future.delayed(Duration(milliseconds: optionsMillisecondsDelay * i), () async {
        final media = mediasList[i];
        final name = (media['name'] ?? '')
          .replaceAll(':', '')
          .replaceAll(',', '')
          .replaceAll('&', 'and')
          .split(RegExp(r'\s+'))
          .join(' ');
        final mediaOptions = await optionsProvider(name);
        final bestOptionMatch = _getBestMatch(name, mediaOptions);
        if (bestOptionMatch.isNotEmpty) {
          await mutex.protect(() async {
            medias[name] = {
              ...bestOptionMatch,
              ...customizations(media),
            };
          });
        }
      }));
    }
    await Future.wait(futures);
    return medias;
  }

  Future<void> confirmImport(
    Map<String, Map<String, dynamic>> mediasData,
    LibraryState library,
    Set<String> wanted,
    void Function() setState,
    Set<String> workingOn,
    Set<String> done,
    Set<String> failed
  ) async {
    List<MapEntry<String, Map<String, dynamic>>> entriesList = mediasData.entries.toList();
    entriesList = entriesList.where((entry) => wanted.contains(entry.key) && !library.mediaAlreadyInLibrary(entry.value['name'])).toList();
    entriesList.sort((a, b) => a.key.compareTo(b.key));

    workingOn.addAll(entriesList.map((entry) => entry.key));
    setState();

    // This for loop cannot (most likely) be made concurrent because of rate limits
    for (var data in entriesList) {
      await Future.delayed(Duration(milliseconds: importMillisecondsDelay), () {});
      dynamic id = data.value['id'] ?? data.value['link'];
      data.value.remove('id');
      data.value.remove('name');
      for (int trial = 0; trial < 3; ++trial) {
        try {
          await library.import(id, data.value);
          done.add(data.key);
          workingOn.remove(data.key);
          break;
        }
        catch (e) {
          print('Error importing media.');
          print(data.value['name']);
          print(e);
        }
      }
      if (workingOn.contains(data.key)) {
        workingOn.remove(data.key);
        failed.add(data.key);
      }
      setState();
    }
  }

  Future<void> import(BuildContext context, LibraryState<MT> library) {
    TextEditingController controller = TextEditingController();

    Map<String, Map<String, dynamic>> searchResults = {};
    List<MapEntry<String, Map<String, dynamic>>> searchResultsEntries = [];

    // TODO: This should not be moved in the class if we want the ProviderImporters to be singletons.
    // Alternatively we can move them and instantiate one ProviderImport every time.
    Set<String> wanted = {};
    Set<String> workingOn = {};
    Set<String> done = {};
    Set<String> failed = {};

    bool isGettingOptions = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  Row(
                    children: [
                      Text('Import ${getMediaTypeDbNamePlural(MT)} from $providerName library'),
                      IconButton(
                        onPressed: () {
                          if (workingOn.isEmpty) {
                            Navigator
                              .of(context)
                              .pop();
                          }
                        },
                        icon: Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                  displayLink(howToGetIdLink, 'How to get $providerName $idName'),
                ],
              ),
              content: SizedBox(
                width: 300,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: '$providerName $idName',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                          ),
                          onPressed: () async {
                            String userId = controller.text;
                            if (userId.isNotEmpty && !isGettingOptions) {
                              isGettingOptions = true;
                              setState(() {});
                              searchResults = await _getOptionsForID(userId);
                              isGettingOptions = false;

                              // To show the options in lexicographical order
                              searchResultsEntries = searchResults.entries.toList();
                              searchResultsEntries.sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
                              
                              wanted = searchResults.keys.toSet();
                              if (context.mounted) {
                                setState(() {});
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (isGettingOptions)
                      ...[
                        SizedBox(
                          height: 100,
                        ),
                        loadingWidget(context),
                      ]
                    else
                      ...[
                        if (searchResults.isNotEmpty) // Select / Deselect all
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    wanted = searchResults.keys.toSet();
                                    setState(() {});
                                  },
                                  child: Text('Select all'),
                                  style: greenFillButton(context)
                                    .filledButtonTheme
                                    .style,
                                ),
                                TextButton(
                                  onPressed: () {
                                    wanted = {};
                                    setState(() {});
                                  },
                                  child: Text('Deselect all'),
                                  style: redFillButton(context)
                                    .filledButtonTheme
                                    .style,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 7,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var entry in searchResultsEntries)
                                  Container(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: wanted.contains(entry.key),
                                          onChanged: workingOn.isEmpty
                                            ? (onOff) {
                                                if (onOff == null) {
                                                  return;
                                                }

                                                if (onOff) {
                                                  wanted.add(entry.key);
                                                }
                                                else {
                                                  wanted.remove(entry.key);
                                                }

                                                setState(() {});
                                              }
                                            : null, // This makes the box gray and non changeable when there is an import going on
                                        ),
                                        Expanded(
                                          child: Text(entry.key),
                                        ),
                                        SizedBox(
                                          child: Center(
                                            child: workingOn.contains(entry.key)
                                            ? loadingWidget(context)
                                            : done.contains(entry.key)
                                              ? checkMarkWidget(context)
                                              : failed.contains(entry.key)
                                                ? failMarkWidget(context)
                                                : null,
                                          ),
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ]
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (searchResults.isNotEmpty) // Space for buttons
                          SizedBox(
                            height: 7,
                          ),
                        if (searchResults.isNotEmpty) // Confirm button
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                await confirmImport(searchResults, library, wanted, () => setState(() {}), workingOn, done, failed);
                              },
                              child: Text('Confirm import'),
                              style: greenFillButton(context)
                                .filledButtonTheme
                                .style,
                            ),
                          ),
                        ],
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
