// This file contains themes that we use throughout the app. This way we only need to modify this file.

import 'package:flutter/material.dart';

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