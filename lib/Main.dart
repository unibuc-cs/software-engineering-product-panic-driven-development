import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'Models/seed_data.dart';

import 'Auth/signup_screen.dart';
import 'Auth/signup_bloc.dart';
import 'Auth/login_screen.dart';
import 'Auth/login_bloc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  await Supabase.initialize(
    url: env['URL_SUPABASE'] ?? 'default_value',
    anonKey: env['ANON_KEY_SUPABASE'] ?? 'default_value',
  );

  addSeedData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.light(primary: const Color.fromARGB(219, 10, 94, 87)),
      ),
      dark: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(primary: const Color.fromARGB(219, 10, 94, 87)),
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
  //function for testing database connection
  Future<void> insertPublisher() async {
  final response = await Supabase.instance.client
      .from('publisher')
      .insert({'name': 'Test Publisher'});

  if (response.error != null) {
    // Handle error
    // print("Error inserting publisher: ${response.error.message}");
  }
  else {
    // print("Publisher inserted successfully.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => SignUpBloc(),
                          child: const SignUpScreen(),
                        )));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(219, 10, 94, 87)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => LoginBloc(),
                          child: const LoginScreen(),
                        )));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(219, 10, 94, 87)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Log in'),
            ),

          ],
        ),
      ),
    );
  }
}


