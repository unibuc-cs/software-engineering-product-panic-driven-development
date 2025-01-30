import 'package:mediamaster/Auth/guest_account.dart';
import 'package:mediamaster/Menu.dart';
import 'package:mediamaster/Widgets/themes.dart';

import 'Helpers/database.dart';
import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'Auth/signup_screen.dart';
import 'Auth/signup_bloc.dart';
import 'Auth/login_screen.dart';
import 'Auth/login_bloc.dart';

void main() async {
  DotEnv(includePlatformEnvironment: true)..load();

  await HydrateWithoutUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void preloadImages(BuildContext context) {
    var mapping = MenuState.mapping;
    for (MenuMediaType type in mapping.keys) {
      if (mapping[type]!['backgroundImage'] == null) {
        final imageProvider =
            NetworkImage(mapping[type]!['backgroundImageHref'] as String);
        mapping[type]!['backgroundImage'] = imageProvider;
        precacheImage(imageProvider, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    preloadImages(context);

    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Color.fromARGB(255, 0, 0, 190),
        ),
      ),
      dark: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Color.fromARGB(255, 150, 150, 255),
        ),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'MediaMaster',
        theme: theme,
        darkTheme: darkTheme,
        home: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    guestCreationStage currentGuestStage = guestCreationStage.notStarted;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                      ? AdaptiveTheme.of(context).setDark()
                      : AdaptiveTheme.of(context).setLight();
                },
                icon: const Icon(Icons.dark_mode),
                tooltip: 'Toggle dark mode',
              ),
            ],
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    if (currentGuestStage != guestCreationStage.notStarted) {
                      return;
                    }

                    Navigator
                      .of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => SignUpBloc(),
                            child: const SignUpScreen(),
                          )
                        )
                      );
                  },
                  style: navigationButton(context)
                    .filledButtonTheme
                    .style,
                  child: const Text('Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                    if (currentGuestStage != guestCreationStage.notStarted) {
                      return;
                    }
                    
                    Navigator
                      .of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => LoginBloc(),
                                child: const LoginScreen(),
                          )
                        )
                      );
                  },
                  style: navigationButton(context)
                    .filledButtonTheme
                    .style,
                  child: const Text('Log in'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentGuestStage == guestCreationStage.workingOn)
                      ...[
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    TextButton(
                      onPressed: () async {
                        if (currentGuestStage != guestCreationStage.notStarted) {
                          return;
                        }

                        currentGuestStage = guestCreationStage.workingOn;
                        setState(() {});
                        await createGuestUser();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Menu(),
                        ));
                        currentGuestStage = guestCreationStage.notStarted;
                      },
                      style: navigationButton(context)
                        .filledButtonTheme
                        .style,
                      child: const Text('Try as guest'),
                    ),
                    if (currentGuestStage == guestCreationStage.workingOn)
                      ...[
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 30,
                          width : 30,
                          child : loadingWidget(context),
                        ),
                      ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


