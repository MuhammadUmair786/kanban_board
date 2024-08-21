import 'package:flutter/material.dart';

const double fontSizeLarge = 16.0;
const double fontSizeMedium = 14.0;
const double fontSizeSmall = 12.0;

Map<String, ThemeData> availbleThemes = {
  "classicBlueTheme": classicBlueTheme,
  "modernGreenTheme": modernGreenTheme,
  "darkMinimalistTheme": darkMinimalistTheme,
  "playfulPinkTheme": playfulPinkTheme,
  "vibrantOrangeTheme": vibrantOrangeTheme,
};

// Classic Blue Theme
final ThemeData classicBlueTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    brightness: Brightness.light,
  ),
  // Define font sizes in a separate variable

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge * 2.0),
    displayMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeLarge * 1.5),
    displaySmall: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeMedium * 1.5),
    headlineSmall: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 1.2),
    titleSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    bodyLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    bodyMedium: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    bodySmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    labelMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 0.8),
  ),
  iconTheme: const IconThemeData(color: Colors.blue),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.blue, // Button background color
      shadowColor:
          Colors.blue[800], // Button shadow color (darker shade of blue)
    ),
  ),
);

// Modern Green Theme
final ThemeData modernGreenTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.black, fontSize: fontSizeLarge * 2.0), // Adjust as needed
    displayMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeLarge * 1.5),
    displaySmall: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeMedium * 1.5),
    headlineSmall: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 1.2),
    titleSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    bodyLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    bodyMedium: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    bodySmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    labelMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 0.8),
  ),
  iconTheme: const IconThemeData(color: Colors.green),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.green, // Button background color
      shadowColor:
          Colors.green[800], // Button shadow color (darker shade of green)
    ),
  ),
);

// Dark Minimalist Theme
final ThemeData darkMinimalistTheme = ThemeData(
  colorScheme: const ColorScheme.dark(),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.white, fontSize: fontSizeLarge * 2.0), // Adjust as needed
    displayMedium:
        TextStyle(color: Colors.white, fontSize: fontSizeLarge * 1.5),
    displaySmall: TextStyle(color: Colors.white, fontSize: fontSizeLarge),
    headlineLarge: TextStyle(color: Colors.white, fontSize: fontSizeLarge),
    headlineMedium:
        TextStyle(color: Colors.white, fontSize: fontSizeMedium * 1.5),
    headlineSmall: TextStyle(color: Colors.white, fontSize: fontSizeMedium),
    titleLarge: TextStyle(color: Colors.white, fontSize: fontSizeMedium),
    titleMedium: TextStyle(color: Colors.white, fontSize: fontSizeSmall * 1.2),
    titleSmall: TextStyle(color: Colors.white, fontSize: fontSizeSmall),
    bodyLarge: TextStyle(color: Colors.white, fontSize: fontSizeLarge),
    bodyMedium: TextStyle(color: Colors.white, fontSize: fontSizeMedium),
    bodySmall: TextStyle(color: Colors.white, fontSize: fontSizeSmall),
    labelLarge: TextStyle(color: Colors.white, fontSize: fontSizeMedium),
    labelMedium: TextStyle(color: Colors.white, fontSize: fontSizeSmall),
    labelSmall: TextStyle(color: Colors.white, fontSize: fontSizeSmall * 0.8),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, // Button text color
      backgroundColor: Colors.white, // Button background color
      shadowColor:
          Colors.grey[800], // Button shadow color (darker shade of grey)
    ),
  ),
);

// Playful Pink Theme
final ThemeData playfulPinkTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.pink,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.black, fontSize: fontSizeLarge * 2.0), // Adjust as needed
    displayMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeLarge * 1.5),
    displaySmall: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeMedium * 1.5),
    headlineSmall: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 1.2),
    titleSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    bodyLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    bodyMedium: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    bodySmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    labelMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 0.8),
  ),
  iconTheme: const IconThemeData(color: Colors.pink),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.pink,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.pink, // Button background color
      shadowColor:
          Colors.pink[800], // Button shadow color (darker shade of pink)
    ),
  ),
);

// Vibrant Orange Theme
final ThemeData vibrantOrangeTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.orange,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.black, fontSize: fontSizeLarge * 2.0), // Adjust as needed
    displayMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeLarge * 1.5),
    displaySmall: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    headlineMedium:
        TextStyle(color: Colors.black, fontSize: fontSizeMedium * 1.5),
    headlineSmall: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    titleMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 1.2),
    titleSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    bodyLarge: TextStyle(color: Colors.black, fontSize: fontSizeLarge),
    bodyMedium: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    bodySmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelLarge: TextStyle(color: Colors.black, fontSize: fontSizeMedium),
    labelMedium: TextStyle(color: Colors.black, fontSize: fontSizeSmall),
    labelSmall: TextStyle(color: Colors.black, fontSize: fontSizeSmall * 0.8),
  ),
  iconTheme: const IconThemeData(color: Colors.orange),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.orange, // Button background color
      shadowColor:
          Colors.orange[800], // Button shadow color (darker shade of orange)
    ),
  ),
);
