import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';

class AlertScreen extends StatelessWidget {
  AlertScreen({super.key});

  final controller = Get.find<OverallMedicalDataHistoryController>();
  @override
  Widget build(BuildContext context) {
    int numAlert = 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              size: 24,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Cảnh báo ($numAlert)",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
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
              child: ListView.builder(
                itemCount: controller.state.diagnosticList.length,
                itemBuilder: (context, index) {
                  final diagnostic = controller.state.diagnosticList[index];
                  return FutureBuilder<String>(
                    future: controller.getUser(diagnostic.fromUId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final name = snapshot.data ?? 'Unknown';
                        return Column(
                          children: [
                            buildDiagnosticBox(diagnostic, context, name),
                            const SizedBox(
                              height: 16,
                            )
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // Get.to(() => DiagnosticAddView(
            //     user: controller.state.selectedUser.value,
            //     medicalData: controller.state.selectedData.value));
          },
          child: Container(
            color: Colors.transparent,
            width: double
                .infinity, // Ensures the container takes the full width of its parent
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  "Cài đặt cảnh báo",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        )
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
              Text('Đã bình luận'),
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
