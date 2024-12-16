import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/type_med_history/controller.dart';
import 'package:health_for_all/pages/type_med_history/widget/data_day.dart';
import 'package:health_for_all/pages/type_med_history/widget/one_line_chart.dart';
import 'package:health_for_all/pages/type_med_history/widget/two_line_chart.dart';
import 'package:intl/intl.dart';

class TypeMedHistory extends StatelessWidget {
  final String title;
  final typeMedHistoryController = Get.find<TypeMedHistoryController>();

  TypeMedHistory(this.title, {super.key});
  final RxBool changePage = true.obs;
  final RxBool showComment = true.obs;
  final RxBool showDiagnostic = false.obs;
  final RxBool showAlarm = false.obs;

  @override
  Widget build(BuildContext context) {
    typeMedHistoryController.fetchEventAmountTime(title);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                changePage.value = !changePage.value;
              },
              child: changePage.value
                  ? Icon(
                      Icons.assessment_outlined,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : Icon(
                      Icons.list_outlined,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            navigate(context),
            const Divider(height: 2, color: Colors.black),
            Obx(() => changePage.value
                ? Column(
                    children: [
                      for (var i in typeMedHistoryController.result.keys)
                        DataDay(
                          day: i,
                          hour: typeMedHistoryController.result[i]!
                              .map((medical) => DateFormat('HH:mm')
                                  .format(medical.time!.toDate()))
                              .toList(),
                          index: typeMedHistoryController.result[i]!
                              .map((medical) => medical.value!)
                              .toList(),
                        ),
                    ],
                  )
                : title == "Huyết áp"
                    ? TwoLineChart(
                        show_comment: showComment.value,
                        show_diagnostic: showDiagnostic.value,
                        show_alarm: showAlarm.value,
                        title: title,
                      )
                    : OneLineChart(
                        show_comment: showComment.value,
                        show_diagnostic: showDiagnostic.value,
                        show_alarm: showAlarm.value,
                        title: title,
                      )),
          ],
        ),
      ),
    );
  }

  Widget navigate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDateRange: DateTimeRange(
                      start: typeMedHistoryController.rangeStart.value,
                      end: typeMedHistoryController.rangeEnd.value,
                    ),
                  );
                  if (picked != null) {
                    typeMedHistoryController.rangeStart.value = picked.start;
                    typeMedHistoryController.rangeEnd.value = picked.end;
                    typeMedHistoryController.result.clear();
                    typeMedHistoryController.state.commmentList.clear();
                    typeMedHistoryController.state.diagnosticList.clear();
                    await typeMedHistoryController.fetchEventAmountTime(title);
                    for (var value in typeMedHistoryController.result.values) {
                      for (var medical in value) {
                        if (medical.id != null) {
                          await typeMedHistoryController
                              .getAllCommentByMedicalType(medical.id!);
                        }
                        // if (medical.id != null) {
                        //   typeMedHistoryController.state.diagnosticList.add(medical.diagnostic!);
                        // }
                      }
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Obx(
                      () => Text(
                        DateFormat('dd/MM/yyyy')
                            .format(typeMedHistoryController.rangeStart.value),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      " - ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                    Obx(
                      () => Text(
                        DateFormat('dd/MM/yyyy')
                            .format(typeMedHistoryController.rangeEnd.value),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
            /*GestureDetector(
              onTap: () {
                showComment.value = true;
                showAlarm.value = false;
                showDiagnostic.value = false;
              },
              child: icon_round(context, showComment.value,
                  icon: Icons.comment_outlined),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                showComment.value = false;
                showAlarm.value = false;
                showDiagnostic.value = true;
              },
              child: image_round(
                  context, showDiagnostic.value, "assets/images/result2.png"),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                showComment.value = false;
                showAlarm.value = true;
                showDiagnostic.value = false;
              },
              child: icon_round(context, showAlarm.value,
                  icon: Icons.warning_amber_outlined),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget icon_round(BuildContext context, bool choose, {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: choose
            ? Theme.of(context).colorScheme.inversePrimary
            : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 18,
      ),
    );
  }

  Widget image_round(BuildContext context, bool choose, String path) {
    return Container(
      decoration: BoxDecoration(
        color: choose
            ? Theme.of(context).colorScheme.inversePrimary
            : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(
        path,
        height: 18,
        width: 18,
      ),
    );
  }

  Widget _buildDateTimeField(BuildContext context, String label, IconData icon,
      TextEditingController controller,
      {required double width}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        readOnly: true,
      ),
    );
  }
}
