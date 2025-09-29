import 'package:alandi/config/exported_path.dart';

class Profile extends StatefulWidget {
  final bool isDrawer;

  const Profile({super.key, required this.isDrawer});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // final controller = Get.put(ProfileController());
  final controller = getIt<ProfileController>();
  @override
  void initState() {
    controller.getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.isUpdate.value = false;
      controller.isLoading.value = false;
      // controller.getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.isLoading2.isTrue
            ? LoadingWidget(color: primaryBlack)
            : AnimationLimiter(
                child: ListView(
                  children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50,
                            // horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title(),
                              SizedBox(
                                height: Get.height * 0.04,
                              ),
                              avatar(),
                              SizedBox(
                                height: Get.height * 0.04,
                              ),
                              nameField(),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              numberField(controller.numberController.text),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
      ),
    );
  }

  Widget numberField(String value) {
    return TextFormField(
      enabled: false,
      initialValue: value,
      validator: (value) => nameValidator(value!),
      decoration: _inputDecoration(Icons.call, 'Number', 'Enter your Number'),
    );
  }

  Widget nameField() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: controller.isUpdate.value,
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
              validator: (value) => nameValidator(value!),
              decoration: _inputDecoration(
                  Icons.person_2_outlined, 'Name', 'Enter your Name'),
            ),
          ),
          controller.isLoading.isTrue
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoadingWidget(color: primaryBlack),
                )
              : IconButton(
                  icon:
                      Icon(controller.isUpdate.value ? Icons.save : Icons.edit),
                  onPressed: () async {
                    if (!controller.isUpdate.value) {
                      controller.isUpdate.value = true;
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.nameFocusNode.requestFocus();
                      });
                    } else {
                      _saveProfile();
                    }
                  },
                )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String label, String hint) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      labelText: label.tr,
      hintText: hint.tr,
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

  Widget avatar() {
    String initial = controller.nameController.text.isNotEmpty
        ? controller.nameController.text[0].toUpperCase()
        : '';
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 50,
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: Get.height * 0.08,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Text(
      'User Details'.tr,
      style: TextStyle(
          color: Colors.black,
          fontSize: Get.width * 0.06,
          fontWeight: FontWeight.bold),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
      leading: widget.isDrawer
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.off(() => MainScreen());
              },
            )
          : null,
      title: Text(
        'Profile'.tr,
        style: TextStyle(
            color: Colors.black,
            fontSize: Get.width * 0.07,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.black),
          onPressed: logoutDialog,
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    final response =
        await controller.updateProfile(name: controller.nameController.text);

    if (response['common']['status']) {
      controller.saveUserName(controller.nameController.text);
    }

    Get.snackbar(
      'Notification',
      response['common']['message'],
      colorText: Colors.black,
      icon: const Icon(
        Icons.notifications,
        color: Colors.black,
      ),
    );

    controller.isUpdate.value = false;
  }
}
