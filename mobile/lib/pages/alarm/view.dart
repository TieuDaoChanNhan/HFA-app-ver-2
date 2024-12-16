import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/alarm_entity.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/alarm/controller.dart';
import 'package:health_for_all/pages/alarm/widget/add_alarm.dart';
import 'package:health_for_all/pages/alarm/widget/list_alarm.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/following/controller.dart';

class AlarmPage extends GetView<AlarmController> {
  final UserData user;
  final bool right;
  AlarmPage(this.user, this.right, {super.key});

  final appController = Get.find<ApplicationController>();
  final followingController = Get.find<FollowingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt cảnh báo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 22,
          ),
        ),
        actions: [
          Icon(
            Icons.help_outline,
            size: 24,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            add_alarm(context),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('alarms')
                    .where('toUId', isEqualTo: user.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No alarms found.'));
                  }
                  final alarms = snapshot.data!.docs
                      .map((doc) => AlarmEntity.fromFirestore(
                          doc as DocumentSnapshot<Map<String, dynamic>>))
                      .toList();
                  return Text(
                    "Danh sách cảnh báo (${alarms.length})",
                  );
                },
              ),
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('alarms')
                    .where('userId', isEqualTo: user.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No alarms found.'));
                  }
                  final alarms = snapshot.data!.docs
                      .map((doc) => AlarmEntity.fromFirestore(
                          doc as DocumentSnapshot<Map<String, dynamic>>))
                      .toList();
                  controller.state.alarms.value = alarms;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.numberAlarm.value = alarms.length;
                  });
                  return ListView.builder(
                    itemCount: alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = alarms[index];
                      return ListAlarm(
                        id: alarm.id,
                        index: int.parse(alarm.typeId!),
                        highThreshold: alarm.highThreshold.toString(),
                        lowThreshold: alarm.lowThreshold.toString(),
                        enable: alarm.enable,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget add_alarm(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (right == false) {
          Get.snackbar("Không có quyền", "Bạn không phải bác sĩ",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        } else {
          // followingController
          //     .fetchRelatives(appController.state.profile.value!.id!);
          _showAddDialog(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.errorContainer,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              spreadRadius: 0.6,
              blurRadius: 2,
              // offset: Offset(0, 3), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/warning_add.png",
              height: 32,
              width: 32,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Thêm mới cảnh báo",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final relativesIds = appController.state.profile.value?.relatives ?? [];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AddAlarm(
                  user: user,
                  relativesIds: relativesIds,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
