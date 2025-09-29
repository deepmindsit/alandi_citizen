import 'package:alandi/config/exported_path.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({super.key});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final controller = getIt<OnboardingController>();

  @override
  void initState() {
    controller.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.white,
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.1,
              ),
              _buildSlider(),
              Container(
                height: Get.height * 0.2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your Mobile Number'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.8,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: controller.numberController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) => value!.isEmpty
                                ? 'Enter your Mobile Number'.tr
                                : !value.contains(RegExp(r'^[6-9]\d{9}$'))
                                    ? 'Enter valid phone number'.tr
                                    : null,
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/india_flag.png',
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(8),
                              labelText: 'Mobile Number'.tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            if (controller.formKey.currentState!.validate()) {
                              Get.dialog(FutureBuilder(
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<Map<String, dynamic>> snapshot,
                                ) {
                                  List<Widget> children;
                                  if (snapshot.hasData) {
                                    controller.data = snapshot.data;
                                    if (controller.data!['common']['status'] ==
                                        true) {
                                      Future.delayed(const Duration(seconds: 2),
                                          () async {
                                        controller.data['data']
                                                    ['is_user_exist'] ==
                                                true
                                            ? Get.offAll(() => OtpVerification(
                                                  number: controller
                                                      .numberController.text,
                                                ))
                                            : Get.offAll(() => Signup(
                                                  number: controller
                                                      .numberController.text,
                                                ));
                                      });

                                      children = <Widget>[
                                        const Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                          size: 60,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Text(
                                            controller.data['common']
                                                ['message'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ];
                                    } else {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Get.back();
                                      });
                                      children = <Widget>[
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Text(
                                            controller.data['common']
                                                ['message'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ];
                                    }
                                  } else {
                                    Future.delayed(const Duration(seconds: 10),
                                        () {
                                      Get.back();
                                    });

                                    children = <Widget>[
                                      const SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircularProgressIndicator(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          'Processing'.tr,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      )
                                    ];
                                  }
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    content: SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: children,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                future: controller.sendOtp(
                                  mobileNo: controller.numberController.text,
                                ),
                              ));
                            }
                          },
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 40,
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Expanded(
      flex: 9,
      child: PageView.builder(
        reverse: false,
        controller: controller.pageController,
        itemCount: controller.onboardingData.length,
        itemBuilder: (context, index) {
          return OnboardingPage(
            description: controller.onboardingData[index]['description'],
            image: controller.onboardingData[index]['image'],
            onNextPressed: controller.navigateToNextPage,
            title: controller.onboardingData[index]['title'],
          );
        },
        onPageChanged: (int page) {
          controller.currentPage.value = page.toDouble();
        },
      ),
    );
  }
}
