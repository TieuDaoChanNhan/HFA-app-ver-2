import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/diagnostic_add/view.dart';
import 'package:health_for_all/pages/following/controller.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';

class DiagnosticScreen extends StatelessWidget {
  DiagnosticScreen({super.key});

  final controller = Get.find<OverallMedicalDataHistoryController>();
  final FollowingController followingController =
      Get.find<FollowingController>();
  final appController = Get.find<ApplicationController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.health_and_safety_outlined,
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Obx(() =>
                Text('Chẩn đoán (${controller.state.diagnosticCount.value})'))
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainer),
              padding: const EdgeInsets.all(8),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('diagnostic')
                    .where('medicalId',
                        isEqualTo: controller.state.medicalId.value)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No diagnostics found'));
                  } else {
                    final diagnostics = snapshot.data!.docs
                        .map((doc) => Diagnostic.fromFirestore(
                            doc as QueryDocumentSnapshot<Map<String, dynamic>>))
                        .toList();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.state.diagnosticCount.value =
                          diagnostics.length;
                    });
                    return ListView.builder(
                      itemCount: diagnostics.length,
                      itemBuilder: (context, index) {
                        final diagnostic = diagnostics[index];
                        return FutureBuilder<String>(
                          future: controller.getUser(diagnostic.fromUId!),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            } else {
                              final name = userSnapshot.data ?? 'Unknown';
                              return Column(
                                children: [
                                  buildDiagnosticBox(diagnostic, context, name),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              controller
                  .fetchData(appController.state.profile.value!.relatives!);
              Get.to(() => Obx(() => DiagnosticAddView(
                  user: appController.state.selectedUser.value,
                  medicalData: controller.state.selectedData.value)));
            },
            child: Container(
              color: Colors.transparent,
              width: double
                  .infinity, // Ensures the container takes the full width of its parent
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 24,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    "Thêm chẩn đoán",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Widget buildDiagnosticBox(
      Diagnostic diagnostic, BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surfaceContainerLowest),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                size: 16,
              ),
              const SizedBox(
                width: 6,
              ),
              const Text("·"),
              const SizedBox(
                width: 6,
              ),
              Text(name),
              const SizedBox(
                width: 6,
              ),
              const Text("·"),
              const SizedBox(
                width: 6,
              ),
              Text(
                '${DatetimeChange.getHourString(diagnostic.timestamp!.toDate())}, ${DatetimeChange.getDatetimeString(diagnostic.timestamp!.toDate())}',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              // Spacer(),
              // Obx(() => IconButton(
              //     onPressed: () {
              //       isExpanded.value = !isExpanded.value;
              //     },
              //     icon: isExpanded.value
              //         ? const Icon(Icons.keyboard_arrow_up_rounded)
              //         : const Icon(Icons.keyboard_arrow_down_rounded)))
            ],
          ),
          const Row(
            children: [
              Text('Đã chẩn đoán'),
              SizedBox(
                width: 6,
              ),
              // const Text("·"),
              // const SizedBox(
              //   width: 6,
              // ),
            ],
          ),
          Text(diagnostic.content!)
        ],
      ),
    );
  }
}
