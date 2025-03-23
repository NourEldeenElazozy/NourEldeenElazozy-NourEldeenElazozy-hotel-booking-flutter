import 'package:flutter/material.dart';
import '../constants/my_colors.dart';

class Themes {

 static ThemeData lightTheme = ThemeData(

    scaffoldBackgroundColor: MyColors.scaffoldLightColor,
    primaryColor: MyColors.primaryColor,
    dividerColor: MyColors.dividerLightTheme,
    dividerTheme: const DividerThemeData(
      color: MyColors.dividerLightTheme,
    ),
    fontFamily: 'Tajawal',
    // fontFamily: GoogleFonts.urbanist().fontFamily,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      backgroundColor: MyColors.scaffoldLightColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyColors.scaffoldLightColor,
      selectedItemColor: MyColors.black,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: MyColors.textBlackColor,
      ),
      headlineSmall: TextStyle(
          color: MyColors.textBlackColor,
      ),
      headlineMedium: TextStyle(
          color: MyColors.textBlackColor,
      ),
      bodyLarge: TextStyle(
          color: MyColors.textBlackColor,
      ),
      bodyMedium: TextStyle(
          color: MyColors.textBlackColor,
      ),
      bodySmall: TextStyle(
          color: MyColors.textBlackColor,
      ),
      displayLarge: TextStyle(
          color: MyColors.textBlackColor,
      ),
      displayMedium: TextStyle(
          color: MyColors.textBlackColor,
      ),
      displaySmall: TextStyle(
          color: MyColors.textBlackColor,
      ),
      labelLarge: TextStyle(
          color: MyColors.textBlackColor,
      ),
      titleLarge: TextStyle(
          color:  MyColors.textBlackColor,
      ),
      titleSmall: TextStyle(
          color: MyColors.textBlackColor,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.searchTextFieldColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: MyColors.scaffoldLightColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryColor,
        elevation: 10,
        foregroundColor: MyColors.white,
        shadowColor: MyColors.focusButtonColor,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        )
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: MyColors.scaffoldLightColor,
      iconColor: MyColors.black,
      collapsedIconColor: MyColors.black,
    ),
  );

 static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: MyColors.scaffoldDarkColor,
    dividerTheme: const DividerThemeData(
      color: MyColors.dividerDarkTheme,
    ),
    fontFamily: 'Tajawal',
    // fontFamily: GoogleFonts.urbanist().fontFamily,
    primaryTextTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        titleLarge: TextStyle(
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
        )),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: MyColors.scaffoldDarkColor,
      // foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyColors.scaffoldDarkColor,
      selectedItemColor: MyColors.white,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.white,
      ),
      headlineSmall: TextStyle(
          color: Colors.white,
      ),
      headlineMedium: TextStyle(
          color: Colors.white,
      ),
      bodyLarge: TextStyle(
          color: Colors.white,
      ),
      bodyMedium: TextStyle(
          color: Colors.white,
  ),
      bodySmall: TextStyle(
          color: Colors.white,
      ),
      displayLarge: TextStyle(
          color: Colors.white,
      ),
      displayMedium: TextStyle(
          color: Colors.white,
      ),
      displaySmall: TextStyle(
          color: Colors.white,
      ),
      labelLarge: TextStyle(
          color: Colors.white,
      ),
      titleLarge: TextStyle(
          color:  Colors.white,
      ),
      titleSmall: TextStyle(
          color: Colors.white,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: MyColors.scaffoldDarkColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: MyColors.scaffoldDarkColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.successColor,
        elevation: 10,
        foregroundColor: MyColors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: MyColors.darkTextFieldColor,
      iconColor: MyColors.white,
      textColor: MyColors.white,
      collapsedIconColor: MyColors.white,
      collapsedTextColor: MyColors.white,
    ),
  );
}
