import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opinakanews/model/CustomTheme.dart';

/// Définitions des thèmes de base et méthodes de création/modification de nouveaux thèmes.

/// Light Theme
Color primaryColor = const Color(0xFFffc107);
Color primaryColorDark = const Color(0xFFc79100);
Color secondaryColor = const Color(0xFFb71c1c);
Color secondaryColorDark = const Color(0xFF7f0000);
Color background = const Color(0xFFFFFFFF);
Color textColor = const Color(0xFF000000);

/// Dark Theme
Color darkPrimaryColor = const Color(0xFF1a237e);
Color darkPrimaryColorDark = const Color(0xFF000051);
Color darkSecondaryColor = const Color(0xFF0d47a1);
Color darkSecondaryColorDark = const Color(0xFF002171);
Color darkBackground = const Color(0xFF263238);
Color darkText = const Color(0xFFb0bec5);

class MyTheme {
  static ThemeData defaultTheme = _buildTheme();
  static ThemeData darkTheme = _buildDarkTheme();

  static ColorScheme createScheme(CustomTheme theme) {
    return ColorScheme(
      primary: new Color(theme.primaryColor),
      primaryVariant: new Color(theme.primaryColorDark),
      secondary: new Color(theme.secondaryColor),
      secondaryVariant: new Color(theme.secondaryColorDark),
      surface: new Color(theme.background),
      background: new Color(theme.background),
      error: const Color(0xffb00020),
      onPrimary: new Color(theme.textColor),
      onSecondary: new Color(theme.textColor),
      onSurface: new Color(theme.textColor),
      onBackground: new Color(theme.textColor),
      onError: Colors.white,
      brightness: Brightness.light,
    );
  }

  static fontBlack({BuildContext context, ColorScheme scheme, String font}) {
    DynamicTheme.of(context).setThemeData(ThemeData.from(
        colorScheme: scheme,
        textTheme: new Typography.material2018(platform: defaultTargetPlatform)
            .black
            .apply(fontFamily: font)));
  }

  static fontWhite({BuildContext context, ColorScheme scheme, String font}) {
    DynamicTheme.of(context).setThemeData(ThemeData.from(
        colorScheme: scheme,
        textTheme: new Typography.material2018(platform: defaultTargetPlatform)
            .white
            .apply(fontFamily: font)));
  }

  static changeTheme(BuildContext context, CustomTheme theme) {
    DynamicTheme.of(context).setThemeData(ThemeData.from(
        colorScheme: createScheme(theme),
        textTheme: new Typography.material2018(platform: defaultTargetPlatform)
            .black
            .apply(displayColor: textColor, bodyColor: textColor)));
  }

  static ThemeData _buildTheme() {
    return ThemeData.from(
        colorScheme: ColorScheme(
          primary: primaryColor,
          primaryVariant: primaryColorDark,
          secondary: secondaryColor,
          secondaryVariant: secondaryColorDark,
          surface: background,
          background: background,
          error: const Color(0xffb00020),
          onPrimary: textColor,
          onSecondary: textColor,
          onSurface: textColor,
          onBackground: textColor,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: new Typography.material2018(platform: defaultTargetPlatform)
            .black
            .apply(displayColor: textColor, bodyColor: textColor));
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData.from(
        colorScheme: ColorScheme(
          primary: darkPrimaryColor,
          primaryVariant: darkPrimaryColorDark,
          secondary: darkSecondaryColor,
          secondaryVariant: darkSecondaryColorDark,
          surface: darkPrimaryColor,
          background: darkBackground,
          error: const Color(0xffb00020),
          onPrimary: darkText,
          onSecondary: darkText,
          onSurface: darkText,
          onBackground: darkText,
          onError: Colors.black,
          brightness: Brightness.dark,
        ),
        textTheme: new Typography.material2018(platform: defaultTargetPlatform)
            .white
            .apply(displayColor: darkText, bodyColor: darkText));
  }
}
