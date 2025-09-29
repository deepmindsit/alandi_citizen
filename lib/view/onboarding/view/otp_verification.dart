import '../../../config/exported_path.dart';

class OtpVerification extends StatefulWidget {
  final String number;

  const OtpVerification({super.key, required this.number});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final otpController = OtpFieldController();
  final _formKey = GlobalKey<FormState>();
  String otp = '';
  Timer? countdownTimer;
  int _start = 30;
  dynamic data;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    countdownTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resendOTP() {
    setState(() {
      _start = 30;
    });
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/alandi_fevicon.png',
                  height: Get.height * 0.3,
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Text(
                  'Confirm OTP'.tr,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  'A verification code has been sent to ${widget.number}'.tr,
                  style: TextStyle(fontSize: 16, color: primaryGrey),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                OTPTextField(
                  fieldStyle: FieldStyle.box,
                  controller: otpController,
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: MediaQuery.of(context).size.height * 0.06,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  keyboardType: TextInputType.number,
                  onChanged: (pin) {
                    otp = pin;
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                _start == 0
                    ? GestureDetector(
                        onTap: () {
                          resendOTP();
                          OnboardingController().sendOtp(
                            mobileNo: widget.number,
                          );
                        },
                        child: Text(
                          'Resend OTP'.tr,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ))
                    : Text(
                        'Resend OTP in 00 : ${_start.toString()} seconds'.tr),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05, vertical: 11),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 40),
                      ),
                    ),
                    onPressed: otp.length != 6
                        ? () {}
                        : () {
                            Get.dialog(FutureBuilder(
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<Map<String, dynamic>> snapshot,
                              ) {
                                List<Widget> children;
                                if (snapshot.hasData) {
                                  data = snapshot.data;
                                  if (data!['common']['status'] == true) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () async {
                                      var prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'auth_key', data['user']['auth_key']);
                                      prefs.setString(
                                          'user_id', data['user']['id'].toString());
                                      prefs.setString('manual',
                                          data['common']['user_manual']);
                                      prefs.setString(
                                          'user_name', data['user']['name']);
                                      prefs.setString('userDetails',
                                          json.encode(data['user']));
                                      Get.offAll(() => MainScreen());
                                    });

                                    children = <Widget>[
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 60,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          data['common']['message'],
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
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          data['common']['message'],
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ];
                                  }
                                } else {
                                  Future.delayed(const Duration(seconds: 5),
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
                                        'Logging in'.tr,
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
                              future: OnboardingController().verify(
                                mobileNo: widget.number,
                                otp: otp,
                              ),
                            ));
                          },
                    child: Text(
                      'Submit'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
