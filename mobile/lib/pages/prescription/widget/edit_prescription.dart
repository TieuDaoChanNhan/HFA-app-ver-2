import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/pages/choose_type_med/view.dart';
import 'package:health_for_all/pages/prescription/controller.dart';
import 'package:health_for_all/pages/prescription/widget/add_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditPrescription extends StatefulWidget {
  final Prescription detail;
  final List<MedicineBase> med;
  const EditPrescription({super.key, required this.detail, required this.med});

  @override
  State<EditPrescription> createState() => _EditPrescriptionState();
}

class _EditPrescriptionState extends State<EditPrescription> {
  final PrescriptionController prescriptionController =
      Get.put(PrescriptionController());
  List<XFile> selectedFiles = [];
  void updateFiles(List<XFile> newFiles) {
    setState(() {
      selectedFiles = newFiles;
      for (var i in selectedFiles) {
        log('combobox : ${i.path}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
          ),
          header(),
          const SizedBox(
            height: 24,
          ),
          name(),
          const SizedBox(
            height: 24,
          ),
          med_list(),
          const SizedBox(
            height: 24,
          ),
          choose_date(),
          const SizedBox(
            height: 24,
          ),
          Flexible(
              child: AddFilePrescription(
            files: widget.detail.files,
            onFilesChanged: updateFiles,
          )),
          const SizedBox(
            height: 24,
          ),
          _buildDialogTextField('Ghi chú', 'Ghi chú',
              TextEditingController(text: widget.detail.note)),
          const SizedBox(
            height: 55,
          ),
          build_button(),
        ],
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        Icon(
          Icons.medication_liquid_sharp,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 16,
        ),
        Text(
          "Sửa đơn thuốc",
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget name() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: widget.detail.name),
        decoration: InputDecoration(
          label: const Text("Tên đơn thuốc"),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          )),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget med_list() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Danh sách thuốc",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ChooseTypeMed());
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (var i = 0; i < widget.med.length; i++)
                  choose_med(
                    widget.med[i],
                    i,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget choose_med(MedicineBase medicineBase, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 95) / 6 * 3.4,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: medicineBase.name),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      )),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 95) / 6 * 1.2,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: widget.detail.medicineDose![index]),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      )),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.clear,
                    size: 24,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }

  Widget choose_date() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDateTimeField(
          context,
          'Bắt đầu',
          Icons.today,
          TextEditingController(text: widget.detail.startDate),
          width: (MediaQuery.of(context).size.width - 70) / 2 - 6,
        ),
        const SizedBox(
          width: 12,
        ),
        _buildDateTimeField(
          context,
          'Kết thúc',
          Icons.today,
          TextEditingController(text: widget.detail.endDate),
          width: (MediaQuery.of(context).size.width - 70) / 2 - 6,
        ),
      ],
    );
  }

  DateTime datetime = DateTime.now();

  // Replace this with your actual method to select date
  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: datetime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        datetime = selectedDate;
        final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
        controller.text = formattedDate; // Update the respective controller
      });
    }
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
        onTap: () =>
            selectDate(context, controller), // Pass the controller here
      ),
    );
  }

  Widget _buildDialogTextField(
      String label, String hint, TextEditingController controller,
      {IconData? icon}) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 16,
        ),
        border: const OutlineInputBorder(),
        prefixIcon: icon != null
            ? Icon(icon, color: Theme.of(context).colorScheme.primary)
            : null,
      ),
    );
  }

  Widget build_button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () async {
            Get.back();
          },
          child: Text(
            'Đóng',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () async {
            prescriptionController.delPrescription(widget.detail.id!);
            Get.back();
          },
          child: Text(
            'Xóa',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () async {
            Get.back();
          },
          child: Text(
            'Xác nhận',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
