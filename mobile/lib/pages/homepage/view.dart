import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/alarm_entity.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/entities/notification_entity.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/common/entities/reminder.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/alarm/view.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/chatbot/view.dart';
import 'package:health_for_all/pages/connect_hardware/view.dart';
import 'package:health_for_all/pages/diagnostic/controller.dart';
import 'package:health_for_all/pages/diagnostic/view.dart';
import 'package:health_for_all/pages/homepage/widget/white_box.dart';
import 'package:health_for_all/pages/homepage/widget/orange_box.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:health_for_all/pages/notification/view.dart';
import 'package:health_for_all/pages/prescription/index.dart';
import 'package:health_for_all/pages/profile/index.dart';
import 'package:health_for_all/pages/reminder/view.dart';
import 'package:intl/intl.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final appController = Get.find<ApplicationController>();
  final notificationController = Get.find<NotificationController>();
  final diagnosticController = Get.find<DiagnosticController>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ProfilePage());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                              // offset: Offset(0, 3), // changes position of shadow
                            )
                          ]),
                      child: Obx(() => Row(children: [
                            CircleAvatar(
                                radius: 28,
                                backgroundImage: CachedNetworkImageProvider(
                                    appController
                                            .state.profile.value?.photourl ??
                                        "https://www.google.com/url?sa=i&url=https%3A%2F%2Ficonduck.com%2Ficons%2F160691%2Favatar-default-symbolic&psig=AOvVaw2gPEQ_lKQuUXivxfgTKXo-&ust=1723564687779000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCIi5g4Hp74cDFQAAAAAdAAAAABAE")),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      appController.state.profile.value?.name ??
                                          "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(
                                //   width: 12,
                                // ),
                                Text(
                                  appController.state.profile.value?.gender ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 4,
                                // ),
                                Text(
                                  appController.state.profile.value?.age != 0
                                      ? ("${appController.state.profile.value?.age} tuổi")
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            IntrinsicWidth(
                              child: SizedBox(
                                height: 56,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Người nhà:",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        Badge(
                                          label: Text(
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                              ),
                                              appController.state.profile.value
                                                      ?.relatives?.length
                                                      .toString() ??
                                                  "0"),
                                          largeSize: 16,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Chuyên gia:",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        Badge(
                                          label: Text(
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                              ),
                                              appController.state.profile.value
                                                      ?.doctors?.length
                                                      .toString() ??
                                                  "0"),
                                          largeSize: 16,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Đang theo dõi:",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        Badge(
                                          label: Text(
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            ((appController
                                                            .state
                                                            .profile
                                                            .value
                                                            ?.relatives
                                                            ?.length ??
                                                        0) +
                                                    (appController
                                                            .state
                                                            .profile
                                                            .value
                                                            ?.patients
                                                            ?.length ??
                                                        0))
                                                .toString(),
                                          ),
                                          largeSize: 16,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ])),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(() {
                    RxInt update = appController.state.updateMedData;
                    return Orangebox(
                        val1: update.toString(),
                        val3: "10",
                        time: appController.state.updateTime.value == ""
                            ? "Chưa cập nhật dữ liệu lần nào"
                            : "Cập nhật lần cuối ${appController.state.updateTime.value}");
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          diagnosticController.fetchDiagnosticCounts(
                              appController.state.profile.value!.id.toString());
                          Get.to(() => DiagnosticPage(
                                user: appController.state.profile.value!,
                              ));
                          log('Unread: ${diagnosticController.state.unread.value}, Read: ${diagnosticController.state.read.value}, Importance: ${diagnosticController.state.importance.value}');
                        },
                        child: Obx(() => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('diagnostic')
                                  .where('toUId',
                                      isEqualTo:
                                          appController.state.profile.value?.id)
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
                                    .map((doc) => Diagnostic.fromFirestore(doc
                                        as DocumentSnapshot<
                                            Map<String, dynamic>>))
                                    .toList();
                                RxInt read = 0.obs;
                                RxInt unread = 0.obs;
                                for (var i in data) {
                                  if (i.status == "unread") {
                                    unread++;
                                  } else {
                                    read++;
                                  }
                                  // print("dakmim");
                                  // print(i.status);
                                }
                                return WhiteBox(
                                    title: 'Chẩn đoán',
                                    iconbox: Icons.health_and_safety_outlined,
                                    text1: 'Chưa xem',
                                    text2: 'Đã xem',
                                    value1: unread.value.toString(),
                                    value2: read.value.toString());
                              },
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PrescriptionPage(
                              appController.state.profile.value!.id.toString(),
                              true));
                        },
                        child: Obx(() => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('prescriptions')
                                  .where('patientId',
                                      isEqualTo:
                                          appController.state.profile.value?.id)
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
                                    value1: drinking.toString(),
                                    value2: finished.toString());
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ReminderPage(
                              appController.state.profile.value!.id.toString(),
                              true));
                        },
                        child: Obx(() => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('reminders')
                                  .where('userId',
                                      isEqualTo:
                                          appController.state.profile.value?.id)
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
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => AlarmPage(
                                appController.state.profile.value!, true));
                          },
                          child: Obx(() => StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('alarms')
                                    .where('userId',
                                        isEqualTo: appController
                                            .state.profile.value?.id)
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            notificationController.fetchNotificationCounts(
                                appController.state.profile.value!.id
                                    .toString());
                            Get.to(() => NotiPage(
                                  userId: appController.state.profile.value!.id
                                      .toString(),
                                ));
                          },
                          child: Obx(
                            () => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('notifications')
                                  .where('to_uid',
                                      isEqualTo:
                                          appController.state.profile.value?.id)
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
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ChatbotPage());
                        },
                        child: const WhiteBoxnoVal(
                            title: 'Trò chuyện với HFA',
                            iconbox: Icons.smart_toy_outlined,
                            text1: 'Trò chuyện y tế với HFA'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ConnectHardwarePage());
                    },
                    child: Container(
                      height: 87,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromRGBO(234, 221, 255, 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                            )
                          ]),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kết nối với thiết bị",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.open_in_new,
                                size: 16,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.developer_board,
                                size: 32,
                                color: Color.fromRGBO(101, 85, 143, 1),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Có thể kết nối",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                "HFA Careport",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(33, 0, 93, 1),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return const Center(
    //   child: Text('Homepage'),
    // );
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
