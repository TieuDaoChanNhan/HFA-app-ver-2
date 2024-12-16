import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/common/entities/reminder.dart';
import 'package:health_for_all/pages/prescription/widget/prescription_detail.dart';
import 'package:health_for_all/pages/reminder/controller.dart';

class InfoReminder extends StatefulWidget {
  final Reminder detail;
  final List<Prescription> pre;
  const InfoReminder({super.key, required this.detail, required this.pre});

  @override
  State<InfoReminder> createState() => _InfoReminderState();
}

class _InfoReminderState extends State<InfoReminder> {
  final ReminderController controller = Get.put(ReminderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.detail.name!,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    timeDate(),
                    detail(),
                    drink(),
                    measure(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget measure() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                "Đo các loại dữ liệu y tế (${widget.detail.measureMedId!.length})",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: Column(
              children: [
                for (int i = 0; i < widget.detail.measureMedId!.length; i++)
                  data(
                      Item.getTitle(widget.detail.measureMedId![i]),
                      Item.getUnit(widget.detail.measureMedId![i]),
                      Item.getIconPath(widget.detail.measureMedId![i]),
                      "--",
                      (i == widget.detail.measureMedId!.length - 1)),
              ],
            )),
      ],
    );
  }

  Widget data(String name, String unit, String path, String index, bool last) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                path,
                height: 22,
                width: 22,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: 45,
                child: Column(
                  children: [
                    Text(
                      index,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      unit,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              Row(
                children: [
                  roundIcon(icon: Icons.edit_note_outlined),
                  const SizedBox(
                    width: 8,
                  ),
                  roundIcon(icon: Icons.attach_file_outlined),
                  const SizedBox(
                    width: 8,
                  ),
                  roundIcon(icon: Icons.clear_outlined),
                ],
              ),
            ],
          ),
        ),
        if (!last)
          const Divider(
            height: 1,
          ),
      ],
    );
  }

  Widget roundIcon({IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          )),
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.outlineVariant,
        size: 18,
      ),
    );
  }

  Widget drink() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                "Uống thuốc (${widget.detail.prescriptionId!.length})",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            border:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (int i = 0; i < widget.pre.length; i++)
                prescriptionData(
                    widget.pre[i], (i == widget.pre.length - 1), i + 1),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget prescriptionData(Prescription data, bool last, int index) {
    return FutureBuilder(
      future: controller.getMed(data.medicalIDs!),
      builder: (context, medicineSnapshot) {
        if (medicineSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (medicineSnapshot.hasError) {
          return const Text('Có lỗi xảy ra khi lấy dữ liệu thuốc');
        }
        if (!medicineSnapshot.hasData || medicineSnapshot.data!.isEmpty) {
          return const Text('Không có dữ liệu thuốc');
        }

        final medicineBases = medicineSnapshot.data!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.medication_liquid_sharp,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "${data.medicalIDs!.length} loại thuốc, ${data.sumDose} viên",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => PrescriptionDetail(
                          detail: data, med: medicineBases, order: index));
                    },
                    child: Icon(
                      Icons.open_in_new_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 18.5,
                    ),
                  )
                ],
              ),
            ),
            if (!last)
              const Divider(
                height: 1,
              ),
          ],
        );
      },
    );
  }

  Widget detail() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                "Nội dung",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: _buildDialogTextField(
              TextEditingController(text: widget.detail.note),
              icon1: Icons.edit_note),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildDialogTextField(
    TextEditingController controller, {
    IconData? icon1,
    IconData? icon2,
  }) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant, width: 1.0),
        ),
        prefixIcon: icon1 != null
            ? Icon(icon1, color: Theme.of(context).colorScheme.primary)
            : null,
        suffixIcon: icon2 != null
            ? Icon(
                icon2,
                color: Theme.of(context).colorScheme.secondary,
                size: 16,
              )
            : null,
      ),
    );
  }

  Widget timeDate() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                "Thời gian",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant)),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      widget.detail.time!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Text(
                    "Hết hạn: ${widget.detail.date}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  Widget choice(int index) {
    bool isSelected = widget.detail.onDay![index];

    return Row(
      children: [
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: (MediaQuery.sizeOf(context).width - 3) / 5,
          child: ChoiceChip(
            label: Text(
              ReminderController().nameDate[index],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            selected: isSelected,
            selectedColor: Theme.of(context).colorScheme.secondaryContainer,
            onSelected: (bool selected) {},
          ),
        ),
      ],
    );
  }
}
