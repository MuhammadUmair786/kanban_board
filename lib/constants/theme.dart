import 'package:flutter/material.dart';

const double fontSizeLarge = 16.0;
const double fontSizeMedium = 14.0;
const double fontSizeSmall = 12.0;

enum ThemeName { blue, green, dark, pink, orange }

Map<String, ThemeData> availbleThemes = {
  "Classic Blue Theme": classicBlueTheme,
  "Modern Green Theme": modernGreenTheme,
  "Playful Pink Theme": playfulPinkTheme,
  "vibrant Orange Theme": vibrantOrangeTheme,
};

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

  textTheme: TextTheme(
    titleMedium: const TextStyle(
      color: Colors.green,
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

  textTheme: TextTheme(
    titleMedium: const TextStyle(
      color: Colors.pink,
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

  textTheme: TextTheme(
    titleMedium: const TextStyle(
      color: Colors.orange,
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
