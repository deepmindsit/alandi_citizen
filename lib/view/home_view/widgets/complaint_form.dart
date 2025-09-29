import 'package:alandi/config/exported_path.dart';

class ComplaintForm extends StatefulWidget {
  final String deptId;

  const ComplaintForm({super.key, required this.deptId});

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final wardData = getIt<HomeController>();
  final controller = getIt<AddComplaintsController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    wardData.getWard();
    controller.updateUserLocation();
    controller.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
        titleSpacing: 0,
        title: Text('Complaint Registration'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: Get.height * 0.01,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complaint Details'.tr,
                  style: TextStyle(fontSize: Get.width * 0.07),
                ),
                headerRequired(header: 'ward', isRequired: true),
                Obx(
                  () => ButtonTheme(
                    alignedDropdown: true,
                    splashColor: Colors.transparent,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: DropdownButtonFormField(
                      // value: controller.ward.value,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      decoration: InputDecoration(
                        border: border(),
                        enabledBorder: border(),
                        focusedBorder: border(),
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 12, 12, 12),
                        hintText: 'Select Ward'.tr,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        errorMaxLines: 1,
                      ),
                      dropdownColor: Colors.white,
                      validator: (value) =>
                          value == null ? 'Please select Ward'.tr : null,
                      hint: Text(
                        'ward'.tr,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      isExpanded: true,
                      elevation: 4,
                      items: wardData.wardList.map((item) {
                        return DropdownMenuItem(
                          value: item['id'],
                          child: Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // setState(() {
                        controller.ward.value = newValue.toString();
                        // });
                      },
                    ),
                  ),
                ),
                headerRequired(header: 'Nearest Landmark', isRequired: true),
                TextFormField(
                  controller: controller.landMarkController,
                  validator: (value) => nameValidator(value!),
                  decoration: InputDecoration(
                    border: border(),
                    enabledBorder: border(),
                    focusedBorder: border(),
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    labelText: 'Landmark'.tr,
                    hintText: 'Enter your Landmark'.tr,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                headerRequired(
                    header: 'Description of the Complaint', isRequired: true),
                TextFormField(
                  controller: controller.descriptionController,
                  validator: (value) => nameValidator(value!),
                  maxLines: 50,
                  minLines: 3,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    border: border(),
                    enabledBorder: border(),
                    focusedBorder: border(),
                    hintText: 'Enter your Description of the Complaint'.tr,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                headerRequired(header: 'Attach Documents', isRequired: true),
                DottedBorder(
                    dashPattern: [10, 5],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    color: primaryGrey,
                    strokeWidth: 1,
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        controller.showOptions();
                      },
                      child: Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            // color: primaryGrey,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                        child: Obx(
                          () => controller.isLoading.isTrue
                              ? LoadingWidget(color: primaryColor)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        HugeIcons.strokeRoundedFileUpload),
                                    Text(
                                      'Attach Documents'.tr,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    )),
                Obx(
                  () => controller.imageList.isNotEmpty
                      ? SizedBox(
                          width: Get.width * 0.8,
                          height: controller.imageList.length > 3
                              ? Get.width * 0.5
                              : Get.width * 0.3,
                          child: GridView.builder(
                            itemCount: controller.imageList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              final data = controller.imageList[index];
                              final isImage = data['from'] == 'camera';
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: isImage
                                          ? GestureDetector(
                                              onTap: () {
                                                Get.dialog(
                                                  Dialog(
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    12),
                                                            topRight:
                                                                Radius.circular(
                                                                    12),
                                                          ),
                                                          child: Image.file(
                                                            data['path'],
                                                            fit: BoxFit.cover,
                                                            width:
                                                                Get.width * 0.6,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (data[
                                                                      'userLocation'] !=
                                                                  null)
                                                                Text(
                                                                    '📍 ${data['userLocation']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              if (data[
                                                                      'latLng'] !=
                                                                  null)
                                                                Text(
                                                                    '🌐 ${data['latLng']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              if (data[
                                                                      'dateTime'] !=
                                                                  null)
                                                                Text(
                                                                    '🕒 ${data['dateTime']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                            ],
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: const Text(
                                                              "Close"),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.file(
                                                data['path'],
                                                fit: BoxFit.cover,
                                                width: (Get.width * 0.8 - 10) /
                                                    3, // 3 columns in 80% width
                                                height:
                                                    (Get.width * 0.8 - 10) / 3,
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/images/pdf_icon.png',
                                              height: Get.height * 0.07,
                                            )),
                                  Positioned(
                                      top: 7,
                                      right: 7,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.imageList.removeAt(index);
                                          if (controller.imageList.isEmpty) {
                                            controller.imageList.clear();
                                            controller.imageFile = null;
                                          } else {
                                            controller.imageFile =
                                                controller.imageList.last;
                                          }
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red.shade300,
                                        ),
                                      )),
                                ],
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 70,
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05, vertical: 11),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  surfaceTintColor: Colors.white,
                  side: BorderSide(color: Colors.transparent)),
              onPressed: () async {
                final isValid = controller.formKey.currentState!.validate();
                if (isValid && controller.latLng.isNotEmpty) {
                  controller.uploadFiles(widget.deptId);
                } else {
                  Get.snackbar(
                    'Error',
                    'Please Fill All Details & Please provide location access',
                    colorText: Colors.black,
                  );
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
        ),
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.5)));
  }
}
