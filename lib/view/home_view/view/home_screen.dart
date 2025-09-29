import 'package:alandi/config/exported_path.dart';

class HomeScreen extends StatefulWidget {
  final bool isDrawer;

  const HomeScreen({super.key, required this.isDrawer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = getIt<HomeController>();
  final linksData = getIt<GetLinks>();

  // final _languageController = Get.put(LanguageController());
  final _languageController = getIt<LanguageController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkLocationAccess();
      checkInternetAndShowPopup();
      controller.isSearch.value = false;
      fetchAllData();
      UpdateController().checkForUpdate();
    });
    // checkLocationAccess();

    FirebaseTokenController().updateToken();
    super.initState();
  }

  void fetchAllData({bool showLoading = true}) async {
    try {
      await Future.wait([
        controller.getDepartment(),
        controller.getComplaints(),
        controller.getSlider(),
        linksData.getLinks(),
      ]);
    } finally {
      if (showLoading) controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
        autoAlign: true,
        floatingWidget: howToUseButton(),
        // floatingWidget: Container(),
        floatingWidgetWidth: Get.height * 0.1,
        floatingWidgetHeight: Get.height * 0.07,
        mainScreenWidget: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(),
            drawer: SafeArea(child: DrawerWidget()),
            body: Obx(() {
              if (controller.isLoading.value) {
                return LoadingWidget(color: primaryBlack);
              } else if (controller.isSearch.value) {
                return searchView();
              } else {
                return _buildHomeContent();
              }
            })));
  }

  AppBar _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      leading: widget.isDrawer
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.off(() => MainScreen()),
            )
          : null,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: Image.asset(
        'assets/images/alandi_logo.png',
        width: Get.width * 0.4,
      ),
      // centerTitle: true,
      actions: [
        _buildLanguageToggle(),
        _buildNotificationButton(),
        _buildSearchIcon(),
      ],
    );
  }

  Widget _buildSearchIcon() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          // iconSize: 20,
          // padding: EdgeInsets.symmetric(horizontal: 4),
          onTap: () => controller.isSearch.toggle(),
          child: const Icon(
            size: 20,
            HugeIcons.strokeRoundedSearch01,
          ),
        ),
      );

  Widget _buildNotificationButton() => IconButton(
        iconSize: 20,
        padding: EdgeInsets.symmetric(horizontal: 4),
        icon: const Icon(HugeIcons.strokeRoundedNotification02),
        onPressed: () => Get.to(() => const NotificationList()),
      );

  Widget _buildLanguageToggle() {
    return GestureDetector(
      onTap: () async {
        _languageController.toggleLanguage();
        // controller.isLoading.value = true;
        await Future.wait([
          controller.getDepartment(),
          controller.getComplaints(),
          linksData.getLinks(),
        ]);
        // controller.isLoading.value = false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Image.asset(
          _languageController.isEnglish.value
              ? 'assets/images/translation_english_marathi.png'
              : 'assets/images/translation_marathi_english.png',
          color: Colors.black,
          width: Get.width * 0.05,
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          headerSection(),
          SliverToBoxAdapter(
            child: controller.complaintList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.3,
                          height: Get.height * 0.002,
                          color: Color(0xFFE0E0E0),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //     border: Border.all(width: 1, color: Colors.black),
                            //     borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Recent Complaint'.tr,
                              style: const TextStyle(color: Colors.grey),
                            )),
                        Container(
                          width: Get.width * 0.3,
                          height: Get.height * 0.002,
                          color: Color(0xFFE0E0E0),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          SliverToBoxAdapter(
            child: controller.complaintList.isNotEmpty
                ? lastComplaint()
                : const SizedBox(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDivider(),
                  Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Departments'.tr)),
                  _buildDivider(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              'complaint_line'.tr,
              textAlign: TextAlign.center,
            ),
          ),
          departmentSection(),
          _buildImportantLinksSection(),
          importantLink(),
        ],
      ),
    );
  }

  Widget importantLink() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return GestureDetector(
              onTap: () {
                if (linksData.linkList[index]['url'] != null) {
                  launchInBrowser(Uri.parse(linksData.linkList[index]['url']));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    linksData.linkList[index]['image'],
                    height: Get.height * 0.07,
                  ),
                  Text(
                    linksData.linkList[index]['name'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(height: 1, fontSize: Get.width * 0.035),
                  ),
                ],
              ),
            );
          },
          childCount: linksData.linkList.length,
        ),
      ),
    );
  }

  Widget _buildImportantLinksSection() {
    return SliverToBoxAdapter(
      child: _buildSectionTitle('Important Links'.tr),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDivider(),
          Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(title.tr)),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
        width: Get.width * 0.3,
        height: Get.height * 0.001,
        color: primaryGrey,
      );

  Widget departmentSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      sliver: Obx(
        () => AnimationLimiter(
          child: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: controller.departmentList.length,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: DepartmentTile(
                        onTap: () {
                          Get.to(() => ComplaintForm(
                                deptId: controller.departmentList[index]['id']
                                    .toString(),
                              ));
                        },
                        isLink: false,
                        department:
                            controller.departmentList[index]['id'].toString(),
                        image: controller.departmentList[index]['image'],
                        dept: controller.departmentList[index]['name'],
                      ),
                    ),
                  ),
                );
              },
              childCount: controller.departmentList.length,
            ),
          ),
        ),
      ),
    );
  }

  Widget headerSection() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: SliverAppBarDelegate(
        minHeight: Get.height * 0.25,
        maxHeight: Get.height * 0.25,
        child: carouselContainer(),
      ),
    );
  }

  Widget carouselContainer() {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: AnimationLimiter(
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
                  const SizedBox(
                    height: 10,
                  ),
                  carouselSliderWidget(),
                ]),
          ),
        ));
  }

  Widget searchView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          searchTextField(),
          SizedBox(height: Get.height * 0.02),
          Expanded(
            child: searchResult(),
          ),
        ],
      ),
    );
  }

  Widget searchResult() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // number of items in each row
        mainAxisSpacing: 8.0, // spacing between rows
        crossAxisSpacing: 8.0, // spacing between columns
      ),
      itemCount: controller.filteredDataList.length,
      itemBuilder: (context, index) {
        return DepartmentTile(
          onTap: () {
            Get.to(() => ComplaintForm(
                  deptId: controller.departmentList[index]['id'].toString(),
                ));
          },
          isLink: false,
          department: controller.filteredDataList[index]['id'].toString(),
          image: controller.filteredDataList[index]['image'],
          dept: controller.filteredDataList[index]['name'],
        );
      },
    );
  }

  Widget searchTextField() {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.filterData,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            // setState(() {
            controller.searchController.clear();
            controller.filteredDataList.clear();
            controller.isSearch.value = false;
            // });
          },
          child: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
        hintText: 'Search...'.tr,
        border: InputBorder.none,
      ),
    );
  }

  Widget searchIcon() {
    return GestureDetector(
      onTap: () => controller.isSearch.toggle(),
      child: Padding(
        padding: EdgeInsets.all(5.0).copyWith(right: 10),
        child: Icon(
          HugeIcons.strokeRoundedSearch01,
        ),
      ),
    );
  }

  Widget notification() {
    return GestureDetector(
      onTap: () => Get.to(() => const NotificationList()),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Icon(HugeIcons.strokeRoundedNotification02),
      ),
    );
  }

  Widget languageToggle() {
    return GestureDetector(
      onTap: () {
        _languageController.toggleLanguage();
        controller.getDepartment();
        controller.getComplaints();
        linksData.getLinks();
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            _languageController.isEnglish.value
                ? 'assets/images/translation_english_marathi.png'
                : 'assets/images/translation_marathi_english.png',
            color: Colors.black,
            width: Get.width * 0.06,
          )),
    );
  }

  Widget howToUseButton() {
    return FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          Get.dialog(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: Get.width * 0.9,
                        height: Get.height * 0.7,
                        color: Colors.white,
                        child: Center(
                          child: YoutubeUrlWidget(
                            videoUrl: controller.videoUrl.isEmpty
                                ? 'https://youtube.com/shorts/NDLPvptu8r8?feature=share'
                                : controller.videoUrl.value,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 16,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Image.asset('assets/images/how_to_use.png'));
  }

  Widget lastComplaint() {
    final complaint = controller.complaintList[0];
    final int statusColor =
        int.tryParse(complaint['status_color'] ?? '0xFF000000') ?? 0xFF000000;
    return GestureDetector(
      onTap: () {
        Get.to(() => ComplaintSummary(
              isList: true,
              complaintId: complaint['id'].toString(),
            ));
      },
      child: ComplaintCard(
        title: complaint['department'] ?? 'N/A',
        location: complaint['ward']?.toString() ?? 'N/A',
        date: complaint['created_on_date'] ?? 'N/A',
        status: complaint['status'] ?? 'N/A',
        statusColor: statusColor.toString(),
        ticketNo: complaint['code'] ?? '',
        deptImg: complaint['department_image'],
      ),

      // Card(
      //   surfaceTintColor: Colors.white,
      //   elevation: 1,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Colors.black, width: 1),
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      //   child: ListTile(
      //     tileColor: Colors.white,
      //     contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      //     splashColor: Colors.transparent,
      //     dense: true,
      //     leading: ClipRRect(
      //       borderRadius: BorderRadius.circular(8),
      //       child: Image.network(
      //         complaint['department_image'],
      //         width: 40,
      //         height: 40,
      //         fit: BoxFit.cover,
      //         errorBuilder: (context, error, stackTrace) =>
      //             const Icon(Icons.error, color: Colors.red),
      //       ),
      //     ),
      //     title: Text(
      //       complaint['department'],
      //       style: const TextStyle(
      //           fontWeight: FontWeight.w500, fontSize: 16, height: 1.0),
      //     ),
      //     subtitle: Text(
      //       complaint['description'],
      //       maxLines: 1,
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //     trailing: Container(
      //         width: Get.width * 0.25,
      //         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
      //         alignment: Alignment.center,
      //         decoration: BoxDecoration(
      //           border: Border.all(width: 1, color: Color(statusColor)),
      //           color: Color(statusColor).withValues(alpha: 0.1),
      //           borderRadius: BorderRadius.circular(20),
      //           // borderRadius: BorderRadius.circular(100)
      //         ),
      //         child: Text(
      //           complaint['status'],
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               height: 1, color: Color(statusColor), fontSize: 14),
      //         )),
      //   ),
      // ),
    );
  }

  Widget carouselSliderWidget() {
    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 15 / 7,
          autoPlay: true,
          viewportFraction: 0.9,
          enlargeCenterPage: true,
          pauseAutoPlayOnTouch: true),
      items: controller.sliderList
          .map((item) => GestureDetector(
                onTap: () {
                  launchInBrowser(Uri.parse(item['url']));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['image'],
                      width: Get.width * 0.9,
                      fit: BoxFit.fitHeight,
                    )),
              ))
          .toList(),
    );
  }
}
