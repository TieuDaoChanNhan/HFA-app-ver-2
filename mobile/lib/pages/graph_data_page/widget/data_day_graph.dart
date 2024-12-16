import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/pages/graph_data_page/widget/graph_chart.dart';

class DataDayGraph extends StatefulWidget {
  final String date;
  final MedicalEntity data;

  const DataDayGraph({super.key, required this.data, required this.date});

  @override
  State<DataDayGraph> createState() => _DataDayGraphState();
}

class _DataDayGraphState extends State<DataDayGraph> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Flexible(
                flex: 2, // Control the space for the hour and index
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                            width: 6), // Adds space between hour and index
                        Text(
                          widget.data.value!,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(() => GraphChart(
                                  y: widget.data.index!
                                      .map((e) => double.parse(e))
                                      .toList()));
                            },
                            child: const Text("Hiện đồ thị")),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }
}
