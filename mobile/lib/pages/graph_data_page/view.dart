import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/graph_data_page/controller.dart';
import 'package:health_for_all/pages/graph_data_page/widget/data_day_graph.dart';
import 'package:intl/intl.dart';

class GraphDataPage extends StatelessWidget {
  final String title;
  final ecgController = Get.find<EcgDataController>();

  GraphDataPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    ecgController.fetchEventAmountTime(title);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Icon(
            Icons.help_outline,
            size: 24,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            Obx(() => Column(
                  children: [
                    for (var i in ecgController.result.keys)
                      for (int j = 0; j < ecgController.result[i]!.length; j++)
                        DataDayGraph(
                          date: DateFormat('dd/MM/yyyy HH:mm').format(
                              ecgController.result[i]![j].time!.toDate()),
                          data: ecgController.result[i]![j],
                        )
                  ],
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
                      start: ecgController.rangeStart.value,
                      end: ecgController.rangeEnd.value,
                    ),
                  );
                  if (picked != null) {
                    ecgController.rangeStart.value = picked.start;
                    ecgController.rangeEnd.value = picked.end;
                    ecgController.result.clear();
                    await ecgController.fetchEventAmountTime(title);
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
                            .format(ecgController.rangeStart.value),
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
                            .format(ecgController.rangeEnd.value),
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
          ],
        ),
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
