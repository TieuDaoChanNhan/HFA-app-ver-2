import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/enum/type_diagnostic_status.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/diagnostic/controller.dart';
import 'package:health_for_all/pages/diagnostic/widget/animated_container.dart';

class DiagnosticScreen extends StatelessWidget {
  final UserData user;
  const DiagnosticScreen({
    super.key,
    required this.status,
    required this.user,
  });
  final TypeDiagnosticStatus status;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiagnosticController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('diagnostic')
                  .where('toUId', isEqualTo: user.id)
                  .where('status', isEqualTo: status.value)
                  // .where('timestamp',
                  //     isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(
                  //         0)) // Filters out null timestamps
                  // .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No diagnostics found.'));
                }
                final diagnostics = snapshot.data!.docs
                    .map((doc) => Diagnostic.fromFirestore(
                        doc as DocumentSnapshot<Map<String, dynamic>>))
                    .toList();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (status == TypeDiagnosticStatus.unread) {
                    controller.state.unread.value =
                        diagnostics.isNotEmpty ? diagnostics.length : 0;
                    log('unread: ${controller.state.unread.value}');
                  }
                  if (status == TypeDiagnosticStatus.read) {
                    controller.state.read.value =
                        diagnostics.isNotEmpty ? diagnostics.length : 0;
                    log('read: ${controller.state.read.value}');
                  }
                  if (status == TypeDiagnosticStatus.importance) {
                    controller.state.importance.value =
                        diagnostics.isNotEmpty ? diagnostics.length : 0;
                    log('importance: ${controller.state.importance.value}');
                  }
                });
                log('status: ${status.value}');
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: diagnostics.length,
                  itemBuilder: (context, index) {
                    final diagnostic = diagnostics[index];
                    return FutureBuilder<String>(
                      future: controller.getNameByUId(diagnostic.fromUId!),
                      builder: (context, nameSnapshot) {
                        if (nameSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final doctor = nameSnapshot.data ?? 'Unknown';
                        print(index);
                        print(diagnostic);
                        return FutureBuilder(
                          future: controller.getData(diagnostic.medicalId!),
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

                            final medicaldata = medicalSnapshot.data!;
                            return animatedcontainer(
                              doctor: doctor,
                              time: DatetimeChange.timestamptoHHMMDDMMYYYY(
                                  diagnostic.timestamp!),
                              med: medicaldata,
                              notification: diagnostic.content!,
                              isimportance: false.obs,
                              attachments: diagnostic.imageURL!,
                              isExpanded: false.obs,
                              user: user,
                              documentId: diagnostic.id!,
                              status: diagnostic.status!,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
