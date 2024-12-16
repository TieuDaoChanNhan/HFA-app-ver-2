import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/diagnostic_add/controller.dart';

class DoctorDiagnostic extends StatelessWidget {
  final String note;
  final controller = Get.find<DiagnosticAddController>();

  DoctorDiagnostic({
    super.key,
    required this.note,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      // minLines: 3,
      readOnly: true,
      maxLines: 3,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant, width: 1),
        ),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.edit_note,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
      controller: TextEditingController(text: note),
    );
  }
}
