// This file contains themes that we use throughout the app. This way we only need to modify this file.

import 'package:flutter/material.dart';

// All button styles get set using the filledButtonTheme as that member has a .style property.
ThemeData greenFillButton(BuildContext context) => ThemeData(
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.light
          ? Color.fromARGB(255, 10, 210, 10)
          : Color.fromARGB(255, 0, 150, 0),
      ),
      foregroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.light
          ? Color.fromARGB(255, 32, 32, 64)
          : Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  ),
);

ThemeData redFillButton(BuildContext context) => ThemeData(
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.light
          ? Color.fromARGB(255, 220, 20, 20)
          : Color.fromARGB(255, 255, 0, 0),
      ),
      foregroundColor: WidgetStatePropertyAll(
        Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  ),
);

ThemeData redNotFilledButton(BuildContext context) => ThemeData(
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.light
          ? Color.fromARGB(255, 230, 0, 0)
          : Color.fromARGB(255, 200, 0, 0),
      ),
    ),
  ),
);

ThemeData navigationButton(BuildContext context) => ThemeData(
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.light
          ? Color.fromARGB(255, 100, 100, 100)
          : Color.fromARGB(255, 100, 100, 100),
      ),
      foregroundColor: WidgetStatePropertyAll(
        Theme.of(context).brightness == Brightness.light
          ? Color.fromARGB(255, 255, 255, 255)
          : Color.fromARGB(255, 255, 255, 255),
      ),
    ),
  ),
);