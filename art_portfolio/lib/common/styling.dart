import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF0A73FF);
  static const Color secondaryColor = Color.fromARGB(255, 0, 162, 146);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  static const Color cardColor = Color.fromARGB(255, 237, 237, 237);
  static const Color appBarColor = Color.fromARGB(255, 69, 188, 176);
  static const Color textColor = Color(0xFF000000);
  static const Color buttonColor = Color(0xFF0A73FF);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
    fontFamily: 'Roboto',
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    color: AppColors.textColor,
    fontFamily: 'Roboto',
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonTextColor,
    fontFamily: 'Roboto',
  );
}

class AppButtonStyles {
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    foregroundColor: AppColors.buttonColor,
    backgroundColor: AppColors.buttonTextColor,
    textStyle: AppTextStyles.buttonText,
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    foregroundColor: AppColors.buttonTextColor, backgroundColor: AppColors.secondaryColor,
    textStyle: AppTextStyles.buttonText,
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.bodyText,
      labelLarge: AppTextStyles.buttonText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.primaryButton,
    ),
  );
}