import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String dropdownValue = 'Tất cả'; // Initialize dropdownValue here

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1.05,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Icon(
                    Icons.filter_list,
                    size: 24,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: Text(
                      "Lọc đơn thuốc",
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Text(
                    "Mặc định",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  type_med(),
                  range_start(),
                  range_end(),
                  status(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> list = <String>['Tất cả'];

  Widget type_med() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Loại thuốc",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownMenu(
          width: MediaQuery.sizeOf(context).width - 32,
          initialSelection: dropdownValue,
          onSelected: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          dropdownMenuEntries:
              list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget range_start() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Từ ngày",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildDateTimeField(
                context,
                'Bắt đầu',
                Icons.today,
                selectDate,
                TextEditingController(),
                width: (MediaQuery.of(context).size.width - 44) / 2,
              ),
              const SizedBox(
                width: 12,
              ),
              _buildDateTimeField(
                context,
                'Kết thúc',
                Icons.today,
                selectDate,
                TextEditingController(),
                width: (MediaQuery.of(context).size.width - 44) / 2,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget range_end() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Tới ngày",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              _buildDateTimeField(
                context,
                'Bắt đầu',
                Icons.today,
                selectDate,
                TextEditingController(),
                width: (MediaQuery.of(context).size.width - 44) / 2,
              ),
              const SizedBox(
                width: 12,
              ),
              _buildDateTimeField(
                context,
                'Kết thúc',
                Icons.today,
                selectDate,
                TextEditingController(),
                width: (MediaQuery.of(context).size.width - 44) / 2,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget status() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Trạng thái",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              choice("Đang uống"),
              const SizedBox(
                width: 24,
              ),
              choice("Hoàn thành"),
            ],
          ),
        ],
      ),
    );
  }

  final List<String> _selectedChoices = [];
  Widget choice(String name) {
    bool isSelected = _selectedChoices.contains(name);

    return ChoiceChip(
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
}
