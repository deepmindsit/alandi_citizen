import 'package:alandi/config/exported_path.dart';
import 'package:intl/intl.dart';

Widget sectionTitleWithIcon(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: CustomText(
      title: title,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}

Widget buildDetailRow({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBox(icon: icon, size: 20, color: Colors.blue.shade700),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Color getFileTypeColor(String extension) {
  switch (extension) {
    case 'pdf':
      return Colors.red.shade400;
    case 'doc':
    case 'docx':
      return Colors.blue.shade400;
    case 'xls':
    case 'xlsx':
      return Colors.green.shade400;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Colors.purple.shade400;
    case 'zip':
    case 'rar':
      return Colors.orange.shade400;
    default:
      return primaryOrange;
  }
}

IconData getIconForFile(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  if (['jpg', 'jpeg', 'png'].contains(ext)) return Icons.image;
  if (['pdf'].contains(ext)) return Icons.picture_as_pdf;
  if (['xls', 'xlsx'].contains(ext)) return Icons.grid_on;
  return Icons.insert_drive_file;
}

class IconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconBox({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}

String formatDate(String dateString) {
  final dateTime =
      DateTime.parse(dateString).toLocal(); // Optional: convert to local time
  final formatter = DateFormat('dd MMM yyyy, hh:mm a');
  return formatter.format(dateTime);
}
