import 'package:alandi/config/exported_path.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final int color;

  const StatusBadge({super.key, required this.status, this.color = 0xff000000});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomText(
        title: status,
        color: Color(color),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
