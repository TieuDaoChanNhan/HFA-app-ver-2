import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditReminder extends StatefulWidget {
  const EditReminder({super.key});

  @override
  State<EditReminder> createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
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
                "Sửa nhắc nhở",
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
          Wrap(
            children: [
              choice("T2"),
              const SizedBox(
                width: 4,
              ),
              choice("T3"),
              const SizedBox(
                width: 4,
              ),
              choice("T4"),
              const SizedBox(
                width: 4,
              ),
              choice("T5"),
              const SizedBox(
                width: 4,
              ),
              choice("T6"),
              const SizedBox(
                width: 4,
              ),
              choice("T7"),
              const SizedBox(
                width: 4,
              ),
              choice("CN"),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          _buildDialogTextField(
              "Tên nhắc nhở", "Tên nhăc nhở", TextEditingController()),
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
          _buildDialogTextField("Mô tả", "Mô tả", TextEditingController()),
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
                  Get.back();
                },
                child: Text(
                  "Xóa",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
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

  final List<String> _selectedChoices = [];
  Widget choice(String name) {
    bool isSelected = _selectedChoices.contains(name);

    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 3) / 5,
      child: ChoiceChip(
        label: Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        selected: isSelected,
        selectedColor: Theme.of(context).colorScheme.secondaryContainer,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedChoices.add(name);
            } else {
              _selectedChoices.remove(name);
            }
          });
        },
      ),
    );
  }

  Widget date_time() {
    return Container(
      child: Row(
        children: [
          _buildDateTimeField(
            context,
            'Thời gian',
            Icons.today,
            selectDate,
            TextEditingController(),
            width: (MediaQuery.of(context).size.width - 80) / 2,
          ),
          const SizedBox(
            width: 12,
          ),
          _buildDateTimeField(
            context,
            'Ngày hết hạn',
            Icons.today,
            selectDate,
            TextEditingController(),
            width: (MediaQuery.of(context).size.width - 80) / 2,
          ),
        ],
      ),
    );
  }

  final dateController = TextEditingController();
  DateTime datetime = DateTime.now();

  // Replace this with your actual method to select date
  Future<void> selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: datetime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      datetime = selectedDate;
      final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      dateController.text = formattedDate;
    }
  }

  Widget _buildDateTimeField(
      BuildContext context,
      String label,
      IconData icon,
      Future<void> Function(BuildContext) onTap,
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
        onTap: () => onTap(context),
      ),
    );
  }

  String dropdownValue = 'Loại dữ liệu';

  List<String> list1 = <String>[
    "Loại dữ liệu",
    "1 loại dữ liệu",
    "2 loại dữ liệu",
    "3 loại dữ liệu",
    "4 loại dữ liệu",
    "5 loại dữ liệu",
    "6 loại dữ liệu",
    "7 loại dữ liệu",
  ];

  Widget drop_alt1() {
    return DropdownMenu(
      label: const Text("Nhắc nhở các loại dữ liệu y tế"),
      width: MediaQuery.sizeOf(context).width - 32,
      initialSelection: dropdownValue,
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list1.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }

  List<String> list2 = <String>[
    "Loại dữ liệu",
    "1 đơn thuốc",
    "2 đơn thuốc",
    "3 đơn thuốc",
    "4 đơn thuốc",
    "5 đơn thuốc",
    "6 đơn thuốc",
    "7 đơn thuốc",
  ];

  Widget drop_alt2() {
    return DropdownMenu(
      label: const Text("Nhắc nhở các đơn thuốc"),
      width: MediaQuery.sizeOf(context).width - 32,
      initialSelection: dropdownValue,
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list2.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
