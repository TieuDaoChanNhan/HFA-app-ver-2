import 'package:flutter/material.dart';

class MoreData extends StatefulWidget {
  const MoreData({super.key});

  @override
  State<MoreData> createState() => _MoreDataState();
}

class _MoreDataState extends State<MoreData> {
  final nameController = TextEditingController();
  final unitController = TextEditingController();
  final detailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              "Thêm loại dữ liệu khác",
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Thêm loại dữ liệu y tế',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  MyTextField('Tên loại dữ liệu y tế', 'Tên loại dữ liệu y tế',
                      64, nameController),
                  const SizedBox(
                    height: 16,
                  ),
                  MyTextField('Đơn vị', 'Đơn vị', 56, unitController),
                  const SizedBox(
                    height: 16,
                  ),
                  MyTextField(
                      'Mô tả', 'Mô tả dữ liệu y tế', 98, detailController),
                ]),
              ));
        });
  }

  Widget MyTextField(
      String name, String hint, double hei, TextEditingController controller) {
    return SizedBox(
      height: hei,
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
}
