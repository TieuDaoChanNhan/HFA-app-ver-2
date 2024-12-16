import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/pages/reminder/controller.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class AddReminder extends StatefulWidget {
  final String userId;
  const AddReminder({super.key, required this.userId});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final reminderController = Get.put(ReminderController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Icon(
                Icons.edit_calendar_outlined,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                "Thêm nhắc nhở",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          body(),
        ],
      ),
    );
  }

  Widget MyTextField(
      String name, String hint, TextEditingController controller) {
    return SizedBox(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: name,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.outline,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          date_time(),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              for (int i = 0; i < 4; i++) choice(i),
            ],
          ),
          Row(
            children: [
              for (int i = 4; i < 7; i++) choice(i),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          _buildDialogTextField("Tên nhắc nhở", "Tên nhăc nhở",
              reminderController.nameController),
          const SizedBox(
            height: 24,
          ),
          drop_alt1(),
          const SizedBox(
            height: 24,
          ),
          drop_alt2(),
          const SizedBox(
            height: 24,
          ),
          _buildDialogTextField(
              "Ghi chú", "Ghi chú", reminderController.noteController),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  reminderController.clearData();
                  Get.back();
                },
                child: Text(
                  "Đóng",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  reminderController.addReminder(widget.userId);
                  reminderController.clearData();
                  Get.back();
                },
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
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

  Widget choice(int index) {
    bool isSelected = reminderController.onDate[index];

    return Row(
      children: [
        SizedBox(
          width: (MediaQuery.sizeOf(context).width - 3) / 5,
          child: ChoiceChip(
            label: Text(
              reminderController.nameDate[index],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            selected: isSelected,
            selectedColor: Theme.of(context).colorScheme.secondaryContainer,
            onSelected: (bool selected) {
              setState(() {
                reminderController.onDate[index] =
                    !reminderController.onDate[index];
              });
            },
          ),
        ),
      ],
    );
  }

  Widget date_time() {
    return Row(
      children: [
        _buildDateTimeField(
          context,
          'Thời gian',
          Icons.access_time,
          reminderController.timeController,
          isTimeField: true, // This is for the time picker
          width: (MediaQuery.of(context).size.width - 80) / 2,
        ),
        const SizedBox(
          width: 12,
        ),
        _buildDateTimeField(
          context,
          'Ngày hết hạn',
          Icons.today,
          reminderController.dueDateController,
          width: (MediaQuery.of(context).size.width - 80) / 2,
        ),
      ],
    );
  }

  Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      controller.text = formattedTime;
    }
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
      {required double width, bool isTimeField = false}) {
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
        onTap: () {
          if (isTimeField) {
            selectTime(context, controller); // Show time picker
          } else {
            selectDate(context, controller); // Show date picker
          }
        },
      ),
    );
  }

  Widget drop_alt1() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('prescriptions').where('patientId', isEqualTo: reminderController.state.profile.value?.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while fetching
        }

        final prescriptions = snapshot.data!.docs
            .map((doc) => Prescription.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();

        reminderController.prescriptionList.value = prescriptions;

        return Obx(() => Column(
          children: [
            MultiSelectDialogField(
              items: prescriptions
                  .map((prescription) => MultiSelectItem<Prescription>(
                      prescription, prescription.name!))
                  .toList(),
              title: const Text("Chọn đơn thuốc"),
              selectedColor: Colors.blue,
              buttonText: Text(
                reminderController.selectedPrescriptions.isEmpty
                    ? "Chưa có đơn thuốc nào được chọn"
                    : "${reminderController.selectedPrescriptions.length} đơn thuốc đã được chọn",
              ),
              onConfirm: (values) {
                reminderController.selectedPrescriptions.value =
                    values.cast<Prescription>();
              },
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ],
        ));
      },
    );
  }

  Widget drop_alt2() {
    reminderController.fetchMedicalData();
    return Column(
      children: [
        MultiSelectDialogField(
          items: reminderController.medDataList
              .map((med) => MultiSelectItem<int>(med, Item.getTitle(med)))
              .toList(),
          title: const Text("Chọn loại dữ liệu y tế"),
          selectedColor: Colors.blue,
          buttonText: Text(
            reminderController.selectedMedData.isEmpty
                ? "Chưa có dữ liệu y tế nào được chọn"
                : "${reminderController.selectedMedData.length} dữ liệu y tế đã được chọn",
          ),
          onConfirm: (values) {
            setState(() {
              reminderController.selectedMedData = values.cast<int>();
            });
          },
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}