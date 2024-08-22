import 'package:flutter/material.dart';

const double fontSizeLarge = 16.0;
const double fontSizeMedium = 14.0;
const double fontSizeSmall = 12.0;

enum ThemeName { blue, green, dark, pink, orange }

Map<String, ThemeData> availbleThemes = {
  "Classic Blue Theme": classicBlueTheme,
  "Modern Green Theme": modernGreenTheme,
  "Dark Minimalist Theme": darkMinimalistTheme,
  "Playful Pink Theme": playfulPinkTheme,
  "vibrant Orange Theme": vibrantOrangeTheme,
};

// String getThemName(String tempName){
//   if(tempName)

// }

// Classic Blue Theme
final ThemeData classicBlueTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.blue, // Base color

    secondary: Color(0xFF64B5F6), // Lighter shade of blue for accents
    onPrimary: Colors.white, // Text color on primary color
    onSecondary: Colors.black, // Light blue background
    surface: Colors.white, // Background color of surfaces like cards
    onSurface: Colors.black, // Text color on surface
    brightness: Brightness.light,
  ),

  textTheme: TextTheme(
    titleMedium: const TextStyle(
      color: Colors.blue,
      fontSize: fontSizeLarge,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      color: Colors.grey[700],
      fontSize: fontSizeMedium,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: const TextStyle(
      color: Colors.black,
      fontSize: fontSizeSmall,
    ),
  ),

  iconTheme:
      const IconThemeData(color: Color(0xFF1565C0)), // Darker blue for icons
  scaffoldBackgroundColor:
      const Color(0xFFE3F2FD), // Light blue background color
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white), // White icons in AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.blue, // Button background color
      shadowColor:
          Colors.blue[800], // Button shadow color (darker shade of blue)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // White background for input fields
    border: InputBorder.none,
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.blue,
    )),
    labelStyle: const TextStyle(
      color: Color(0xFF1565C0),
    ), // Darker blue for labels
    hintStyle: TextStyle(color: Colors.grey[300]), // Lighter blue for hints
  ),
);

// Modern Green Theme
final ThemeData modernGreenTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.green, // Base color

    secondary: Color(0xFF81C784), // Lighter shade of green for accents
    onPrimary: Colors.white, // Text color on primary color
    onSecondary: Colors.black, // Light green background
    surface: Colors.white, // Background color of surfaces like cards
    onSurface: Colors.black, // Text color on surface
    brightness: Brightness.light,
  ),

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

  iconTheme:
      const IconThemeData(color: Color(0xFF2E7D32)), // Darker green for icons
  scaffoldBackgroundColor:
      const Color(0xFFE8F5E9), // Light green background color
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white), // White icons in AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.green, // Button background color
      shadowColor:
          Colors.green[800], // Button shadow color (darker shade of green)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // White background for input fields
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.green), // Green border for input fields
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFF2E7D32)), // Darker green when focused
    ),
    labelStyle: TextStyle(color: Color(0xFF2E7D32)), // Darker green for labels
    hintStyle: TextStyle(color: Colors.greenAccent), // Lighter green for hints
  ),
);

// Dark Minimalist Theme
final ThemeData darkMinimalistTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Colors.grey, // Base color
    secondary: Color(0xFF616161), // Lighter shade of grey for accents
    onPrimary: Colors.white, // Text color on primary color
    onSecondary: Colors.white, // Dark background color
    surface: Color(0xFF1E1E1E), // Slightly lighter surface color
    onSurface: Colors.white, // Text color on surface
    brightness: Brightness.dark,
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: fontSizeLarge * 2.0),
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

  iconTheme:
      const IconThemeData(color: Color(0xFFB0BEC5)), // Light grey for icons
  scaffoldBackgroundColor: const Color(0xFF121212), // Dark background color
  appBarTheme: const AppBarTheme(
    backgroundColor:
        Color(0xFF1E1E1E), // Slightly lighter background for AppBar
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white), // White icons in AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, // Button text color
      backgroundColor: Colors.white, // Button background color
      shadowColor:
          Colors.grey[800], // Button shadow color (darker shade of grey)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E), // Darker background for input fields
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.grey), // Grey border for input fields
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFFB0BEC5)), // Light grey when focused
    ),
    labelStyle: TextStyle(color: Color(0xFFB0BEC5)), // Light grey for labels
    hintStyle: TextStyle(color: Colors.grey), // Grey for hints
  ),
);

// Playful Pink Theme
final ThemeData playfulPinkTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.pink, // Base color
    secondary: Color(0xFFEC407A), // Lighter shade of pink for accents
    onPrimary: Colors.white, // Text color on primary color
    onSecondary: Colors.black, // Very light pink background
    surface: Colors.white, // Background color of surfaces like cards
    onSurface: Colors.black, // Text color on surface
    brightness: Brightness.light,
  ),

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

  iconTheme:
      const IconThemeData(color: Color(0xFFC2185B)), // Darker pink for icons
  scaffoldBackgroundColor:
      const Color(0xFFFFEBEE), // Very light pink background color
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.pink,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white), // White icons in AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.pink, // Button background color
      shadowColor:
          Colors.pink[800], // Button shadow color (darker shade of pink)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // White background for input fields
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.pink), // Pink border for input fields
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFFC2185B)), // Darker pink when focused
    ),
    labelStyle: TextStyle(color: Color(0xFFC2185B)), // Darker pink for labels
    hintStyle: TextStyle(color: Colors.pinkAccent), // Lighter pink for hints
  ),
);

// Vibrant Orange Theme
final ThemeData vibrantOrangeTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.orange, // Base color
    secondary: Color(0xFFFFA000), // Lighter shade of orange for accents
    onPrimary: Colors.white, // Text color on primary color
    onSecondary: Colors.black, // Very light orange background
    surface: Colors.white, // Background color of surfaces like cards
    onSurface: Colors.black, // Text color on surface
    brightness: Brightness.light,
  ),

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

  iconTheme:
      const IconThemeData(color: Color(0xFFEF6C00)), // Darker orange for icons
  scaffoldBackgroundColor:
      const Color(0xFFFFF3E0), // Very light orange background
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white), // White icons in AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Button text color
      backgroundColor: Colors.orange, // Button background color
      shadowColor: const Color(0xFFBF360C), // Darker orange for button shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // White background for input fields
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.orange), // Orange border for input fields
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFFEF6C00)), // Darker orange when focused
    ),
    labelStyle: TextStyle(color: Color(0xFFEF6C00)), // Darker orange for labels
    hintStyle: TextStyle(color: Color(0xFFFFA000)), // Lighter orange for hints
  ),
);
