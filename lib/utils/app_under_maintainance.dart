import 'package:alandi/config/exported_path.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({
    super.key,
    required this.msg,
  });

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_maintenance.png'),
            Text(
              'Under Maintenance',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.06),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(Get.width * 0.2, 40),
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(color: textColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
