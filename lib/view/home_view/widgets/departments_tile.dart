import 'package:alandi/config/exported_path.dart';

class DepartmentTile extends StatelessWidget {
  const DepartmentTile(
      {super.key,
      required this.department,
      required this.isLink,
      required this.image,
      required this.onTap,
      required this.dept});

  final String department;
  final String image;
  final bool isLink;
  final void Function()? onTap;
  final String dept;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: Get.width * 0.3,
          height: Get.width * 0.4,
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 2),
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 5.0,
                ),
              ],
              color: Colors.white,
              border: Border.all(
                width: 0.5,
                color: Colors.black.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                image,
                height: Get.height * 0.07,
              ),
              Text(
                dept,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(height: 1),
              ),
            ],
          )),
    );
  }
}
