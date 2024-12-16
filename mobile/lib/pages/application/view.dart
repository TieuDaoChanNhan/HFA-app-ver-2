import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/alarm/view.dart';
import 'package:health_for_all/pages/chatbot/view.dart';
import 'package:health_for_all/pages/connect_hardware/view.dart';
import 'package:health_for_all/pages/following/view.dart';
import 'package:health_for_all/pages/homepage/view.dart';
import 'package:health_for_all/pages/image_analyze/view.dart';
import 'package:health_for_all/pages/medical_data/view.dart';
import 'package:health_for_all/pages/medical_data_homepage/view.dart';
import 'package:health_for_all/pages/notification/view.dart';
import 'package:health_for_all/pages/diagnostic/view.dart';
import 'package:health_for_all/pages/prescription/view.dart';
import 'package:health_for_all/pages/profile/page/information_view.dart';
import 'package:health_for_all/pages/profile/view.dart';
import 'package:health_for_all/pages/reminder/view.dart';
import 'controller.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.onInit();
    controller.onReady();
    Widget buildPageView() {
      return Obx(() => PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            onPageChanged: controller.handPageChanged,
            children: [
              Homepage(),
              Following(),
              MedicalDataPage(),
              NotificationPage(
                  controller.state.profile.value?.id?.toString() ?? ""),
              const ProfilePage()
            ],
          ));
    }

    Widget buildBottomNavigationBar() {
      return Obx(() => BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            items: controller.bottomTabs,
            currentIndex: controller.state.page,
            type: BottomNavigationBarType.fixed,
            onTap: controller.handleNavBarTap,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: const TextStyle(
                fontSize: 12), // Adjust label size for selected items
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            // unselectedItemColor: AppColors.tabBarElement,
            // selectedItemColor: AppColors.thirdElementText,
          ));
    }

    Widget buildDrawerHeader() {
      return const UserAccountsDrawerHeader(
          accountName: Text('HEALTH FOR ALL'),
          accountEmail: Text('từ NK Solution'));
    }

    Widget buildDrawer() {
      return Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildDrawerHeader(),
          ListTile(
            onTap: () => Get.to(() => MedicalDataHome(
                time: controller.state.updateTime.value == ""
                    ? "Chưa cập nhật dữ liệu lần nào"
                    : "Cập nhật lần cuối ${controller.state.updateTime.value}")),
            leading: const Icon(Icons.monitor_heart_outlined),
            title: const Text('Dữ liệu sức khỏe'),
          ),
          GestureDetector(
            onTap: () {
              controller.diagnosticController.fetchDiagnosticCounts(
                  controller.state.profile.value?.id?.toString() ?? "");
              Get.to(() => DiagnosticPage(
                    user: controller.state.profile.value!,
                  ));
            },
            child: const ListTile(
              leading: Icon(
                Icons.health_and_safety_outlined,
              ),
              title: Text('Chẩn đoán'),
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => PrescriptionPage(
                controller.state.profile.value!.id.toString(), true)),
            leading: const Icon(
              Icons.medication_liquid_sharp,
            ),
            title: const Text('Đơn thuốc'),
          ),
          ListTile(
            leading: const Icon(
              Icons.date_range_outlined,
            ),
            title: const Text('Nhắc nhở'),
            onTap: () => Get.to(() => ReminderPage(
                controller.state.profile.value!.id.toString(), true)),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Thông báo'),
            onTap: () {
              controller.notificationController.fetchNotificationCounts(
                  controller.state.profile.value?.id?.toString() ?? "");
              Get.to(() => NotiPage(
                  userId:
                      controller.state.profile.value?.id?.toString() ?? ""));
            },
          ),
          ListTile(
            onTap: () {
              Get.to(() => AlarmPage(controller.state.profile.value!, true));
            },
            leading: const Icon(
              Icons.warning_amber_outlined,
            ),
            title: const Text('Cảnh báo'),
          ),
          ListTile(
            onTap: () => Get.to(() => const ConnectHardwarePage()),
            leading: const Icon(Icons.memory),
            title: const Text('Kết nối với thiết bị'),
          ),
          ListTile(
            onTap: () => Get.to(() => const ChatbotPage()),
            leading: const Icon(
              Icons.smart_toy_outlined,
            ),
            title: const Text('Trò chuyện với HFA-Bot'),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Tài khoản'),
            onTap: () => Get.to(() => const InfoPage()),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Đăng xuất'),
            onTap: () async {
              await controller.onLogOut();
            },
          ),
          ListTile(
            onTap: () => Get.to(() => ImageAnalyzePage()),
            leading: const Icon(Icons.memory_outlined),
            title: const Text('Phân tích hình ảnh'),
          ),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health For All'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About_HFA()),
                );
              },
              child: Image.asset(
                'assets/images/HFA_small_icon.png',
              ),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

class About_HFA extends StatelessWidget {
  const About_HFA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Về chúng tôi"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Video về project",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        "assets/qr_to_project.png",
                        width: min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height) /
                            2,
                        height: min(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height) /
                            2,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotiPage extends StatelessWidget {
  final String userId;
  const NotiPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
      ),
      body: NotificationPage(userId),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin tài khoản"),
      ),
      body: const InformationPage(),
    );
  }
}
