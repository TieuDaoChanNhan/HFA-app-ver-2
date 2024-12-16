import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/pages/prescription/controller.dart';
import 'package:health_for_all/pages/prescription/widget/prescription_detail.dart';
import 'package:intl/intl.dart';

class PrescriptionBox extends StatefulWidget {
  final Prescription detail;
  final List<MedicineBase> med;
  final int order;

  const PrescriptionBox({
    super.key,
    required this.detail,
    required this.med,
    required this.order,
  });

  @override
  State<PrescriptionBox> createState() => _PrescriptionBoxState();
}

class _PrescriptionBoxState extends State<PrescriptionBox> {
  final PrescriptionController prescriptionController =
      Get.put(PrescriptionController());
  DateTime convertStringtoTime(String date) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime dateTime = format.parse(date);
    return dateTime;
  }

  DateTime getYesterdayTimestamp() {
    DateTime now = DateTime.now(); // Get the current date and time
    DateTime yesterday =
        now.subtract(const Duration(days: 1)); // Subtract one day
    return yesterday; // This returns the DateTime object for yesterday
  }

  bool compareTimestamps(DateTime timestamp1, DateTime timestamp2) {
    return timestamp1
        .isAfter(timestamp2); // true if timestamp1 is before timestamp2
  }

  @override
  Widget build(BuildContext context) {
    bool check = compareTimestamps(
        convertStringtoTime(widget.detail.endDate!), getYesterdayTimestamp());
    return GestureDetector(
      onTap: () {
        Get.to(() => PrescriptionDetail(
              detail: widget.detail,
              med: widget.med,
              order: widget.order,
            ));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: check
                  ? Theme.of(context).colorScheme.surfaceContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medication_liquid_sharp,
                      color: check
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.detail.name!,
                          style: TextStyle(
                            fontSize: 14,
                            color: check
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Text(
                          "${widget.med.length} loại thuốc, ${widget.detail.sumDose} viên",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Từ ngày:  ${widget.detail.startDate}",
                          style: TextStyle(
                            color: check
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Tới ngày: ${widget.detail.endDate}",
                          style: TextStyle(
                            color: check
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        prescriptionController
                            .delPrescription(widget.detail.id!);
                      },
                      child: Icon(Icons.clear_outlined,
                          size: 20, color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
