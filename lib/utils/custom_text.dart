import 'package:alandi/config/exported_path.dart';

class CustomText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final int maxLines;
  final TextAlign textAlign;
  final TextStyle? style;

  const CustomText({
    super.key,
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).textTheme.bodyMedium?.color;

    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: style ??
          TextStyle(
            color: defaultColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
    );
  }
}

// class CustomText {
//   static Widget text({
//     required String title,
//     Color? color,
//     required double fontSize,
//     FontWeight? fontWeight = FontWeight.normal,
//     int maxLines = 1,
//     TextAlign textAlign = TextAlign.center,
//   }) {
//     // final formattedTitle = _translate(title);
//     final effectiveColor =
//         color ??
//         (Get.context != null
//             ? Theme.of(Get.context!).textTheme.bodyMedium?.color ?? Colors.black
//             : Colors.black);
//
//     return Text(
//       title,
//       maxLines: maxLines,
//       overflow: TextOverflow.ellipsis,
//       textAlign: textAlign,
//       style: TextStyle(
//         color: effectiveColor,
//         fontSize: fontSize,
//         fontWeight: fontWeight,
//       ),
//     );
//   }
//
//   /// Replaces underscores with spaces and capitalizes each word.
//   // static String _translate(String text) {
//   //   return text.replaceAll('_', ' ').split(' ').map(_capitalize).join(' ');
//   // }
//
//   /// Capitalizes the first letter of a word and lowers the rest.
//   // static String _capitalize(String word) {
//   //   if (word.isEmpty) return word;
//   //   return word[0].toUpperCase() + word.substring(1).toLowerCase();
//   // }
// }

Widget buildSocialIconButton(Widget icon, var onTap) {
  return FilledButton.icon(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.all(8),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: onTap,
    label: icon,
  );
}
