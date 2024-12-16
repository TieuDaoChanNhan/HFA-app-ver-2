import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/notification_entity.dart';
import 'package:health_for_all/common/enum/type_notification_status.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:health_for_all/pages/notification/widget/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key, required this.uid, required this.status});
  final String uid;
  final TypeNotificationStatus status;
  final notiController = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('to_uid', isEqualTo: uid)
                .where('status', isEqualTo: status.value)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('Không tìm thấy thông báo nào!!!'));
              }

              final notifications = snapshot.data!.docs
                  .map((doc) => NotificationEntity.fromFirestore(
                      doc as DocumentSnapshot<Map<String, dynamic>>))
                  .toList();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (status == TypeNotificationStatus.unread) {
                  notiController.state.unread.value = notifications.length;
                  log('unread: ${notiController.state.unread.value}');
                }
                if (status == TypeNotificationStatus.read) {
                  notiController.state.read.value = notifications.length;
                  log('read: ${notiController.state.read.value}');
                }
                if (status == TypeNotificationStatus.reminder) {
                  notiController.state.reminder.value = notifications.length;
                  log('reminder: ${notiController.state.reminder.value}');
                }
                if (status == TypeNotificationStatus.alarm) {
                  notiController.state.alarm.value = notifications.length;
                  log('alarm: ${notiController.state.alarm.value}');
                }
              });
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return FutureBuilder<String>(
                    future: notiController.getNameByUId(notification.toUId!),
                    builder: (context, nameSnapshot) {
                      if (nameSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final name = nameSnapshot.data ?? 'Unknown';

                      return Column(
                        children: [
                          NotificationItem(
                            name: name,
                            isExpanded: false.obs,
                            status: status,
                            notification: notification,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        )
      ]),
    );
  }
}
