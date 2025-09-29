import 'package:alandi/config/exported_path.dart';

class Signup extends StatefulWidget {
  final String number;

  const Signup({super.key, required this.number});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = TextEditingController();
  final otpController = OtpFieldController();
  final _formKey = GlobalKey<FormState>();
  String otp = '';
  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        // surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/alandi_fevicon.png',
                    height: Get.height * 0.3,
                  ),
                ),
                Text(
                  'Sign Up'.tr,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  'Please Enter your Details to proceed Further'.tr,
                  style: TextStyle(fontSize: 16, color: primaryGrey),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  'Name'.tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                TextFormField(
                  controller: nameController,
                  validator: (value) => nameValidator(value!),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    // labelText: 'Description',
                    hintText: 'Name'.tr,
                    labelText: 'Name'.tr,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  'OTP'.tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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

                // TextFormField(
                //   controller: numberController,
                //   validator: (value) => validatePhoneNumber(value!),
                //   decoration:  InputDecoration(
                //     prefixIcon: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Image.asset(
                //         'assets/images/Flag_of_India.png',
                //         // Replace with the path to your flag image
                //         width: 30.0,
                //         height: 30.0,
                //       ),
                //     ),
                //     // prefixText: ' | ',
                //
                //     contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                //     // labelText: 'Description',
                //     hintText: '|   Mobile Number',
                //     labelText: 'Mobile Number',
                //     hintStyle: const TextStyle(color: Colors.grey),
                //   ),
                // ),
                SizedBox(
                  height: Get.height * 0.01,
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
                    onPressed: () async {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return FutureBuilder(
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
                                    // Get.back();
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
                                  surfaceTintColor: Colors.white,
                                  backgroundColor: Colors.white,
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
                              future: OnboardingController().register(
                                  otp: otp,
                                  mobileNo: widget.number,
                                  name: nameController.text),
                            );
                          },
                        );
                      } else {
                        Get.snackbar('Error', 'ERROR');
                      }
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
