import 'package:mediamaster/Widgets/themes.dart';
import 'UserSystem.dart';
import 'Main.dart';
import 'Library.dart';
import 'Models/game.dart';
import 'Models/book.dart';
import 'Models/anime.dart';
import 'Models/manga.dart';
import 'Models/movie.dart';
import 'Models/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'ProfilePage.dart'; 
import 'UserListPage.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(primary: const Color.fromARGB(219, 10, 94, 87)),
      ),
      dark: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: const Color.fromARGB(219, 10, 94, 87)),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'MediaMaster',
        theme: theme,
        darkTheme: darkTheme,
        home: const Menu(),
      ),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

enum MenuMediaType { Game, Book, Anime, Manga, Movie, TV_Series }

class MenuState extends State<Menu> {
  static Map<MenuMediaType, Map<String, dynamic>> mapping = {
    MenuMediaType.Anime: {
      'backgroundImageHref': 'https://wallpaperaccess.com/full/39033.png',
      'name': 'Anime',
      'library': Library<Anime>(isWishlist: false),
    },
    MenuMediaType.Book: {
      'backgroundImageHref': 'https://i.imgur.com/E15s94V.jpg',
      'name': 'Books',
      'library': Library<Book>(isWishlist: false),
    },
    MenuMediaType.Game: {
      'backgroundImageHref': 'https://i.imgur.com/IjfhWy4.jpeg',
      'name': 'Games',
      'library': Library<Game>(isWishlist: false),
    },
    MenuMediaType.Manga: {
      'backgroundImageHref': 'https://i.imgur.com/spRpvE7.png',
      'name': 'Manga',
      'library': Library<Manga>(isWishlist: false),
    },
    MenuMediaType.Movie: {
      'backgroundImageHref': 'https://wallpaperset.com/w/full/2/7/8/366144.jpg',
      'name': 'Movies',
      'library': Library<Movie>(isWishlist: false),
    },
    MenuMediaType.TV_Series: {
      'backgroundImageHref': 'https://wallpaperaccess.com/full/3726170.jpg',
      'name': 'TV Series',
      'library': Library<TVSeries>(isWishlist: false),
    },
  };

  List<List<MenuMediaType>> matrixOrder = [
    [
      MenuMediaType.Game,
      MenuMediaType.Anime,
      MenuMediaType.Movie,
    ],
    [
      MenuMediaType.Book,
      MenuMediaType.Manga,
      MenuMediaType.TV_Series,
    ],
  ];

  @override
  Widget build(BuildContext context) {
    String userIdToNavigate = UserSystem.instance.getCurrentUserId();
    MenuMediaType currentRendering = MenuMediaType.Game;
    Map<MenuMediaType, bool> hoverState = {
      for (var type in MenuMediaType.values) type: false
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                  ? AdaptiveTheme.of(context).setDark()
                  : AdaptiveTheme.of(context).setLight();
            },
            icon: const Icon(Icons.dark_mode),
            tooltip: 'Toggle dark mode',
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UserListPage()),
              );
            },
            style: navigationButton(context).filledButtonTheme.style,
            child: Text('See Users'),
          ),
           TextButton(
             onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfilePage(userId: UserSystem.instance.getCurrentUserId())),
              );
            },
            style: navigationButton(context)
              .filledButtonTheme
              .style,
            child: Text(UserSystem.instance.currentUserData!['name']),
          ),
          IconButton(
            onPressed: () async {
              UserSystem.instance.logout();
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          Widget option(MenuMediaType type) => MouseRegion(
                onEnter: (_) {
                  setState(() {
                    currentRendering = type;
                    hoverState[type] = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    hoverState[type] = false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => mapping[type]!['library']!,
                    ));
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 50,
                      minWidth: 130,
                    ),
                    decoration: BoxDecoration(
                      color: (hoverState[type] ?? false) ? Colors.greenAccent : Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Card(
                      child: Center(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: Text(
                          mapping[type]!['name'],
                          style: titleStyle.copyWith(
                          fontSize: (hoverState[type] ?? false) ? 19 : 18,
                          // fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                        ),
                      ),
                      borderOnForeground: true,
                    ),
                  ),
                ),
              );

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(mapping[currentRendering]!['backgroundImageHref']),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (List<MenuMediaType> row in matrixOrder)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (MenuMediaType type in row) option(type),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

}
