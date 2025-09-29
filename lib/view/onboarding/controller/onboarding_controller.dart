// import 'dart:developer' as developer;
import 'package:alandi/config/exported_path.dart';

@lazySingleton
class OnboardingController extends GetxController {
  final currentPage = 0.0.obs;
  final isLoading = false.obs;
  dynamic data;
  Timer? timer;
  final pageController = PageController(initialPage: 0);
  final numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final language = getIt<LanguageController>();
  List<Map<String, dynamic>> onboardingData = [
    {
      'description': 'slider1Text',
      'image': 'assets/images/onboarding2.png',
      'title': 'Register Complaint',
    },
    {
      'description': 'slider2Text',
      'image': 'assets/images/onboarding3.png',
      'title': 'Track Complaint',
    },
    {
      'description': 'slider3Text',
      'image': 'assets/images/onboarding.png',
      'title': 'Be a Responsible Citizen',
    },
  ].obs;

  void navigateToNextPage() {
    if (pageController.page! < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (currentPage < 2) {
        currentPage.value++;
      }
      // else {
      //   currentPage.value = 0;
      // }

      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage.toInt(),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<Map<String, dynamic>> verify({
    required String mobileNo,
    required String otp,
  }) async {
    final res = await apiClient.post(
      Urls.verifyOtp,
      {
        'mobile_no': mobileNo,
        'otp': otp,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      },
    );

    // final url = Uri.parse(Urls.verifyOtp);
    // final response = await http.post(
    //   url,
    //   headers: {'Authorization': 'Bearer demo'},
    //   body: {
    //     'mobile_no': mobileNo,
    //     'otp': otp,
    //     'lang': language.isEnglish.value ? 'en' : 'mr',
    //   },
    // );
    // Map<String, dynamic> res =
    //     json.decode(response.body) as Map<String, dynamic>;

    // developer.log(res.toString());
    return res;
  }

  Future<Map<String, dynamic>> sendOtp({
    required String mobileNo,
  }) async {
    final res = await apiClient.post(
      Urls.sendOtp,
      {
        'mobile_no': mobileNo,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      },
    );
print(res);
    // final url = Uri.parse(Urls.sendOtp);
    // final response = await http.post(
    //   url,
    //   headers: {'Authorization': 'Bearer demo'},
    //   body: {
    //     'mobile_no': mobileNo,
    //     'lang': language.isEnglish.value ? 'en' : 'mr',
    //   },
    // );
    // Map<String, dynamic> res =
    //     json.decode(response.body) as Map<String, dynamic>;

    return res;
  }

  Future<Map<String, dynamic>> register({
    required String mobileNo,
    required String name,
    required String otp,
  }) async {
    final res = await apiClient.post(
      Urls.register,
      {
        'mobile_no': mobileNo,
        'name': name,
        'otp': otp,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      },
    );
    // print(res);
    return res;
  }
}
