import 'package:alandi/config/exported_path.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryBlack,
    splashColor: Colors.black,
    dividerColor: const Color(0xFF515151),
    inputDecorationTheme: MTextFormField.lightInputDecorationTheme,
    elevatedButtonTheme: MElevatedButtonTheme.lightElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryBlack,
    dividerColor: const Color(0xFF515151),
    splashColor: Colors.white,
    inputDecorationTheme: MTextFormField.darkInputDecorationTheme,
    elevatedButtonTheme: MElevatedButtonTheme.darkElevatedButtonTheme,
  );
}
