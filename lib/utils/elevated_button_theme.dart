import '../config/exported_path.dart';

class MElevatedButtonTheme {
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: primaryBlack,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    side: BorderSide(color: primaryBlack),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    textStyle: const TextStyle(
        fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ));

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: primaryBlack,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    side: BorderSide(color: primaryBlack),
    padding: const EdgeInsets.symmetric(vertical: 18),
    textStyle: const TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ));
}
