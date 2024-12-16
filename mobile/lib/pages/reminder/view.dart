import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/alarm/controller.dart';
import 'package:health_for_all/pages/reminder/controller.dart';
import 'package:health_for_all/pages/reminder/widget/add_reminder.dart';
import 'package:health_for_all/pages/reminder/widget/list_reminder.dart';

class ReminderPage extends GetView<AlarmController> {
  final String userId;
  final bool right;
  const ReminderPage(this.userId, this.right, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt nhắc nhở',
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
      body: Column(
        children: [
          const Divider(
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                add_reminder(context),
                const SizedBox(
                  height: 16,
                ),
                list_reminder(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget list_reminder(BuildContext context) {
    final reminderController = Get.find<ReminderController>();
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reminders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while fetching
          }

          final len = snapshot.data!.docs.length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Danh sách nhắc nhở ($len)",
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              const SizedBox(
                height: 16,
              ),
              const ListReminder(),
            ],
          );
        });
  }

  Widget add_reminder(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (right == false) {
          Get.snackbar("Không có quyền", "Bạn không phải bác sĩ",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        } else {
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
            Icon(
              Icons.edit_calendar_outlined,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Thêm mới nhắc nhở",
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
                AddReminder(
                  userId: userId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
