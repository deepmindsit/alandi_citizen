import 'package:alandi/config/exported_path.dart';

class OnboardingPage extends StatelessWidget {
  final String description;
  final String title;
  final String image;
  final VoidCallback onNextPressed;

  const OnboardingPage({
    super.key,
    required this.description,
    required this.title,
    required this.image,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.1, 0.9],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            blueColor,
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Text(
              description.tr,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: Get.height * 0.05),
            Center(
              child: Image.asset(
                image,
                width: Get.width * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
