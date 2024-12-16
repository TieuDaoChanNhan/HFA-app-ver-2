import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/pages/choose_type_med/controller.dart';
import 'package:health_for_all/pages/choose_type_med/view.dart';
import 'package:health_for_all/pages/prescription/controller.dart';
import 'package:health_for_all/pages/prescription/widget/add_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPrescription extends StatefulWidget {
  final String userId;
  const AddPrescription({super.key, required this.userId});

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  final medicineController = Get.find<ChooseTypeMedController>();
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
          name(prescriptionController.nameController),
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
              files: selectedFiles,
              onFilesChanged: updateFiles,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          _buildDialogTextField(
              'Ghi chú', 'Ghi chú', prescriptionController.noteController),
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
          "Thêm đơn thuốc",
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget name(TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: TextField(
        controller: controller,
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
              child: Obx(
                () => Column(
                  children: [
                    for (var i = 0;
                        i <
                            medicineController
                                .state.selectedMedicineBases.length;
                        i++)
                      choose_med(
                        medicineController.state.selectedMedicineBases[i],
                        i,
                      ),
                  ],
                ),
              ))
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
                    controller: prescriptionController.doseControllers[index],
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
                  onTap: () {
                    prescriptionController.doseControllers.removeAt(index);
                    medicineController.state.selectedMedicineBases
                        .removeAt(index);
                    medicineController.state.selectedMedicineIndex
                        .removeAt(index);
                  },
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
          prescriptionController.startDateController,
          width: (MediaQuery.of(context).size.width - 70) / 2 - 6,
        ),
        const SizedBox(
          width: 12,
        ),
        _buildDateTimeField(
          context,
          'Kết thúc',
          Icons.today,
          prescriptionController.endDateController,
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
            medicineController.state.selectedMedicineBases.clear();
            medicineController.state.selectedMedicineIndex.clear();
            prescriptionController.clearData();
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
            for (var i = 0;
                i < medicineController.state.selectedMedicineBases.length;
                i++) {
              prescriptionController.medId.add(medicineController
                  .state.selectedMedicineBases[i].id
                  .toString());
            }
            prescriptionController.selectedFiles = selectedFiles.obs;
            try {
              EasyLoading.show(status: "Đang xử lí...");

              await prescriptionController.addPrescription(widget.userId);
              Get.snackbar("Thành công", "Thêm đơn thuốc thành công",
                  backgroundColor: Colors.green);
              Future.delayed(const Duration(seconds: 1), () {
                prescriptionController.clearData();
                medicineController.state.selectedMedicineBases.clear();
                medicineController.state.selectedMedicineIndex.clear();
                Get.back();
              });
            } catch (e) {
              log(e.toString());
              Get.snackbar("Lỗi", "Có lỗi xảy ra khi thêm đơn thuốc",
                  backgroundColor: Colors.red);
            } finally {
              EasyLoading.dismiss();
            }
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
