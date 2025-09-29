import 'package:alandi/config/exported_path.dart';

Color primaryColor = const Color(0xffd58033);
Color primaryBlack = const Color(0xFF1C1C1C);
Color primaryGrey = const Color(0xFFC4C4C4);
Color primaryGreen = const Color(0xFF03AF29);
Color secondaryGreen = const Color(0xFFD4FFDD);
Color primaryRed = const Color(0xFFEE0101);
Color secondaryRed = const Color(0xFFFFD6D6);
Color primaryOrange = const Color(0xFFFF7C03);
Color secondaryOrange = const Color(0xFFFFE6CF);
Color secondaryBlue = const Color(0xFFD7DFFC);
Color textColor = const Color(0xFF0032E5);
Color blueColor = const Color(0xFF90CAF9);

InputBorder errorBorder = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Colors.red,
  ),
  borderRadius: BorderRadius.circular(4),
);

InputBorder enabledBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.black,
  ),
);

InputBorder focusedBorder = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Colors.black,
  ),
  borderRadius: BorderRadius.circular(4),
);
