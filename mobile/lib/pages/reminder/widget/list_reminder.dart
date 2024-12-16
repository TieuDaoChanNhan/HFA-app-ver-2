import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/reminder.dart';
import 'package:health_for_all/pages/reminder/controller.dart';
import 'package:health_for_all/pages/reminder/widget/info_reminder.dart';
import 'package:health_for_all/pages/reminder/widget/switched_box.dart';

class ListReminder extends StatefulWidget {
  const ListReminder({super.key});

  @override
  State<ListReminder> createState() => _ListReminderState();
}

class _ListReminderState extends State<ListReminder> {
  @override
  Widget build(BuildContext context) {
    final reminderController = Get.find<ReminderController>();
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reminders').where('userId', isEqualTo: reminderController.state.profile.value?.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while fetching
          }

          final data = snapshot.data!.docs
              .map((doc) => Reminder.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              return FutureBuilder(
                future: ReminderController().getData(doc.prescriptionId!),
                builder: (context, medicineSnapshot) {
                  if (medicineSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (medicineSnapshot.hasError) {
                    return const Text('Có lỗi xảy ra khi lấy dữ liệu thuốc');
                  }
                  if (!medicineSnapshot.hasData ||
                      medicineSnapshot.data!.isEmpty) {
                    return const Text('Không có dữ liệu thuốc');
                  }

                  final prescriptions = medicineSnapshot.data!;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(() => InfoReminder(detail: doc, pre: prescriptions,));
                        },
                        child: SwitchedBox(name: doc.name!, numReminder: doc.measureMedId!.length + doc.prescriptionId!.length, time: doc.time!, numDate: doc.numDate!, onDate: doc.onDay!, date: doc.date!, reminderId: doc.id!,)
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
        });
  }
}