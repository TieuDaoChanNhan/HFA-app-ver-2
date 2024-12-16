import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/alarm_entity.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/entities/notification_entity.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/common/entities/reminder.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/alarm/view.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/diagnostic/controller.dart';
import 'package:health_for_all/pages/diagnostic/view.dart';
import 'package:health_for_all/pages/following_medical_data/widget/following_person_box.dart';
import 'package:health_for_all/pages/homepage/widget/white_box.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:health_for_all/pages/notification/view.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';
import 'package:health_for_all/pages/overall_medical_data_history/view.dart';
import 'package:health_for_all/pages/prescription/index.dart';
import 'package:health_for_all/pages/reminder/view.dart';
import 'package:intl/intl.dart';
import 'controller.dart';

class FollowingMedicalData extends GetView<FollowingMedicalDataController> {
  final UserData user;
  final String role;
  final String time;
  const FollowingMedicalData(
      {super.key, required this.user, required this.role, required this.time});
  @override
  Widget build(BuildContext context) {
    // final historyController = Get.find<OverallMedicalDataHistoryController>();
    final notificationController = Get.find<NotificationController>();
    final diagnosticController = Get.find<DiagnosticController>();
    final appController = Get.find<ApplicationController>();

    final controller = Get.find<FollowingMedicalDataController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            appController.state.selectedUser.value =
                appController.state.profile.value!;
            appController.state.selectedUserId.value =
                appController.state.profile.value!.id!;
            log('Current User id: ${appController.state.selectedUser.value.id}');
            appController.getUpdatedLatestMedical();
            Get.back();
          },
          icon: Icon(
            color: Theme.of(context).colorScheme.onSurface,
            Icons.arrow_back,
          ),
        ),
        title: const Text('Đang theo dõi'),
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     controller.followingController.overallMedicalDataHistoryController
        //         .state.selectedUserId.value = '';
        //     controller.followingController.overallMedicalDataHistoryController
        //         .state.selectedUser.value = UserData();
        //     Get.back();
        //   },
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/HFA_small_icon.png',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  FollowingPersonBox(
                    avapath: user.photourl!,
                    name: user.name!,
                    gender: user.gender ?? 'Nam',
                    age: user.age == 0 ? 'Chưa cập nhật' : user.age.toString(),
                    person: role,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => OverallMedicalDataHistoryPage());
                    },
                    // child: Obx(() {
                    //   RxInt update = appController.state.updateMedData;
                    //   return Orangebox(
                    //     val1: update.toString(),
                    //     val3: '10',
                    //     time: time != ''
                    //         ? "Cập nhật lần cuối: $time"
                    //         : 'Chưa cập nhật',
                    //   );
                    // }),
                    child: Obx(() {
                      RxInt update = appController.state.updateMedData;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.errorContainer,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                // offset: Offset(0, 3), // changes position of shadow
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Dữ liệu sức khỏe",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Icon(
                                  Icons.open_in_new,
                                  size: 16,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.monitor_heart_outlined,
                                  size: 48,
                                  color: Color.fromRGBO(101, 85, 143, 1),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Chưa cập nhật",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(121, 116, 126, 1),
                                      ),
                                    ),
                                    Text(
                                      (10 - update.value).toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Color.fromRGBO(179, 38, 30, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Đã cập nhật",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(121, 116, 126, 1),
                                      ),
                                    ),
                                    Text(
                                      update.toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Color.fromRGBO(52, 199, 89, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const Column(
                                  children: [
                                    Text(
                                      "Tổng số",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(121, 116, 126, 1),
                                      ),
                                    ),
                                    Text(
                                      '10',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Color.fromRGBO(29, 27, 32, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  time != ''
                                      ? "Cập nhật lần cuối: $time"
                                      : 'Chưa cập nhật',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(121, 116, 126, 1),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: controller.getUser(appController
                            .state.selectedUser.value.id
                            .toString()),
                        builder: (context, medicalSnapshot) {
                          if (medicalSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!medicalSnapshot.hasData ||
                              medicalSnapshot.hasError) {
                            return const Text('Error loading medical data');
                          }

                          final user = medicalSnapshot.data!;
                          return GestureDetector(
                              onTap: () {
                                diagnosticController.fetchDiagnosticCounts(
                                    appController.state.selectedUser.value.id
                                        .toString());
                                Get.to(() => DiagnosticPage(
                                      user: user,
                                    ));
                              },
                              child: Obx(
                                () => StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('diagnostic')
                                      .where('toUId',
                                          isEqualTo: appController
                                              .state.selectedUser.value.id
                                              .toString())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Có lỗi xảy ra');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }

                                    final data = snapshot.data!.docs
                                        .map((doc) => Diagnostic.fromFirestore(
                                            doc as DocumentSnapshot<
                                                Map<String, dynamic>>))
                                        .toList();
                                    int read = 0;
                                    int unread = 0;
                                    for (var i in data) {
                                      if (i.status == "unread") {
                                        unread++;
                                      } else {
                                        read++;
                                      }
                                    }
                                    return WhiteBox(
                                        title: 'Chẩn đoán',
                                        iconbox:
                                            Icons.health_and_safety_outlined,
                                        text1: 'Chưa xem',
                                        text2: 'Đã xem',
                                        value1: unread.toString(),
                                        value2: read.toString());
                                  },
                                ),
                              ));
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => PrescriptionPage(
                                appController.state.selectedUser.value.id
                                    .toString(),
                                appController
                                        .state.selectedUser.value.isDoctor ??
                                    false));
                          },
                          child: Obx(
                            () => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('prescriptions')
                                  .where('patientId',
                                      isEqualTo: appController
                                          .state.selectedUser.value.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Có lỗi xảy ra');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final data = snapshot.data!.docs
                                    .map((doc) => Prescription.fromFirestore(doc
                                        as DocumentSnapshot<
                                            Map<String, dynamic>>))
                                    .toList();
                                int finished = 0;
                                int drinking = 0;
                                for (var i in data) {
                                  if (compareTimestamps(
                                      convertStringtoTime(i.endDate!),
                                      getYesterdayTimestamp())) {
                                    drinking++;
                                  } else {
                                    finished++;
                                  }
                                }
                                return WhiteBox(
                                    title: 'Đơn thuốc',
                                    iconbox: Icons.medication_liquid_sharp,
                                    text1: 'Đang uống',
                                    text2: 'Hoàn thành',
                                    value1: finished.toString(),
                                    value2: drinking.toString());
                              },
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.to(() => ReminderPage(
                                appController.state.selectedUser.value.id
                                    .toString(),
                                appController
                                        .state.selectedUser.value.isDoctor ??
                                    false));
                          },
                          child: Obx(
                            () => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('reminders')
                                  .where('userId',
                                      isEqualTo: appController
                                          .state.selectedUser.value.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Có lỗi xảy ra');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final data = snapshot.data!.docs
                                    .map((doc) => Reminder.fromFirestore(doc
                                        as DocumentSnapshot<
                                            Map<String, dynamic>>))
                                    .toList();
                                return WhiteBoxnoW(
                                    title: 'Nhắc nhở',
                                    iconbox: Icons.date_range_outlined,
                                    text1: 'Số lời nhắc',
                                    value1: data.length.toString());
                              },
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => AlarmPage(
                                appController.state.selectedUser.value,
                                appController
                                        .state.selectedUser.value.isDoctor ??
                                    false));
                          },
                          child: Obx(() => StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('alarms')
                                    .where('toUId',
                                        isEqualTo: appController
                                            .state.selectedUser.value.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Có lỗi xảy ra');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  final data = snapshot.data!.docs
                                      .map((doc) => AlarmEntity.fromFirestore(
                                          doc as DocumentSnapshot<
                                              Map<String, dynamic>>))
                                      .toList();
                                  return WhiteBoxnoW(
                                    title: 'Cảnh báo',
                                    iconbox: Icons.warning_amber_outlined,
                                    text1: 'Số cảnh báo',
                                    value1: data.length.toString(),
                                  );
                                },
                              ))),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            notificationController.fetchNotificationCounts(
                                appController.state.selectedUser.value.id
                                    .toString());
                            Get.to(() => NotiPage(
                                userId: appController
                                    .state.selectedUser.value.id
                                    .toString()));
                          },
                          child: Obx(
                            () => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('notifications')
                                  .where('to_uid',
                                      isEqualTo: appController
                                          .state.selectedUser.value.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Có lỗi xảy ra');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final data = snapshot.data!.docs
                                    .map((doc) =>
                                        NotificationEntity.fromFirestore(doc
                                            as DocumentSnapshot<
                                                Map<String, dynamic>>))
                                    .toList();
                                int read = 0;
                                int unread = 0;
                                for (var i in data) {
                                  if (i.status == "read") {
                                    read++;
                                  } else {
                                    unread++;
                                  }
                                }
                                return WhiteBox(
                                    title: 'Thông báo',
                                    iconbox: Icons.notifications_outlined,
                                    text1: 'Chưa xem',
                                    text2: 'Đã xem',
                                    value1: unread.toString(),
                                    value2: read.toString());
                              },
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime convertStringtoTime(String date) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime dateTime = format.parse(date);
    return dateTime;
  }

  DateTime getYesterdayTimestamp() {
    DateTime now = DateTime.now(); // Get the current date and time
    DateTime yesterday =
        now.subtract(const Duration(days: 1)); // Subtract one day
    return yesterday; // This returns the DateTime object for yesterday
  }

  bool compareTimestamps(DateTime timestamp1, DateTime timestamp2) {
    return timestamp1
        .isAfter(timestamp2); // true if timestamp1 is before timestamp2
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
